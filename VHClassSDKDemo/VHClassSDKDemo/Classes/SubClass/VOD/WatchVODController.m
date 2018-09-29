//
//  WatchVODController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/4.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "WatchVODController.h"
#import "VHCVodPlayer.h"
#import "VodPlayerView.h"

@interface WatchVODController ()<VHCVodPlayerDelegate,VodPlayerViewDelegate>
{
    
}
@property (nonatomic, strong) VHCVodPlayer *vodPlayer;

@property (nonatomic, strong) VodPlayerView *playerView;

@end

@implementation WatchVODController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
    
    [self.vodPlayer play];
}

- (void)initViews
{
    [self.view addSubview:self.playerView];
}


#pragma mark - VHCVodPlayerDelegate
/**
 @brief 播放器状态变化回调
 
 @param player VHCLivePlayer实例对象
 @param state  变化后的状态
 */
- (void)player:(VHCVodPlayer *)player stateDidChanged:(VHPlayerState)state
{
    VHCLog(@"播放器状态：%ld",(long)state);
    switch (state) {
        case VHPlayerStatePreparing://准备播放
            [self.playerView startIndicatorAnimating];
            break;
        case VHPlayerStatePlaying://正在播放
            [self.playerView stopIndicatorAnimating];
            break;
        case VHPlayerStateStop://停止
            [self.playerView stopIndicatorAnimating];
            break;
        case VHPlayerStateError://出错
            [self.playerView stopIndicatorAnimating];
            break;
        case VHPlayerStateComplete://直播结束(下课了)
            [self.playerView stopIndicatorAnimating];
            break;
        default:
            break;
    }
}
/**
 @brief 播放出错回调
 
 @param error 错误
 */
- (void)player:(VHCVodPlayer *)player playError:(VHCError *)error
{
    NSLog(@"播放出错了：%@",error.errorDescription);
    [VHCTool showAlertWithMessage:error.errorDescription];
}
/**
 @brief 视频所支持的分辨率和当前视频分辨率回调
 
 @param definitions 支持的分辨率数组
 */
- (void)player:(VHCVodPlayer *)player supportDefinitions:(NSArray<__kindof NSNumber *> *)definitions
{
    VHCLog(@"当前视频支持的分辨率： %@",definitions);
}
/**
 @brief 当前视频分辨率改变回调
 
 视频调度后如果切换线路，分辨率有可能改变
 
 @param definition 改变之后的分辨率
 */
- (void)player:(VHCVodPlayer *)player definitionDidChanged:(VHDefinition)definition
{
    NSArray *arr = @[@"原画",@"超高清",@"高清",@"标清"];
    VHCLog(@"当前视频分辨率：%@",arr[definition]);
    [self.playerView setEpisodeBtnTitle:arr[definition]];
}
/**
 @brief 播放进度回调
 */
- (void)player:(VHCVodPlayer *)player currentTime:(NSTimeInterval)currentTime
{
    //VHCLog(@"播放进度：%f",currentTime);
    [self.playerView setValue:currentTime];
}
/**
 @brief 开始缓冲回调
 */
- (void)player:(VHCVodPlayer *)player bufferStart:(id)info
{
    VHCLog(@"开始缓冲");
}
/**
 @brief 开始播放回调
 */
- (void)player:(VHCVodPlayer *)player bufferStop:(id)info
{
    VHCLog(@"开始播放，总时长度：%f",player.duration);
    [self.playerView setMaximumValue:player.duration];
}
/**
 @brief 播放完成
 @discussion 播放完后播放器会先回调此方法，然后自动stopPlay。
 */
- (void)playerPlayComplete:(VHCVodPlayer *)player
{
    VHCLog(@"播放完成");
}

#pragma mark - VodPlayerViewDelegate
- (void)playerView:(VodPlayerView *)view playButtonClick:(UIButton *)playBtn
{
    playBtn.selected = !playBtn.selected;
    if (playBtn.selected)
    {
        [_vodPlayer pause];
    }
    else
    {
        [_vodPlayer resume];
    }
}
- (void)playerView:(VodPlayerView *)view slideTouchBegin:(UISlider *)slider
{
    [_vodPlayer pause];
}
- (void)playerView:(VodPlayerView *)view slideTouchEnd:(UISlider *)slider
{
    [_vodPlayer seek:slider.value];
    [_vodPlayer resume];
}
- (void)playerView:(VodPlayerView *)view slideValueChanged:(UISlider *)slider
{
    NSLog(@"slider value : %f",slider.value);
}
- (void)playerView:(VodPlayerView *)view episodeButtonClick:(UIButton *)episodeBtn
{
    [VHCTool showAlertWithMessage:@"回放只支持原画"];
}
- (void)playerView:(VodPlayerView *)view fullscreenButtonClick:(UIButton *)fullscreenBtn
{
    VHCLog(@"fullscreenButton.selected : %ld",(long)fullscreenBtn.selected);
}

#pragma mark - lazy load
- (VodPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[VodPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
        _playerView.backgroundColor = [UIColor blackColor];
        _playerView.delegate = self;
    }
    return _playerView;
}
- (VHCVodPlayer *)vodPlayer {
    if (!_vodPlayer) {
        _vodPlayer = [[VHCVodPlayer alloc] initWithPlayerView:self.playerView];
        _vodPlayer.delegate = self;
    }
    return _vodPlayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VHClassSDKDelegate
- (void)vhclass:(VHClassSDK *)sdk classStateDidChanged:(VHClassState)curState
{
    switch (curState) {
        case VHClassStateClassOn:
            [VHCTool showAlertWithMessage:@"上课了!"];
            break;
        case VHClassStatusClassOver:
            [VHCTool showAlertWithMessage:@"下课了!"];
            break;
        default:
            break;
    }
}

- (void)vhclass:(VHClassSDK *)sdk userEventChanged:(VHCUserEvent)curEvent
{
    
}

@end
