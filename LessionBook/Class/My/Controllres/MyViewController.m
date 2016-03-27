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

//账号设置
#import "AccountViewController.h"

#import <EaseMob.h>
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>{
    AppDelegate *myAppDelegate;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *myArray;
@property (nonatomic, retain) NSArray *detailArray;
@property (nonatomic, retain) UIView *headView;
@property (nonatomic, retain) UIView *timeUpView;
@property (nonatomic, retain) UIButton *loginBtn;
@property (nonatomic, retain) UIImageView *userImageView;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.myArray = [NSArray arrayWithObjects:@"我的收藏", @"最近收听", @"定时关闭", @"更多设置", @"书友畅聊", @"账号设置", nil];
    self.detailArray = [NSArray arrayWithObjects:@"暂无收藏", @"暂无收听记录", @"", @"", @"", @"",nil];
    [self.view addSubview:self.tableView];
    
}

//将要显示
-(void)viewWillAppear:(BOOL)animated{


    //刷新头视图
    [self confineHeadView];
    //刷新tableview
//    [self.tableView reloadData];

//    if (myAppDelegate.isLogin == 1) {
//        BmobUser *user = [BmobUser getCurrentUser];
//        if (user != nil) {
//            [self.loginBtn setTitle:user.username forState:UIControlStateNormal];
//            self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        }else{
//            [self.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
//        }
//    }

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
            if (myAppDelegate.isLogin) {
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
            TimeView *timeView = [[TimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            [window addSubview:timeView];
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

            BmobUser *currntUser = [BmobUser getCurrentUser];
            if (currntUser != nil) {
                [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                    if (!error) {
                        [BmobUser logout];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前用户已退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                        
                        myAppDelegate.isLogin = 0;
                        [self confineHeadView];
                        [alert show];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                        [alert show];
                    }
                } onQueue:nil];
            }
            [self confineHeadView];

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
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 100, 250, 30)];
    welcomeLabel.textColor = [UIColor whiteColor];

    
    BmobUser *User = [[BmobUser alloc] init];
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        //已登录
        self.loginBtn.hidden = YES;
        self.userImageView.hidden = NO;
        User.username = myAppDelegate.dic[@"screen_name"];
        welcomeLabel.text = User.username;
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:myAppDelegate.dic[@"avatar_hd"]] placeholderImage:nil];
        NSLog(@"%@", bUser);
        NSLog(@"%@", myAppDelegate.dic[@"avatar_hd"]);
        NSLog(@"1");
        
    }else{
        //未登录
        self.loginBtn.hidden = NO;
        self.userImageView.hidden = YES;

        [self.loginBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];
        welcomeLabel.text = @"欢迎来到马里亚纳听书";
        NSLog(@"2");
    }
//    self.loginBtn.backgroundColor = [UIColor redColor];
//    self.userImageView.backgroundColor = [UIColor whiteColor];
//    welcomeLabel.backgroundColor = [UIColor blackColor];
    
    [self.headView addSubview:self.loginBtn];
    [self.headView addSubview:welcomeLabel];
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
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
