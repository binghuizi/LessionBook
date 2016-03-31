//
//  MyViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "MyViewController.h"
#import "FavoriteViewController.h"
#import "RecordViewController.h"
#import "MessageViewController.h"
#import "LinkManViewController.h"
#import "TimeView.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
//账号设置
#import "AccountViewController.h"
//更多设置
#import "MoreViewController.h"
#import <EaseMob.h>
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"
#import "ZYAudioManager.h"
@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>{
    AppDelegate *myAppDelegate;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *myArray;
@property (nonatomic, retain) NSArray *detailArray;
@property (nonatomic, retain) UIView *headView;
@property (nonatomic, retain) UIButton *loginBtn;
@property (nonatomic, retain) UIImageView *userImageView;


//定时关闭的属性
@property (nonatomic, retain) UIView *timeView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *timeUpView;
@property (nonatomic, strong) UILabel *timeShowLabel;
@property (nonatomic, assign) BOOL timeStart;
@property (nonatomic, assign) NSInteger tg;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UISwitch *Switch;
@property (nonatomic, retain) UILabel *welcomeLabel;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.myArray = [NSArray arrayWithObjects:@"我的收藏", @"最近收听", @"定时关闭", @"更多设置", @"书友畅聊", @"账号设置", nil];
    self.detailArray = [NSArray arrayWithObjects:@"暂无收藏", @"暂无收听记录", @"", @"", @"", @"",nil];
    [self confineHeadView];
    [self.view addSubview:self.tableView];
    
}

//将要显示
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.tabBarController.tabBar.translucent = NO;
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        NSString *url = [user objectForKey:@"imageUrl"];
        self.loginBtn.hidden = YES;
        self.userImageView.hidden = NO;
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"a040144d464bf201a150a57abf8f8292"]];
        self.welcomeLabel.text = user.username;
    }else{
        self.userImageView.hidden = YES;
        [self.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        self.loginBtn.hidden = NO;
        self.welcomeLabel.text = @"欢迎来到马里亚纳听书";
    }
    //刷新tableview
    [self.tableView reloadData];
    
}


//行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.myArray.count;
}


