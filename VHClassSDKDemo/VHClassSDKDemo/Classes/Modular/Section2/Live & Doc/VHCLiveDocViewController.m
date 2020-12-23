//
//  VHCLiveDocViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/8.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCLiveDocViewController.h"
#import "VHLivePlayerController.h"
#import <VHClassSDK/VHCDocumentView.h>

@interface VHCLiveDocViewController ()<VHLivePlayerControllerDelegate>

@property (nonatomic, strong) VHLivePlayerController *liveVC;
@property (nonatomic, strong) VHCDocumentView *docView;

@end

@implementation VHCLiveDocViewController

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
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view addSubview:self.liveVC.view];
    [self.view addSubview:self.docView];
    
    [self.liveVC startPlay];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (SCREEN_WIDTH > SCREEN_HEIGHT)
    {
        self.liveVC.view.frame = self.view.bounds;
        self.docView.frame = CGRectMake(0, self.liveVC.view.bottom, self.view.width, self.docView.height);
    }
    else
    {
        self.liveVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4);
        self.docView.frame = CGRectMake(0, self.liveVC.view.bottom, self.view.width, self.view.height-self.liveVC.view.bottom);
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

#pragma mark - VHLivePlayerControllerDelegate
- (void)liveVc:(VHLivePlayerController *)vc playError:(VHCError *)error
{
    [VHCTool showAlertWithMessage:error.errorDescription];
}

#pragma mark - VHCDocumentViewControllerDataSource
//直播时实现此协议方法，传入直播延迟时间
- (NSInteger)docVcliveRelaBufferTime {
    if (_liveVC) {
        return [_liveVC getLiveRealBufferTime];
    }
    return 0;
}




- (VHLivePlayerController *)liveVC {
    if (!_liveVC) {
        _liveVC = [[VHLivePlayerController alloc] init];
        _liveVC.delegate = self;
    }
    return _liveVC;
}
- (VHCDocumentView *)docView {
    if (!_docView) {
        _docView = [[VHCDocumentView alloc] init];
        _docView.docType = VCDocType_Live;//直播文档
    }
    return _docView;
}


@end
