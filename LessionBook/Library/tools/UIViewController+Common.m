//
//  UIViewController+Common.m
//  WaitingWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)
//导航栏左按钮
- (void)showBackButton:(NSString *)imageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBar;
}
- (void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
//导航栏右按钮
-(void)showRightBarButton:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(leftTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBar;
}
-(void)leftTitleAction:(UIButton *)btn{
    
}



@end
