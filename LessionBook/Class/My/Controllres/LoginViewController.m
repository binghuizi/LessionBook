//
//  LoginViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"
#import <WeiboSDK.h>
#import <EaseMob.h>
#import "AppDelegate.h"




@interface LoginViewController ()<EMChatManagerDelegate>
{
    AppDelegate *myAppDelagate;

}
@property (weak, nonatomic) IBOutlet UITextField *accountNumber;
@property (weak, nonatomic) IBOutlet UITextField *passWard;

@property (weak, nonatomic) IBOutlet UIButton *accountLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassWordBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *mcroblogLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQLoginBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    [self showBackButton:@"ic_arrow_general2"];
    [self showRightBarButton:@"注册"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    
    [self.accountLoginBtn addTarget:self action:@selector(accountLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.mcroblogLoginBtn addTarget:self action:@selector(mcroblogLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.QQLoginBtn addTarget:self action:@selector(QQLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    myAppDelagate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
- (void)leftTitleAction:(UIBarButtonItem *)btn{
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    RegisterViewController *registerVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
- (void)accountLogin:(UIButton *)btn{

    [BmobUser loginInbackgroundWithAccount:self.accountNumber.text andPassword:self.passWard.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            //异步登陆账号
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.accountNumber.text password:self.passWard.text completion:^(NSDictionary *loginInfo, EMError *error) {
                if (!error) {
                    [ProgressHUD showSuccess:@"登陆成功"];
                    //获取数据库中数据
                    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                    //获取群组列表
                    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];

                }else{
                    [ProgressHUD showError:@"登录失败"];
                }
                
                myAppDelagate.isLogin = 1;
                myAppDelagate.userId = self.accountNumber.text;
                [self.navigationController popViewControllerAnimated:YES];

                } onQueue:nil];
            

        } else {
            [ProgressHUD showError:[NSString stringWithFormat:@"%@", error] Interaction:YES];
        }
    }];
}

//新浪微博登录
- (void)mcroblogLoginBtn:(UIButton *)btn{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}
- (void)QQLoginBtn:(UIButton *)btn{
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //view结束编辑，回收键盘
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

//环信代理
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    NSString *str = [NSString stringWithFormat:@"--------------%@请求加你为好友", username];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友邀请" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
    if (error == nil) {
        NSLog(@"----------同意加好友");
    }
}

- (void)didAcceptedByBuddy:(NSString *)username{
    NSString *str = [NSString stringWithFormat:@"%@同意加你为好友", username];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友邀请" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


@end
