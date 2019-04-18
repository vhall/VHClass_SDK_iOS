//
//  VHCVODBusinessViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/16.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCVODBusinessViewController.h"
#import "VCPlaceHolderView.h"
#import "VHCVODPlayerController.h"

@interface VHCVODBusinessViewController ()<VHCVODPlayerControllerDelegate>

@property (nonatomic, strong) VHCVODPlayerController *playerVC;
@property (nonatomic, strong) VCPlaceHolderView *placeHolderView;

@end

@implementation VHCVODBusinessViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self destoryVod];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //设置页面不支持重力感应
    self.navigationController.autoRotate = NO;

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
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
    
    [self layoutWithClassState:[VCCourseData shareInstance].courseInfo.state];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)dealloc {
    
}

- (void)layoutWithClassState:(VHClassState)state
{
    switch (state) {
        case VHClassStateClassOn: //上课中
        {
            [VHCTool showAlertWithMessage:@"当前不是回放状态！"];
        }
            break;
        case VHClassStatusTrailer: //预告
        {
            [VHCTool showAlertWithMessage:@"当前不是回放状态！"];
            [self layoutPlaceHolder];
        }
            break;
        case VHClassStatusVod: //回放
        {
            [self layoutVod];
        }
            break;
        case VHClassStatusClassOver: //已下课
        {
            [VHCTool showAlertWithMessage:@"当前不是回放状态！"];
            [self layoutPlaceHolder];
        }
            break;
        default:
            break;
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

- (void)layoutVod {
    self.playerVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view insertSubview:self.playerVC.view atIndex:0];
    
    [self.playerVC play];
}
- (void)destoryVod {
    if (_playerVC) {
        [self.playerVC destroyPlayer];
        [self.playerVC.view removeFromSuperview];
        self.playerVC = nil;
    }
}

- (void)rotateScreen:(UIInterfaceOrientation)orientation
{
    //转屏时，先设置支持重力感应，否则此方法无效
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
    
    self.navigationController.orientation = orientation;
}

#pragma mark - VHCVODPlayerControllerDelegate
- (void)VodVc:(VHCVODPlayerController *)vc playError:(VHCError *)error
{
    [VHCTool showAlertWithMessage:error.errorDescription];
}
- (void)vodViewController:(VHCVODPlayerController *)vc fullscreenButtonClick:(UIButton *)fullscreenBtn
{
    fullscreenBtn.selected = !fullscreenBtn.selected;
    
    UIInterfaceOrientation orientation = fullscreenBtn.isSelected ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeRight;
    
    [self rotateScreen:orientation];
}



- (VHCVODPlayerController *)playerVC {
    if (!_playerVC) {
        _playerVC = [[VHCVODPlayerController alloc] init];
        _playerVC.delegate = self;
    }
    return _playerVC;
}

- (VCPlaceHolderView *)placeHolderView {
    if (!_placeHolderView) {
        _placeHolderView = [[VCPlaceHolderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*3/4)];
    }
    return _placeHolderView;
}

@end
