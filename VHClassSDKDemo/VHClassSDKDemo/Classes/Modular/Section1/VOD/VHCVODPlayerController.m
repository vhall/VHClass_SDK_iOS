//
//  VHCVODPlayerController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/8.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCVODPlayerController.h"
#import "VodPlayerView.h"

@interface VHCVODPlayerController ()<VHCVodPlayerDelegate,VodPlayerViewDelegate>

@property (nonatomic, strong, readwrite) VHCVodPlayer *vodPlayer;
@property (nonatomic, strong) VodPlayerView *playerView;

@end

@implementation VHCVODPlayerController

- (void)dealloc {
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.playerView.frame = self.view.bounds;
    self.vodPlayer.playerView.frame = self.playerView.bounds;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.playerView insertSubview:self.vodPlayer.playerView atIndex:0];
    [self.view addSubview:self.playerView];
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
        if (_vodPlayer.playerState == VHPlayerStateComplete)
        {
            [_vodPlayer setCurrentTime:0];
        }
        else
        {
            [_vodPlayer resume];
        }
    }
}
- (void)playerView:(VodPlayerView *)view slideTouchBegin:(UISlider *)slider
{
    [_vodPlayer pause];
}
- (void)playerView:(VodPlayerView *)view slideTouchEnd:(UISlider *)slider
{
    [_vodPlayer setCurrentTime:slider.value];
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
    if ([self.delegate respondsToSelector:@selector(vodViewController:fullscreenButtonClick:)]) {
        [self.delegate vodViewController:self fullscreenButtonClick:fullscreenBtn];
    }
}

#pragma mark - VHCVodPlayerDelegate
/**
 播放器状态变化回调
 
 @param player VHCVodPlayer实例对象
 @param state  变化后的状态
 */
- (void)player:(VHCVodPlayer *)player stateDidChanged:(VHPlayerState)state
{
    VHCLog(@"播放器状态：%ld",(long)state);
    switch (state) {
        case VHPlayerStateLoading://准备播放
            [self.playerView startIndicatorAnimating];
            break;
        case VHPlayerStatePlaying://正在播放
            [self.playerView stopIndicatorAnimating];
            self.playerView.playBtn.selected = NO;
            self.playerView.maximumValue = player.duration;
            VHCLog(@"开始播放，总时长度：%f",player.duration);
            [self.playerView setMaximumValue:player.duration];
            break;
        case VHPlayerStateStop://停止
            [self.playerView stopIndicatorAnimating];
            self.playerView.playBtn.selected = YES;
            break;
        case VHPlayerStatePause://暂停
            self.playerView.playBtn.selected = YES;
            break;
        case VHPlayerStateComplete://直播结束(下课了)
            [self.playerView stopIndicatorAnimating];
            self.playerView.playBtn.selected = YES;
            break;
        default:
            break;
    }
}
/**
 视频所支持的分辨率
 
 @param definitions 支持的分辨率数组
 */
- (void)player:(VHCVodPlayer *)player supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions curDefinition:(VHCDefinition)definition
{
    VHCLog(@"当前视频支持的分辨率： %@",definitions);
}
/**
 播放出错回调
 
 @param error 错误
 
 @see LiveStatus
 */
- (void)player:(VHCVodPlayer *)player playError:(VHCError *)error
{
    NSLog(@"播放出错了：%@",error.errorDescription);
    if ([self.delegate respondsToSelector:@selector(VodVc:playError:)]) {
        [self.delegate VodVc:self playError:error];
    }
}
/**
 下载速度回调
 
 @param speed 错误
 */
- (void)player:(VHCVodPlayer *)player loadingWithSpeed:(NSString *)speed
{
    
}
/**
 当前播放时间回调
 */
- (void)player:(VHCVodPlayer*)player playTime:(NSTimeInterval)currentTime
{
    VHCLog(@"播放进度：%f",currentTime);
    [self.playerView setValue:currentTime];
    
    if ([self.delegate respondsToSelector:@selector(vodViewController:currentTime:)]) {
        [self.delegate vodViewController:self currentTime:currentTime];
    }
}







#pragma mark - public
- (void)play
{
    [self.vodPlayer play];
}

- (void)pause
{
    [self.vodPlayer play];
}

- (void)resume
{
    [self.vodPlayer resume];
}

- (void)stopPlay
{
    [self.vodPlayer stopPlay];
}

- (void)destroyPlayer
{
    [self.vodPlayer destroyPlayer];
    self.vodPlayer = nil;
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
        _vodPlayer = [[VHCVodPlayer alloc] init];
        _vodPlayer.delegate = self;
    }
    return _vodPlayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
