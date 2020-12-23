//
//  LiveViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/3/14.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "LiveViewController.h"
#import <VHClassSDK/VHCLivePlayer.h>
#import "VHActionSheet.h"
#import "VCLiveViewModel.h"
#import "VCAudioPlaceholderView.h"
#import "VCRecordRightViewController.h"
#import "VHLiveLayerView.h"

@interface LiveViewController ()<VHCLivePlayerDelegate,VHActionSheetDelegate,VHLiveLayerViewDelegate,VCRecordRightViewControllerDelegate>

@property (nonatomic, strong) VHCLivePlayer *livePlayer;
@property (nonatomic, strong) VCLiveViewModel *viewModel;
@property (nonatomic, strong) VCAudioPlaceholderView *audioPlaceHolder;
@property (nonatomic, strong) VHLiveLayerView *liveLayerView;
@property (nonatomic, strong) VCRecordRightViewController *rightVC;

@end

@implementation LiveViewController

- (void)dealloc {
    [self destoryPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.livePlayer.playerView.frame = self.view.bounds;
    [self.view addSubview:self.livePlayer.playerView];
    self.liveLayerView.frame = self.livePlayer.playerView.bounds;
    [self.livePlayer.playerView addSubview:self.liveLayerView];

    [self.livePlayer play];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateUI];
}

- (VHLiveLayerView *)liveLayerView {
    if (!_liveLayerView) {
        _liveLayerView = [[VHLiveLayerView alloc] init];
        _liveLayerView.delegate = self;
    }
    return _liveLayerView;
}
- (VHCLivePlayer *)livePlayer {
    if (!_livePlayer) {
        _livePlayer = [[VHCLivePlayer alloc] init];
        _livePlayer.delegate = self;
    }
    return _livePlayer;
}
- (VCLiveViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[VCLiveViewModel alloc] init];
    }
    return _viewModel;
}
- (VCAudioPlaceholderView *)audioPlaceHolder {
    if (!_audioPlaceHolder) {
        _audioPlaceHolder = [[VCAudioPlaceholderView alloc] initWithFrame:self.view.bounds];
    }
    return _audioPlaceHolder;
}
- (VCRecordRightViewController *)rightVC {
    if (!_rightVC) {
        _rightVC = [[VCRecordRightViewController alloc] init];
        _rightVC.delegate = self;
    }
    return _rightVC;
}

#pragma mark - VHCLivePlayerDelegate
- (void)playerDidRecivedMicroInvitation:(VHCLivePlayer *)player
{
    VHActionSheet *actionSheet = [[VHActionSheet alloc] initWithTitle:@"讲师正在邀请您上麦，请确认" delegate:self tag:10001 buttonTitles:@[@"上麦",@"语音上麦",@"拒绝"]];
    [actionSheet show];
}
- (void)player:(VHCLivePlayer *)player stateDidChanged:(VHPlayerState)state
{
    switch (state) {
        case VHPlayerStateLoading://准备播放
            [self.liveLayerView startIndicatorAnimating];
            break;
        case VHPlayerStatePlaying:
            [self.liveLayerView stopIndicatorAnimating];
            break;
        case VHPlayerStateStop://停止
            [self.liveLayerView stopIndicatorAnimating];
            break;
        case VHPlayerStateComplete://直播结束
            [self.liveLayerView stopIndicatorAnimating];
            break;
        default:
            break;
    }
}
- (void)player:(VHCLivePlayer *)player playError:(VHCError *)error
{
    NSLog(@"直播出错：%@",error.errorDescription);
    [self showTextView:VHKWindow message:error.errorDescription];
}
- (void)player:(VHCLivePlayer *)player supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions curDefinition:(VHCDefinition)definition
{
    [self.viewModel updateSupportDefinations:definitions curDifination:definition];

    BOOL support = [self.viewModel isSupportDefinition:4];
    BOOL audio = (definition == VHCDefinitionAu) ? YES : NO;
    
    if ([self.delegate respondsToSelector:@selector(liveViewController:isSupportAudio:isAudioOnly:)]) {
        [self.delegate liveViewController:self isSupportAudio:audio isAudioOnly:support];
    }
    [self updateUI];
    
    [self.rightVC supportDefinitions:definitions curDefinition:(NSInteger)definition];

    NSLog(@"supportDefinitions %@ curDefinition：%ld",definitions,definition);
}

#pragma mark - VHLiveLayerViewDelegate
//play and puss button action
- (void)recordView:(VHLiveLayerView *)view playButtonClick:(UIButton *)playBtn
{
    playBtn.selected = !playBtn.selected;
    if (playBtn.selected)
    {
        [self.livePlayer stopPlay];
    }
    else
    {
        [self.livePlayer play];
    }
}
//分辨率
- (void)recordView:(VHLiveLayerView *)view definationButtonClick:(UIButton *)button
{
    [self.rightVC changedShowType:RecordRightVCShowTypeDefination];
    
    self.rightVC.view.frame = self.view.bounds;
    [self.view addSubview:self.rightVC.view];
}

#pragma mark - VCRecordRightViewControllerDelegate
//分辨率回调
- (void)selectedDefination:(NSInteger)defination defiStr:(NSString *)str
{
    [self.livePlayer setDefinition:defination];
    
    [self.liveLayerView setDefination:str];
}

#pragma mark - VHActionSheetDelegate
-(void)actionSheet:(VHActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index {
    switch (index) {
        case 0:     //上麦
        {
            if ([self.delegate respondsToSelector:@selector(liveViewController:willEnterInteractive:)]) {
                [self.delegate liveViewController:self willEnterInteractive:NO];
            }
        }
            break;
        case 1:     //语音上麦
        {
            if ([self.delegate respondsToSelector:@selector(liveViewController:willEnterInteractive:)]) {
                [self.delegate liveViewController:self willEnterInteractive:YES];
            }
        }
            break;
        case 2:     //拒绝上麦
        {
            [_livePlayer refusOfMicroApplyWithType:1 complete:^(VHCError * _Nonnull error) {
                
            }];
        }
            break;
    }
}

#pragma mark - public
- (void)destoryPlayer {
    if (_livePlayer) {
        
        [_livePlayer stopPlay];
        [_livePlayer destroyPlayer];
    }
}

//举手
- (void)appplyHand {
    [self showProgressDialog:VHKWindow];
    [_livePlayer microApplySucess:^(VHCError * _Nonnull error) {
        [self hideProgressDialog:VHKWindow];
        if (error) {
            [self showTextView:self.view message:error.errorDescription];
        }
    }];
}
//开启音频模式
- (void)audioLiveOnly:(BOOL)isAudio
{
    [_livePlayer setDefinition:VHCDefinitionAu];
}

#pragma mark - private

- (void)updateUI
{
    self.livePlayer.playerView.frame = self.view.bounds;
    self.liveLayerView.frame = self.livePlayer.playerView.bounds;

    if (self.viewModel.curDifination == 4) {
        self.audioPlaceHolder.frame = self.livePlayer.playerView.bounds;
        [self.livePlayer.playerView addSubview:self.audioPlaceHolder];
    }
    else {
        [_audioPlaceHolder removeFromSuperview];
        _audioPlaceHolder = nil;
    }
}




@end
