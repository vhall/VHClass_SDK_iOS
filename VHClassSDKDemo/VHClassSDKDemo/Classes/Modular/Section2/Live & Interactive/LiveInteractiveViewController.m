//
//  LiveInteractiveViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/3/14.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "LiveInteractiveViewController.h"
#import "LiveViewController.h"
#import "VCInteractiveController.h"
#import <VHClassSDK/VHCIMClient.h>
#import <AVFoundation/AVFoundation.h>
#import "VCPlaceHolderView.h"

@interface LiveInteractiveViewController ()<VHCIMClientDelegate,LiveViewControllerDelegate,VCInteractiveControllerDelegate,VHAlertViewDelegate>

@property (nonatomic, strong) LiveViewController *liveVC;
@property (nonatomic, strong) VCInteractiveController *interactiveVC;
@property (nonatomic, strong) UIButton *handButton;

@property (nonatomic, strong) VCPlaceHolderView *placeHolderView;

@end

@implementation LiveInteractiveViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self backClick];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //恢复重力感应
    self.navigationController.autoRotate = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //设置页面不支持重力感应
    self.navigationController.autoRotate = NO;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [[VHCIMClient sharedIMClient] addDelegate:self];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [[VHCIMClient sharedIMClient] removeDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_liveVC) {
        self.liveVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4);
    }
    if (_interactiveVC) {
        if ([VCCourseData shareInstance].courseInfo.type == VHClassTypeSmallRoom) {
            self.interactiveVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4+70);
        }
        else
        {
            self.interactiveVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     直播 暂停、继续、切换分辨率
     
     举手 上下麦
     
     互动
     */
    
    self.handButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.handButton.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) - 10 - 44 - 64-24 - kIPhoneXBottomHeight, 44, 44);
    [self.handButton setImage:[UIImage imageNamed:@"上麦"] forState:UIControlStateNormal];
    [self.handButton setImage:[UIImage imageNamed:@"下麦"] forState:UIControlStateSelected];
    [self.handButton setImage:[UIImage imageNamed:@"上麦未开起"] forState:UIControlStateDisabled];
    [self.handButton addTarget:self action:@selector(handButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.handButton];
    
    
    [self layoutWithClassState:[VCCourseData shareInstance].courseInfo.state];
}

- (void)layoutLive {
    self.liveVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4);
    [self.view addSubview:self.liveVC.view];
    
    self.handButton.selected = NO;
}
- (void)destoryLive {
    if (_liveVC) {
        [_liveVC destoryPlayer];
        [self.liveVC.view removeFromSuperview];
        self.liveVC = nil;
    }
}
- (void)layoutInteractive {
    self.interactiveVC.view.height = self.view.width*3/4;
    if ([VCCourseData shareInstance].courseInfo.type == VHClassTypeSmallRoom) {
        self.interactiveVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4+70);
    }
    [self.view addSubview:self.interactiveVC.view];
    
    self.handButton.selected = YES;
}
- (void)destoryIteractive {
    if (_interactiveVC) {
        [_interactiveVC leave];
        [self.interactiveVC.view removeFromSuperview];
        self.interactiveVC = nil;
    }
}
- (void)layoutPlaceHolder {
    self.placeHolderView.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4);

    UIImage *image = [UIImage imageNamed:@"下课占位"];
    NSString *text = @"下课了，休息一下吧～";
    //预告
    if ([VCCourseData shareInstance].courseInfo.state == VHClassStatusTrailer) {
        text = @"还没开始上课，休息一下吧～";
        image = [UIImage imageNamed:@"预告占位"];
    }
    self.placeHolderView.label.text = text;
    self.placeHolderView.imageView.image = image;
    [self.view insertSubview:self.placeHolderView atIndex:0];
}
- (void)removePlaceHolder {
    [self.placeHolderView removeFromSuperview];
}

- (void)layoutWithClassState:(VHClassState)state
{
    switch (state) {
        case VHClassStateClassOn: //上课中
        {
            [self removePlaceHolder];
            
            [self destoryIteractive];
            [self layoutLive];
            
            self.handButton.enabled = YES;
        }
            break;
        case VHClassStatusTrailer: //预告
        {
            self.handButton.enabled = NO;

            [self layoutPlaceHolder];
        }
            break;
        case VHClassStatusVod: //回放
        {
            [self removePlaceHolder];

            self.handButton.enabled = NO;
        }
            break;
        case VHClassStatusClassOver: //已下课
        {
            self.handButton.enabled = NO;

            [self destoryIteractive];
            [self destoryLive];
            
            [self layoutPlaceHolder];
        }
            break;
        default:
            break;
    }
}

- (void)backClick {
    [self destoryIteractive];
    [self destoryLive];
}

