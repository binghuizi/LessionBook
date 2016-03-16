//
//  UIViewController+Commen.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "UIViewController+Commen.h"

@implementation UIViewController (Commen)

- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    [backBtn setImage:[UIImage imageNamed:@"search_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backbtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

- (void)backbtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
