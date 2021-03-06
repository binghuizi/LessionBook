//
//  AppDelegate.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "AppDelegate.h"

#import "DownloadViewController.h"
#import "SearchViewController.h"
#import "MyViewController.h"
#import "DiscoverViewController.h"
#import <EaseMobSDKFull/EaseMob.h>
#import <EaseUI.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
//推送
#import "JPUSHService.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
//支付设置
#import <AlipaySDK/AlipaySDK.h>
#import <BmobPay/BmobPay.h>
#import <BmobSDK/Bmob.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()<EMChatManagerDelegate, UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //设置应用的BmobKey
    [Bmob registerWithAppKey:kBmobPayKey];
    //bmob支付
    [BmobPaySDK registerWithAppKey:kBmobPayKey];
    //微博分享
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWeiboAppKey];
    //注册环信
    //registerSDKWithAppKey
    [[EaseMob sharedInstance] registerSDKWithAppKey:kHuanxinAppKey apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseSDKHelper shareHelper] easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:kHuanxinAppKey
                                       apnsCertName:nil
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    //推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    //推送
    [JPUSHService setupWithOption:launchOptions appKey:@"0497c4b90c2f04c9418cbc1e" channel:@"https://itunes.apple.com/cn/genre/yin-le/id34" apsForProduction:YES];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    // 本地通知内容获取：NSDictionary *localNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey]
    // Override point for customization after application launch.
    //下载
    [[UITabBar appearance] setTintColor:[UIColor orangeColor]];
    DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
    UINavigationController *downloadNav = [[UINavigationController alloc] initWithRootViewController:downloadVC];
    downloadNav.tabBarItem.title = @"下载";
    downloadNav.tabBarController.tabBar.tintColor = [UIColor orangeColor];
    downloadNav.tabBarItem.image = [UIImage imageNamed:@"tab_download"];
    UIImage *downloadSelectImage = [UIImage imageNamed:@"tab_download_s"];
    downloadNav.tabBarItem.selectedImage = [downloadSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //搜索
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    searchNav.tabBarItem.title = @"搜索";
    searchNav.tabBarController.tabBar.tintColor = [UIColor orangeColor];
    searchNav.tabBarItem.image = [UIImage imageNamed:@"tab_search"];
    UIImage *searchImage = [UIImage imageNamed:@"tab_search_s"];
    searchNav.tabBarItem.selectedImage = [searchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //我的
    UIStoryboard *myStoryBoary = [UIStoryboard storyboardWithName:@"My" bundle:nil];
   UINavigationController *myNav = [myStoryBoary instantiateInitialViewController];
    myNav.tabBarItem.title = @"我的";
    myNav.tabBarItem.image = [UIImage imageNamed:@"tab_personal"];
    myNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_personal_s"];
    
    
    /**
     *  创建UITabBarController
     */
    
    UITabBarController *tabarVc = [UITabBarController new];
   //发现
    DiscoverViewController *discoVc = [DiscoverViewController new];
    UINavigationController *disNav = [[UINavigationController alloc]initWithRootViewController:discoVc];
    discoVc.tabBarItem.title = @"发现";
    discoVc.tabBarItem.image = [UIImage imageNamed:@"tab_discovery"];
    
    tabarVc.viewControllers = @[disNav,searchNav, downloadNav, myNav];
    
    self.window.rootViewController = tabarVc;
    

#pragma mark ---分享事件
    [ShareSDK registerApp:kShareAppKey];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:kWeiboAppKey
                               appSecret:kWeiboAppSecret
                             redirectUri:kHuiDiao];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:kWeiboAppKey
                                appSecret:kWeiboAppSecret
                              redirectUri:kHuiDiao
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:kQQAppId
                           appSecret:kQQAppKey
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:kQQAppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:kWeiXinAppID
                           appSecret:kWeiXinAppKey
                           wechatCls:[WXApi class]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
        NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString *uid = [(WBAuthorizeResponse *)response userID];
        NSDate *expriated = [(WBAuthorizeResponse *)response expirationDate];
    NSLog(@"acessToken:%@",accessToken);
    NSLog(@"UserId:%@",uid);
    NSLog(@"expiresDate:%@",expriated);
        //得到的新浪微博授权信息，请按照例子来生成NSDictionary
    DSNLog(@"accessToken = %@",accessToken);
    DSNLog(@"----------------");
       AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [sessionManager GET:@"https://api.weibo.com/2/users/show.json" parameters:@{@"access_token":accessToken, @"uid":uid} progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DSNLog(@"%@", responseObject);
            self.dic = responseObject;
            BmobQuery *bquery = [BmobUser query];
            NSArray *array = @[@{@"username" : self.dic[@"screen_name"]}];
            [bquery addTheConstraintByOrOperationWithArray:array];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                NSLog(@"%@", array);
            }];
            
            BmobUser *bUser = [[BmobUser alloc] init];
            [bUser setUsername:self.dic[@"screen_name"]];
            [bUser setPassword:@"000000"];
            [bUser setObject:self.dic[@"avatar_hd"] forKey:@"headImage"];
           
            [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful){
                    NSLog(@"Sign up successfully");
            [BmobUser loginWithUsernameInBackground:self.dic[@"screen_name"] password:@"000000" block:^(BmobUser *user, NSError *error) {
                        if (user) {
                            //          NSLog(@"user objectid is :%@",user.objectId);
                            [ProgressHUD showSuccess:@"新浪微博登陆成功" Interaction:YES];
                            self.isLogin = YES;
                        } else {
                            NSLog(@"weibo login error:%@",error);
                            self.isLogin = NO;
                        }
                    }];

                } else {
                    NSLog(@"%@",error);
                }
            }];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DSNLog(@"responseObject = -----56%@", error);
        }];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WeiboSDK handleOpenURL:url delegate:self] |[ShareSDK handleOpenURL:url wxDelegate:self];
}
//支付代理
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@", resultDic);
        }];
    }
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self]|[WeiboSDK handleOpenURL:url delegate:self];

}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    
}
//推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
/**
 *  程序进入后台，应该是要继续播放
 *
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
    
    UIBackgroundTaskIdentifier taskID = [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    
    if (taskID != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:taskID];
    }
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

//环信代理

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    NSLog(@"217 appdelegate--------%@", loginInfo);
    
}



- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    NSString *str = [NSString stringWithFormat:@"%@请求加你为好友", username];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友邀请" message:str delegate:self cancelButtonTitle:@"同意" otherButtonTitles:@"拒绝",nil];
    [alert show];
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
    if (error == nil) {
        NSLog(@"----------同意加好友");
    }else{
        NSLog(@"----------失败");
    }
}
- (void)didAcceptedByBuddy:(NSString *)username{
    NSString *str = [NSString stringWithFormat:@"%@同意加你为好友", username];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友邀请" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

//接受群组邀请代理
- (void)didAcceptInvitationFromGroup:(EMGroup *)group error:(EMError *)error{
    
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
    EMMessage *message = [offlineMessages lastObject];
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:100]
                                     alertBody:txt
                                         badge:1
                                   alertAction:@"确定"
                                 identifierKey:@"identifierKey"
                                      userInfo:nil
                                     soundName:nil];
        }
            break;
        case eMessageBodyType_Command:
            break;
        case eMessageBodyType_File:
            break;
        case eMessageBodyType_Image:
            break;
        case eMessageBodyType_Location:
            break;
        case eMessageBodyType_Video:
            break;
        case eMessageBodyType_Voice:
            break;
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:@"identifierKey"];

}

@end
