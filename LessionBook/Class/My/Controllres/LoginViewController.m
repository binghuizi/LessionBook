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
@interface LoginViewController ()
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
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self showBackButton:@"ic_arrow_general2"];
    [self showRightBarButton:@"注册"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    [self.accountLoginBtn addTarget:self action:@selector(accountLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.mcroblogLoginBtn addTarget:self action:@selector(mcroblogLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.QQLoginBtn addTarget:self action:@selector(QQLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)leftTitleAction:(UIBarButtonItem *)btn{
    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    RegisterViewController *registerVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
- (void)accountLogin:(UIButton *)btn{
    //BmobUser *buser = [[BmobUser alloc] init];
    [BmobUser loginInbackgroundWithAccount:self.accountNumber.text
                                andPassword:self.passWard.text block:^(BmobUser *user, NSError *error) {
                                    if (user) {
                                        [ProgressHUD showSuccess:@"登陆成功"];
                                    } else {
                                        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error] Interaction:YES];
                                    }
                                }];
}

//新浪微博登录
- (void)mcroblogLoginBtn:(UIButton *)btn{
    
}
- (void)QQLoginBtn:(UIButton *)btn{
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //这个是逐个的textFiled回收键盘，比较麻烦
    //  [self.ZhangHao resignFirstResponder];
    //  [self.MiMa resignFirstResponder];
    //view结束编辑，回收键盘
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
