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
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "WeiboSDK.h"
#import <WXApi.h>

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
//调用registerApp方法来初始化SDK并且初始化第三方平台
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerApp:kShareAppKey activePlatforms:@[
          @(SSDKPlatformTypeSinaWeibo),
          @(SSDKPlatformTypeQQ),
          @(SSDKPlatformTypeSMS),
          @(SSDKPlatformTypeCopy),
          @(SSDKPlatformTypeWechat),] onImport:^(SSDKPlatformType platformType) {
              switch (platformType) {
                  case SSDKPlatformTypeWechat:
                      [ShareSDKConnector connectWeChat:[WXApi class]];
                      break;
                  case SSDKPlatformTypeSinaWeibo:
                      [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                      break;
                  case SSDKPlatformTypeQQ:
                      [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                      break;
                  default:
                      break;
              }
          } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType) {
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey:kWeiboAppKey appSecret:kWeiboAppSecret redirectUri:@"https://api.weibo.com/oauth2/default.html" authType:SSDKAuthTypeBoth];
                      break;
//                      case SSDKPlatformTypeWechat:
//                      [appInfo SSDKSetupWeChatByAppId:<#(NSString *)#> appSecret:<#(NSString *)#>]
//                      break;
                      case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:kQQAppId appKey:kQQAppKey authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
    
    
    
    
    
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//    
//   }

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}


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
