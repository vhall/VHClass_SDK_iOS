//
//  BaseViewController.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/4.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,assign)UIInterfaceOrientation interfaceOrientation;

//显示提示语
-(void)showTextView:(UIView*)view message:(NSString*)message;//1.5s
-(void)showTextView:(UIView*)view message:(NSString*)message Delay:(int)delay;

-(void)showProgressDialog:(UIView*)view;
-(void)hideProgressDialog:(UIView*)view;

@end
