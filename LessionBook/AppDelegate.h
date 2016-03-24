//
//  AppDelegate.h
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeiboSDK.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign) BOOL isCollection;
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic,strong) NSString *userId;
@end