//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = self.detailArray[indexPath.row];
     cell.textLabel.text = self.myArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"userinfo_collection"];
    }else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"userinfo_history"];
    }else if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"userinfo_timer"];
    }else if (indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"userinfo_setting"];
    }else if (indexPath.row == 4){
        cell.imageView.image = [UIImage imageNamed:@"exp_watch"];
    }else if (indexPath.row == 5){
        cell.imageView.image = [UIImage imageNamed:@"notification"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
           
                BmobUser *user = [BmobUser getCurrentUser];
                if (user != nil) {
                    FavoriteViewController *favoriteVC = [[FavoriteViewController alloc] init];
                    
                    
                    [self.navigationController pushViewController:favoriteVC animated:YES];

                
                    }else{
                UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
                
                LoginViewController *loginVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }
            break;
        case 1:
        {
           RecordViewController *recordVC = [[RecordViewController alloc] init];
           [self.navigationController pushViewController:recordVC animated:YES];
        }
            break;
        case 2:
        {
            [self openTimeView];
            
//            TimeView *timeView = [[TimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//            UIWindow *window = [[UIApplication sharedApplication].delegate window];
//            [window addSubview:timeView];
        }
            break;
        case 3:
        {
            MoreViewController *moreVC = [[MoreViewController alloc] init];
            [self.navigationController pushViewController:moreVC animated:YES];
        }
            break;
        case 4:
        {

            BmobUser *user = [BmobUser getCurrentUser];
            if (user != nil) {
                UITabBarController *chatTabBarC = [[UITabBarController alloc] init];
                MessageViewController *messageVC = [[MessageViewController alloc] init];
                UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
                messageNav.tabBarItem.title = @"消息";
                messageNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_chatsHL"];
                LinkManViewController *linkVC = [[LinkManViewController alloc] init];
                UINavigationController *linkNav = [[UINavigationController alloc] initWithRootViewController:linkVC];
                linkNav.tabBarItem.title = @"好友";
                linkNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_contactsHL"];
                chatTabBarC.viewControllers = @[messageNav, linkNav];
                [self.navigationController presentViewController:chatTabBarC animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        //退出登录
        case 5:
        {
            BmobUser *user = [BmobUser getCurrentUser];
            if (user != nil) {
                AccountViewController *accountVC = [[AccountViewController alloc] init];
                [self.navigationController pushViewController:accountVC animated:YES];
            }else{
                UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
                
                LoginViewController *loginVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
                [self.navigationController pushViewController:loginVC animated:YES];
            }

        }
            break;
        default:
            break;
    }
}
#pragma mark -------------- 定时关机功能

//定时关闭
- (void)openTimeView{
    if (self.timer) {
        self.timeView.hidden = NO;
        return;
    }
//   UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.timeView = [[TimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    [self.timeView addSubview:self.blackView];
    
    //添加手势
    //初始化 创建一个轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //点击次数
    tap.numberOfTapsRequired = 1;
    //手指个数
    tap.numberOfTouchesRequired =1;
    //把手势添加到视图上
    [self.blackView addGestureRecognizer:tap];
    self.timeUpView = [[UIView alloc] initWithFrame:CGRectMake(40, kHeight - 400, 295, 250)];
    self.timeUpView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:220/255.0 alpha:1];
    
    self.timeShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 50)];
    //    self.timeShowLabel.text = @"定时关机";
    NSArray *timeArray = [NSArray arrayWithObjects:@"10分钟", @"20分钟", @"30分钟", @"60分钟", @"90分钟", @"120分钟", nil];
    
    self.Switch = [[UISwitch alloc] initWithFrame:CGRectMake(230, 10, 45, 30)];
    [self.Switch addTarget:self action:@selector(timeUpGo:) forControlEvents:UIControlEventValueChanged];
    self.Switch.backgroundColor = [UIColor whiteColor];
    [self.timeUpView addSubview:self.Switch];
    for (int i = 0; i < 6; i++) {
        UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timeBtn.frame = CGRectMake((i % 3) * 100, 50 + (i / 3) * 100, 95, 95);
        [timeBtn setTitle:timeArray[i] forState:UIControlStateNormal];
        [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        timeBtn.tag = i;
        timeBtn.backgroundColor = [UIColor whiteColor];
        [timeBtn addTarget:self action:@selector(timeUpStart:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeUpView addSubview:timeBtn];
    }
    [self.timeUpView addSubview:self.timeShowLabel];
    [self.timeView addSubview:self.timeUpView];
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.2;
    }];
    
    
    
    
    [self.view addSubview:self.timeView];
    
}
- (void)timeUpGo:(UISwitch *)sswitch{
    if (sswitch.on) {
        self.tg = 0;
        [self timeUpStart:nil];
    }
    else{
        self.timeShowLabel.text = @"定时关机";
          [self.timer invalidate];
        self.timer = nil;
        self.timeStart = NO;
    }
}
//定时按钮点击
- (void)timeUpStart:(UIButton *)btn{
    //这里是创建定时器的方法。因为button和switch都能创建定时器，所以为了避免重复创建定时器，定时器停不下来，就用下面的方法，如果timer存在，就跳出这个方法，不在创建定时器.
    if (self.timer) {
        self.Switch.on = YES;
        self.tg = btn.tag;
        self.timeStart = YES;
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    self.tg = btn.tag;
    self.timeStart = YES;
    self.Switch.on = YES;
 
}
- (void)timerFireMethod:(NSTimer *)theTimer{
    
    NSArray *minuteArray = [NSArray arrayWithObjects:@"10", @"20", @"30", @"60", @"90", @"120", nil];
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];
    NSDate *date = [NSDate dateWithTimeInterval:[minuteArray[self.tg] integerValue] * 60 sinceDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    //    self.timeShowLabel.text = [NSString stringWithFormat:@"定时关机 %@", dateString];
    static int year;
    
    static int month;
    
    static int day;
    
    static int hour;
    
    static int minute;
    
    static int second;
    
    if(self.timeStart) {//从NSDate中取出年月日，时分秒，但是只能取一次
        
        year = [[dateString substringWithRange:NSMakeRange(0, 4)] intValue];
        
        month = [[dateString substringWithRange:NSMakeRange(5, 2)] intValue];
        
        day = [[dateString substringWithRange:NSMakeRange(8, 2)] intValue];
        
        hour = [[dateString substringWithRange:NSMakeRange(11, 2)] intValue];
        
        minute = [[dateString substringWithRange:NSMakeRange(14, 2)] intValue];
        
        second = [[dateString substringWithRange:NSMakeRange(17, 2)] intValue];
        
        self.timeStart= NO;
        
    }
    [endTime setYear:year];
    
    [endTime setMonth:month];
    
    [endTime setDay:day];
    
    [endTime setHour:hour];
    
    [endTime setMinute:minute];
    
    [endTime setSecond:second];
    
    NSDate *todate = [cal dateFromComponents:endTime];
    //用来得到具体的时差，是为了统一成北京时间
    //NSDateComponents封装在一个可扩展的，面向对象的方式的日期组件。它是用来弥补时间的日期和时间组件提供一个指定日期：小时，分钟，秒，日，月，年，等等。它也可以用来指定的时间，例如，5小时16分钟。
    unsigned int unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit| NSSecondCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:todate options:0];
    //    NSInteger diffHour = [cps hour];
    //
    //    NSInteger diffMin    = [cps minute];
    //
    //    NSInteger diffSec   = [cps second];
    
    //    NSInteger diffDay   = [cps day];
    //
    //    NSInteger diffMon  = [cps month];
    //
    //    NSInteger diffYear = [cps year];
    
    NSInteger shi = [d hour];
    
    NSString *fen = [NSString stringWithFormat:@"%ld", [d minute]];
    
    if([d minute] < 10) {
        
        fen = [NSString stringWithFormat:@"0%ld", [d minute]];
        
    }
    
    NSString *miao = [NSString stringWithFormat:@"%ld", [d second]];
    
    if([d second] < 10) {
        
        miao = [NSString stringWithFormat:@"0%ld",[d second]];
        
    }
    
    
    if(shi > 0 || [d minute] > 0 || [d second] > 0) {
        //计时尚未结束，do_something
        if (shi > 0) {
            self.timeShowLabel.text = [NSString stringWithFormat:@"定时关机  %ldh %@' %@''", shi, fen, miao];
        }else{
            self.timeShowLabel.text = [NSString stringWithFormat:@"定时关机  %@ ' %@''", fen, miao];
        }
        
    } else if(shi == 0 && [d second] == 0 && [d minute] == 0) {
        //倒计时结束，do_something
        
        [self.timer invalidate];
        self.timeShowLabel.text = @"time up";
        
        [[ZYAudioManager defaultManager]stopMusic:myAppDelegate.detailModel.download];
        
    }
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.5 animations:^{
        //        [self removeFromSuperview];
        //        self.timeUpView.hidden = YES;
        //        [self.blackView removeFromSuperview];
        self.timeView.hidden = YES;
        
    } completion:^(BOOL finished) {
        
    }];
}


