//
//  RegisterViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"
#import <EaseMob.h>
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *indentifyCoreBtn;

@property (weak, nonatomic) IBOutlet UITextField *indentifyCore;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.title = @"注册";
    [self.registerBtn addTarget:self action:@selector(backLogin:) forControlEvents:UIControlEventTouchUpInside];
//    [self.indentifyCoreBtn addTarget:self action:@selector(getIndentifyCore:) forControlEvents:UIControlEventTouchUpInside];
}
//- (void)getIndentifyCore:(UIButton *)btn{
//    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.mobilePhoneNumber.text andTemplate:@"您好，您此次验证码为XXXXXX，请尽快注册。【马里亚纳听书】" resultBlock:^(int number, NSError *error) {
//        
//    }];
//}


- (void)backLogin:(UIButton *)btn{
    BmobUser *buser = [[BmobUser alloc] init];
    buser.username = self.mobilePhoneNumber.text;
    buser.password = self.passWord.text;
//    buser.mobilePhoneNumber = self.mobilePhoneNumber.text;
    //这个只能验证验证码是否正确，不能注册
//    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.mobilePhoneNumber.text andSMSCode:self.indentifyCore.text resultBlock:^(BOOL isSuccessful, NSError *error) {
//        if (!isSuccessful) {
//            NSLog(@"%@", error);
//            [ProgressHUD showError:[NSString stringWithFormat:@"验证码%@错误", self.indentifyCore.text] Interaction:YES];
//           
//        }else{
    //手机号码，验证码注册
    [buser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (!isSuccessful) {
            NSLog(@"%@", error);
            [ProgressHUD showError:[NSString stringWithFormat:@"验证%@错误", self.indentifyCore.text] Interaction:YES];
            
        } else {
            [ProgressHUD showSuccess:@"注册成功" Interaction:YES];
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EaseMob sharedInstance].chatManager registerNewAccount:weakself.mobilePhoneNumber.text password:weakself.passWord.text error:&error];
                if (!error) {
                    [ProgressHUD showSuccess:@"注册成功, 请登录"];
                    BmobObject *userInfo = [BmobObject objectWithClassName:@"UserInformation"];
                    [userInfo setObject:weakself.mobilePhoneNumber.text forKey:@"username"];
                    [userInfo saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        //进行操作
                        NSLog(@"-------%d", isSuccessful);
                    }];
                    
                }else{
                    [ProgressHUD showError:@"注册失败啦"];
                }
            });
            [self.navigationController popViewControllerAnimated:YES];
        }

    }];
//        [buser signUpOrLoginInbackgroundWithSMSCode:self.indentifyCore.text block:^(BOOL isSuccessful, NSError *error) {
//                if (!isSuccessful) {
//                    NSLog(@"%@", error);
//                    [ProgressHUD showError:[NSString stringWithFormat:@"验证%@错误", self.indentifyCore.text] Interaction:YES];
//                    
//                } else {
//                   [ProgressHUD showSuccess:@"注册成功" Interaction:YES];
//                    __weak typeof(self) weakself = self;
//                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                   EMError *error = nil;
//                   [[EaseMob sharedInstance].chatManager registerNewAccount:weakself.mobilePhoneNumber.text password:weakself.passWord.text error:&error];
//                    if (!error) {
//                    [ProgressHUD showSuccess:@"注册成功, 请登录"];
//                    BmobObject *userInfo = [BmobObject objectWithClassName:@"UserInformation"];
//                    [userInfo setObject:weakself.mobilePhoneNumber.text forKey:@"username"];
//                    [userInfo saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                                    //进行操作
//                        NSLog(@"-------%d", isSuccessful);
//                                        }];
//                                        
//                                    }else{
//                      [ProgressHUD showError:@"注册失败啦"];
//                                    }
//                                });
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }];
//        }}];
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
