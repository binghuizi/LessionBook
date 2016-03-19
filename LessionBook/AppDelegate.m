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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    
    //注册环信
    //registerSDKWithAppKey
    [[EaseMob sharedInstance] registerSDKWithAppKey:kHuanxinAppKey apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    

    // Override point for customization after application launch.
    //下载
    DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
    UINavigationController *downloadNav = [[UINavigationController alloc] initWithRootViewController:downloadVC];
    downloadNav.tabBarItem.title = @"下载";
    downloadNav.tabBarItem.image = [UIImage imageNamed:@"tab_download"];
    //搜索
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    searchNav.tabBarItem.title = @"搜索";
    searchNav.tabBarItem.image = [UIImage imageNamed:@"tab_search"];
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
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
