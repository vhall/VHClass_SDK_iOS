//
//  VHCLiveBusinessViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/8.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCLiveBusinessViewController.h"
#import "VHLivePlayerController.h"
#import "VCPlaceHolderView.h"

@interface VHCLiveBusinessViewController ()<VHLivePlayerControllerDelegate>

@property (nonatomic, strong) VHLivePlayerController *playerVC;
@property (nonatomic, strong) VCPlaceHolderView *placeHolderView;

@end

@implementation VHCLiveBusinessViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self destoryLive];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutWithClassState:[VCCourseData shareInstance].courseInfo.state];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_playerVC) {
        self.playerVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    }
    if (_placeHolderView) {
        self.placeHolderView.frame = CGRectMake(0, 0, self.view.width, self.view.width*3/4);
    }
}

- (void)dealloc {
    
}


- (void)layoutWithClassState:(VHClassState)state
{
    switch (state) {
        case VHClassStateClassOn: //上课中
        {
            [self layoutLive];
        }
            break;
        case VHClassStatusTrailer: //预告
        {
            [self layoutPlaceHolder];
        }
            break;
        case VHClassStatusVod: //回放
        {
            [VHCTool showAlertWithMessage:@"当前不是直播状态！"];
        }
            break;
        case VHClassStatusClassOver: //已下课
        {
            [self layoutPlaceHolder];
        }
            break;
        default:
            break;
    }
}

- (void)layoutLive
{
    self.playerVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view insertSubview:self.playerVC.view atIndex:0];
    
    [self.playerVC startPlay];
}
- (void)destoryLive {
    if (_playerVC) {
        [self.playerVC destoryPlay];
        [self.playerVC.view removeFromSuperview];
        self.playerVC = nil;
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


#pragma mark - VHLivePlayerControllerDelegate
- (void)liveVc:(VHLivePlayerController *)vc playError:(VHCError *)error
{
    [VHCTool showAlertWithMessage:error.errorDescription];
}






- (VHLivePlayerController *)playerVC {
    if (!_playerVC) {
        _playerVC = [[VHLivePlayerController alloc] init];
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
