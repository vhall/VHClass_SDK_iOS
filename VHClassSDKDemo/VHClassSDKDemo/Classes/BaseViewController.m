//
//  BaseViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/4.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interfaceOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _interfaceOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)showTextView:(UIView *)view message:(NSString *)message{
    MBProgressHUD  *hub=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hub.mode=MBProgressHUDModeText;
    hub.label.text=message;
    hub.margin=10.0f;
    hub.removeFromSuperViewOnHide=YES;
    [hub hideAnimated:YES afterDelay:1.5];
}

-(void)showTextView:(UIView *)view message:(NSString *)message Delay:(int)delay{
    MBProgressHUD  *hub=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hub.mode=MBProgressHUDModeText;
    hub.label.text=message;
    hub.margin=10.0f;
    hub.removeFromSuperViewOnHide=YES;
    [hub hideAnimated:YES afterDelay:delay];
}

-(void)showProgressDialog:(UIView*)view{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

-(void)hideProgressDialog:(UIView*)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (_interfaceOrientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return _interfaceOrientation;
}

@end