//自定义头部
- (void)confineHeadView{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 200)];
    self.tableView.tableHeaderView = self.headView;
    self.headView.backgroundColor = [UIColor colorWithRed:0 green:201/255.0f blue:255/255.0f alpha:1.0];

    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(20, 70, 100, 100);
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 90, 60, 60)];
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.cornerRadius = 30;
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.layer.cornerRadius = 50;
    self.loginBtn.backgroundColor = [UIColor whiteColor];
    [self.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    self.welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 100, 250, 30)];
    self.welcomeLabel.textColor = [UIColor whiteColor];
    self.welcomeLabel.text = @"欢迎来到马里亚纳听书";
    
//    BmobUser *User = [[BmobUser alloc] init];
//    BmobUser *bUser = [BmobUser getCurrentUser];
//    if (bUser) {
//        //已登录
//        self.userImageView.hidden = NO;
//        User.username = myAppDelegate.dic[@"screen_name"];
//       self.welcomeLabel.text = User.username;
//        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:myAppDelegate.dic[@"avatar_hd"]] placeholderImage:nil];
//        NSLog(@"1");
//    }else{
//        //未登录
//        self.loginBtn.hidden = NO;
//        self.userImageView.hidden = YES;
//
//        [self.loginBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];
//       self.welcomeLabel.text = @"欢迎来到马里亚纳听书";
//        NSLog(@"2");
//    }
//    self.loginBtn.backgroundColor = [UIColor redColor];
//    self.userImageView.backgroundColor = [UIColor whiteColor];
//    welcomeLabel.backgroundColor = [UIColor blackColor];
    
    [self.headView addSubview:self.loginBtn];
    [self.headView addSubview:self.welcomeLabel];
    [self.headView addSubview:self.userImageView];
}
//登录注册按钮
- (void)loginAction{
    if (myAppDelegate.isLogin == 0) {
        UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        LoginViewController *loginVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        
    }
}


- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 80;
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
