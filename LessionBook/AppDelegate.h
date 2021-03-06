//
//  AppDelegate.h
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeiboSDK.h>
#import "detailModel.h"
#import "PlayViewController.h"
#import "detailModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *wbtoken;
@property (nonatomic, strong) NSString *wbRefreshToken;
@property (nonatomic, strong) NSString *wbCurrentUserId;
@property (nonatomic, retain) NSDictionary *dic;
@property(nonatomic,assign) BOOL isCollection;
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) detailModel *detailModel;
@property(nonatomic,strong) NSArray *arrayAll;
@property(nonatomic,assign) NSInteger num;
@property (nonatomic, strong) detailModel *currentplayingMusic;

@end

