//
//  AppDelegate.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/3.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import <objc/message.h>
#import <AVFoundation/AVFoundation.h>
#import "VCHomeViewController.h"


///友盟统计AppKey
#define UMengAnalyticsAppKey @"5bbc6184b465f5297f0000ab"

#define VHClass_AppKey                  @"您的AppKey"
#define VHClass_SecretKey               @"您的SecretKey"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    self.window = [[UIWindow alloc]initWithFrame:bounds];
    self.window.rootViewController = [[VCHomeViewController alloc]initWithAppKey:VHClass_AppKey appSecretKey:VHClass_SecretKey];
    [self.window makeKeyAndVisible];
    
    //权限验证弹窗
    [self audioAndCamera];

    //友盟统计
    [self registerUMengAnalytics];
    
    return YES;
}

- (void)registerUMengAnalytics {
    //注册
    UMConfigInstance.appKey = UMengAnalyticsAppKey;
    [MobClick startWithConfigure:UMConfigInstance];
    //设置App版本号
    [MobClick setAppVersion:XcodeAppVersion];
    
#ifdef DEBUG
    
    [MobClick setLogEnabled:YES];
#else
    
    [MobClick setLogEnabled:NO];
#endif
    
}

- (void)audioAndCamera {
    //相机使用授权
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
     {
         if (granted){   // 用户同意授权
             
         } else {    // 用户拒绝授权
             
         }
     }];
    //麦克风使用授权
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted)
     {
         if (granted){   // 用户同意授权
             
         } else {    // 用户拒绝授权
             
         }
     }];
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

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
