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
#import <EaseMob.h>
#import <BmobSDK/Bmob.h>

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *myArray;
@property (nonatomic, retain) NSArray *detailArray;
@property (nonatomic, retain) UIView *headView;
@property (nonatomic, retain) UIView *timeUpView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.myArray = [NSArray arrayWithObjects:@"我的收藏", @"最近收听", @"定时关闭", @"更多设置", @"书友畅聊", @"账号设置", nil];
    self.detailArray = [NSArray arrayWithObjects:@"暂无收藏", @"暂无收听记录", @"", @"", @"", @"",nil];
    [self confineHeadView];
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.myArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = self.detailArray[indexPath.row];
     cell.textLabel.text = self.myArray[indexPath.row];
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
        cell.imageView.image = [UIImage imageNamed:@"icon_user"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            FavoriteViewController *favoriteVC = [[FavoriteViewController alloc] init];
            [self.navigationController pushViewController:favoriteVC animated:YES];
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
                LinkManViewController *linkVC = [[LinkManViewController alloc] init];
                UINavigationController *linkNav = [[UINavigationController alloc] initWithRootViewController:linkVC];
                linkNav.tabBarItem.title = @"好友";
                chatTabBarC.viewControllers = @[messageNav, linkNav];
                [self.navigationController presentViewController:chatTabBarC animated:YES completion:nil];
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
                        [alert show];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                        [alert show];
                    }
                } onQueue:nil];
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
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 70, 100, 100);
    [loginBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 50;
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 100, 250, 30)];
    welcomeLabel.text = @"欢迎来到马里亚纳听书";
    welcomeLabel.textColor = [UIColor whiteColor];
    
    [self.headView addSubview:loginBtn];
    [self.headView addSubview:welcomeLabel];
}
//登录注册按钮
- (void)loginAction{
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    
    LoginViewController *loginVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
    [self.navigationController pushViewController:loginVC animated:YES];
    
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
