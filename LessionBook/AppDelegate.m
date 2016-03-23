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


#import <BmobSDK/Bmob.h>





//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //设置应用的BmobKey
    [Bmob registerWithAppKey:@"209affb0270dad4053ab8b1ded9b56fa"];
    
    //注册环信
    //registerSDKWithAppKey
    [[EaseMob sharedInstance] registerSDKWithAppKey:kHuanxinAppKey apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    [[EaseSDKHelper shareHelper] easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:kHuanxinAppKey
                                       apnsCertName:nil
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];


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

//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}




@end
