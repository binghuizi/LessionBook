//
//  ChatRoomViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "MessageViewController.h"
#import "LinkManViewController.h"
#import <EaseMob.h>
#import "ProgressHUD.h"
#import <BmobSDK/Bmob.h>

@interface ChatRoomViewController ()<UITextFieldDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) UITextField *username;
@property (nonatomic, strong) UITextField *userPassword;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registBtn;
//退出登录
@property (nonatomic, strong) UIButton *loginOutBtn;


@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"聊天登录";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    [self showBackButton:@"ic_arrow_general2"];
    [self.view addSubview:self.username];
    [self.view addSubview:self.userPassword];
    [self.view addSubview:self.registBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.loginOutBtn];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)backAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -----LazyLoading

- (UITextField *)username{
    if (_username == nil) {
        self.username = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 44)];
        self.username.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _username;
}

- (UITextField *)userPassword{
    if (_userPassword == nil) {
        self.userPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, 44)];
        self.userPassword.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _userPassword;
}

- (UIButton *)registBtn{
    if (_registBtn == nil) {
        self.registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.registBtn.frame = CGRectMake(40, 200, kScreenWidth - 80, 44);
        self.registBtn.backgroundColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:255 / 255.0 alpha:1.0];
        [self.registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}

- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginBtn.frame = CGRectMake(40, 250, kScreenWidth - 80, 44);
        self.loginBtn.backgroundColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:255 / 255.0 alpha:1.0];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)loginOutBtn{
    if (_loginOutBtn == nil) {
        self.loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginOutBtn.frame = CGRectMake(40, kScreenHeight - 44, kScreenWidth - 80, 44);
        self.loginOutBtn.backgroundColor = [UIColor redColor];
        [self.loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.loginOutBtn addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;
}

#pragma mark -------自定义方法

//注册
- (void)registAction{
    if (![self isEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        //判断是否是中文，但不支持中英文混编
        if ([self.username.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login", @"用户名不支持中文") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")otherButtonTitles:nil];
            [alert show];
            return;
        }
        [ProgressHUD show:@"正在注册"];
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [[EaseMob sharedInstance].chatManager registerNewAccount:weakself.username.text password:weakself.userPassword.text error:nil];
        [ProgressHUD showSuccess:@"注册成功, 请登录"];
        });
    }
}

//登录
- (void)loginAction{
    UITabBarController *chatTabBarC = [[UITabBarController alloc] init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    messageNav.tabBarItem.title = @"消息";
    LinkManViewController *linkVC = [[LinkManViewController alloc] init];
    UINavigationController *linkNav = [[UINavigationController alloc] initWithRootViewController:linkVC];
    linkNav.tabBarItem.title = @"好友";
    chatTabBarC.viewControllers = @[messageNav, linkNav];
    [ProgressHUD show:@"正在抢滩登陆"];
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.username.text password:self.userPassword.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            [ProgressHUD showSuccess:@"登陆成功"];
            //获取数据库中数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            //获取群组列表
            [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
            [self.navigationController presentViewController:chatTabBarC animated:YES completion:nil];
        }else{
            [ProgressHUD showError:@"登录失败"];
        }
    } onQueue:nil];
}

//判断输入的内容是否为空
- (BOOL)isEmpty{
    NSString *userName = self.username.text;
    NSString *password = self.userPassword.text;
    if (userName.length == 0 || password.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return YES;
    }
    return NO;
}

//退出登录
- (void)loginOutAction{

    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前用户已退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
            self.username.text = @"";
            self.userPassword.text = @"";
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
    } onQueue:nil];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    NSString *str = [NSString stringWithFormat:@"%@请求加你为好友", username];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:str message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
       [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
        if (error == nil) {
            NSLog(@"发送同意成功");
        }
    }];
    //拒绝加好友
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"未知人士" error:&error];
        if (error == nil) {
            NSLog(@"发送同意成功");
        }
    }];

    [alertC addAction:action];
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)didAcceptedByBuddy:(NSString *)username{
    NSString *str = [NSString stringWithFormat:@"%@同意加你为好友", username];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友邀请" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
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
