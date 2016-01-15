//
//  AppDelegate.m
//  Shopping
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /** 启动图停留时间设置 */
    [NSThread sleepForTimeInterval:0.1];
    /** 版本号key */
    NSString * versionKey = @"CFBundleVersion";
    /** 从沙河路径中获取上一次的版本号 */
    NSUserDefaults * version = [NSUserDefaults standardUserDefaults];
    NSString * lastVersion = [version stringForKey:versionKey];
    /** 得到最新的版本号 */
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    /** 比较版本号是否相同 */
    if(![lastVersion isEqualToString:currentVersion])
    {
        self.window.rootViewController=[[GuideViewController alloc]init];
        /** 储存新版本 */
        [version setObject:currentVersion forKey:versionKey];
        /** 刷新plist */
        [version synchronize];
    }
    else
    {
        self.tabBar = [[ViewController alloc] init];
        self.window.rootViewController = self.tabBar;
    }
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
