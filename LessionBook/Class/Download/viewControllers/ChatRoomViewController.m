//
//  ChatRoomViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "MessageViewController.h"
#import <EaseMob.h>

@interface ChatRoomViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *username;
@property (nonatomic, strong) UITextField *userPassword;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registBtn;


@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"聊天登录";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    [self.view addSubview:self.username];
    [self.view addSubview:self.userPassword];
    [self.view addSubview:self.registBtn];
    [self.view addSubview:self.loginBtn];
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
        self.registBtn.frame = CGRectMake(40, 200, 80, 44);
        self.registBtn.backgroundColor = [UIColor brownColor];
        [self.registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}

- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginBtn.frame = CGRectMake(200, 200, 80, 44);
        self.loginBtn.backgroundColor = [UIColor brownColor];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

#pragma mark -------自定义方法

//注册
- (void)registAction{
    if (![self isEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        //判断是否是中文，但不支持中英文混编
//        if ([self.username.text is]) {
//            <#statements#>
//        }
    }
}

//登录
- (void)loginAction{
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
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

//判断字符串是否是中文

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
