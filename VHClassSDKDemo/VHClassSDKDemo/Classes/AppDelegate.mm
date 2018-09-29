//
//  AppDelegate.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/3.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "AppDelegate.h"
#import "VHClassSDK.h"
#import "VHClassViewController.h"

//集成和使用文档见(http://doc.vhall.com/docs/edit/53)

#define kVHCAppKey_test @""
#define kVHCAppSecretKey_test @""

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    VHClassViewController *rootController = [[VHClassViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rootController];
    _window.rootViewController = navi;
    [_window makeKeyAndVisible];
    
    //注册SDK
    [[VHClassSDK sharedSDK] initWithAppKey:kVHCAppKey_test appSecretKey:kVHCAppSecretKey_test apsForProduction:YES];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