#pragma mark - LiveViewControllerDelegate
//上麦回调
- (void)liveViewController:(LiveViewController *)vc willEnterInteractive:(BOOL)isVoiceOnly
{
    if ([self isAllowInteractive])
    {
        [self destoryLive];

        self.interactiveVC.type = isVoiceOnly ? MicroTypeOnlyVoice : MicroTypeDefault;
        [self layoutInteractive];
    }

}



#pragma mark - VCInteractiveControllerDelegate
- (void)interactiveViewController:(VCInteractiveController *)vc didError:(VHCError *)error
{
    [self layoutWithClassState:VHClassStateClassOn];
}

#pragma mark - VHCIMClientDelegate
- (void)imClient:(VHCIMClient *)client allSocketIOMsg:(NSDictionary*)msgData
{
    NSDictionary *msg    = msgData[@"msg"];
    NSString *msgType = msg[@"type"];
    NSString *targetId = msg[@"target_id"];
    
    //开始上课
    if ([msgType isEqualToString:@"*publishStart"])
    {
        [VCCourseData shareInstance].courseInfo.state = VHClassStateClassOn;
        [self layoutWithClassState:VHClassStateClassOn];
        
        [self showTextView:VHKWindow message:@"上课了"];
    }
    //下课了
    else if ([msgType isEqualToString:@"*over"])
    {
        [VCCourseData shareInstance].courseInfo.state = VHClassStatusClassOver;
        [self layoutWithClassState:VHClassStatusClassOver];
        
        [self showTextView:VHKWindow message:@"下课了"];
    }
    
    //自己被踢出课堂
    else if ([msgType isEqualToString:@"*kickout"] && [targetId isEqualToString:[VCCourseData shareInstance].joinId])
    {
        [self showTextView:VHKWindow message:@"您已被踢出课堂"];
        
        [self backClick];
    }
}

#pragma mark - VHAlertViewDelegate
- (void)alertView:(VHAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
    switch (alertView.tag) {
        case 10020:
        {
            if (index == 1) {
                [self backClick];
            }
        }
            break;
        case 324:
        case 325:
        {
            if (index == 1) {
                [self switchToAppSet];
            }
        }
            break;
    }
    
}


#pragma mark - buttonClick
- (void)handButtonAction:(UIButton *)btn
{
    if (_liveVC) {
        [_liveVC appplyHand];
    }
    if (_interactiveVC) {
        [_interactiveVC leave];
        [self layoutWithClassState:[VCCourseData shareInstance].courseInfo.state];
    }
}


#pragma mark 权限
- (BOOL)isAllowInteractive {
    //互动权限判断
    if (![self cameraAuthorization])
    {
        [self cameraSetAlert];
        return NO;
    }
    if (![self audioAuthorization])
    {
        [self audioSetAlert];
        return NO;
    }
    return YES;
}

- (void)cameraSetAlert {
    VHAlertView *alert = [[VHAlertView alloc] initWithTitle:@"温馨提示" message:@"请您在应用设置中打开摄像机权限" delegate:self tag:324 cancelButtonTitle:@"取消" otherButtonTitle:@"去设置"];
    [alert.rightBtn setTitleColor:UIColor(82, 204, 144, 1) forState:UIControlStateNormal];
    [alert show];
}
- (void)audioSetAlert {
    VHAlertView *alert = [[VHAlertView alloc] initWithTitle:@"温馨提示" message:@"请您在应用设置中打开麦克风权限" delegate:self tag:325 cancelButtonTitle:@"取消" otherButtonTitle:@"去设置"];
    [alert.rightBtn setTitleColor:UIColor(82, 204, 144, 1) forState:UIControlStateNormal];
    [alert show];
}

- (BOOL)audioAuthorization
{
    BOOL authorization = NO;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            authorization = YES;
            break;
        default:
            break;
    }
    return authorization;
}

- (BOOL)cameraAuthorization
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}
- (void)switchToAppSet
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - get

- (LiveViewController *)liveVC {
    if (!_liveVC) {
        _liveVC = [[LiveViewController alloc] init];
        _liveVC.delegate = self;
    }
    return _liveVC;
}
- (VCInteractiveController *)interactiveVC {
    if (!_interactiveVC) {
        _interactiveVC = [[VCInteractiveController alloc] initWithCourseType:(CourseType)[VCCourseData shareInstance].courseInfo.type];
        _interactiveVC.delegate = self;
    }
    return _interactiveVC;
}
- (VCPlaceHolderView *)placeHolderView {
    if (!_placeHolderView) {
        _placeHolderView = [[VCPlaceHolderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*3/4)];
    }
    return _placeHolderView;
}

@end
