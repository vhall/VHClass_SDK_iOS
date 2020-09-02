//
//  VHCVODDocViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/8.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCVODDocViewController.h"
#import "VHCVODPlayerController.h"
#import "VHCDocumentView.h"

@interface VHCVODDocViewController ()<VHCVODPlayerControllerDelegate,VHCDocumentViewDataSource>

@property (nonatomic, strong) VHCVODPlayerController *vodVC;
@property (nonatomic, strong) VHCDocumentView * docView;

@end

@implementation VHCVODDocViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //设置页面不支持重力感应
    self.navigationController.autoRotate = NO;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //恢复重力感应
    self.navigationController.autoRotate = YES;
    //转为竖屏
    [self rotateScreen:UIInterfaceOrientationPortrait];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.vodVC.view];
    [self.view addSubview:self.docView];
    
    [self.vodVC play];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (SCREEN_WIDTH > SCREEN_HEIGHT)
    {
        self.vodVC.view.frame = self.view.bounds;
        self.docView.frame = CGRectMake(0, self.vodVC.view.bottom, self.view.width, self.docView.height);
    }
    else
    {
        self.vodVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4);
        self.docView.frame = CGRectMake(0, self.vodVC.view.bottom, self.view.width, self.view.height-self.vodVC.view.bottom);
    }
}

- (void)rotateScreen:(UIInterfaceOrientation)orientation
{
    self.navigationController.autoRotate = YES;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        NSNumber *num = [[NSNumber alloc] initWithInt:orientation];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    SEL selector=NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    
    self.navigationController.autoRotate = NO;
}

#pragma mark - VHCVODViewControllerDelegate
- (void)VodVc:(VHCVODPlayerController *)vc playError:(VHCError *)error
{
    [VHCTool showAlertWithMessage:error.errorDescription];
}
//全屏事件回调
- (void)vodViewController:(VHCVODPlayerController *)vc fullscreenButtonClick:(UIButton *)fullscreenBtn
{
    fullscreenBtn.selected = !fullscreenBtn.selected;
    
    UIInterfaceOrientation orientation = fullscreenBtn.selected ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeRight;
    
    [self rotateScreen:orientation];
}
//回放播放器当前播放时间回调
- (void)vodViewController:(VHCVODPlayerController *)vc currentTime:(NSTimeInterval)currentTime
{
    [self.docView setVodCurrentTime:currentTime];
}






- (VHCVODPlayerController *)vodVC {
    if (!_vodVC) {
        _vodVC = [[VHCVODPlayerController alloc] init];
        _vodVC.delegate = self;
    }
    return _vodVC;
}
- (VHCDocumentView *)docView {
    if (!_docView) {
        _docView = [[VHCDocumentView alloc] init];
        _docView.docType = VCDocType_Vod;//回放文档
    }
    return _docView;
}


@end
