//
//  VHLivePlayerController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/16.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHLivePlayerController.h"
#import "VCRecordRightViewController.h"
#import "VHLiveLayerView.h"
#import "VCAudioPlaceholderView.h"

@interface VHLivePlayerController ()<VHCLivePlayerDelegate,VHLiveLayerViewDelegate,VCRecordRightViewControllerDelegate>

@property (nonatomic, strong, readwrite) VHCLivePlayer *livePlayer;
@property (nonatomic, strong) VHLiveLayerView *liveLayerView;
@property (nonatomic, strong) VCRecordRightViewController *rightVC;

@property (nonatomic, strong) VCAudioPlaceholderView *audioPlaceHolder;

@end


@implementation VHLivePlayerController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view insertSubview:self.livePlayer.playerView atIndex:0];
    [self.livePlayer.playerView addSubview:self.liveLayerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
 
    self.livePlayer.playerView.frame = self.view.bounds;
    self.liveLayerView.frame = self.livePlayer.playerView.bounds;
}

- (void)dealloc {
    
}

#pragma mark - VHCLivePlayerDelegate
- (void)playerDidRecivedMicroInvitation:(VHCLivePlayer *)player
{
    
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
            [VHCTool showAlertWithMessage:@"直播已结束！"];
            break;
        default:
            break;
    }
}
- (void)player:(VHCLivePlayer *)player playError:(VHCError *)error
{
    NSLog(@"直播出错：%@",error.errorDescription);
    if ([self.delegate respondsToSelector:@selector(liveVc:playError:)]) {
        [self.delegate liveVc:self playError:error];
    }
}
- (void)player:(VHCLivePlayer *)player supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions curDefinition:(VHCDefinition)definition
{
    //设置是否音频模式
    if (definition == VHCDefinitionAu) {
        self.audioPlaceHolder.frame = self.livePlayer.playerView.bounds;
        [self.livePlayer.playerView addSubview:self.audioPlaceHolder];
    }
    else {
        [_audioPlaceHolder removeFromSuperview];
        _audioPlaceHolder = nil;
    }
    
    //设置支持的分辨率
    [self.rightVC supportDefinitions:definitions curDefinition:(NSInteger)definition];
    
    //填充模式
    [self.liveLayerView setScallingModel:player.contentModel];
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
//画面填充模式
- (void)recordView:(VHLiveLayerView *)view scallingBtnClick:(UIButton *)button
{
    [MBProgressHUD showHUDAddedTo:VHKWindow animated:YES];
    NSArray *arr = @[@"Fill",@"AFit",@"AFill"];
    NSInteger index = [arr indexOfObject:button.titleLabel.text];
    index++;
    if (index > 2) {
        index = 0;
    }
    if (index < 0) {
        index = 0;
    }
    [self.livePlayer setContentModel:(VHLiveViewContentMode)index];
    //填充模式
    [self.liveLayerView setScallingModel:self.livePlayer.contentModel];
    [MBProgressHUD hideHUDForView:VHKWindow animated:NO];
}

#pragma mark - VCRecordRightViewControllerDelegate
//分辨率回调
- (void)selectedDefination:(NSInteger)defination defiStr:(NSString *)str
{
    [self.livePlayer setDefinition:defination];
    
    [self.liveLayerView setDefination:str];
}



#pragma mark - public
- (void)startPlay
{
    [self.livePlayer play];
}

- (void)stopPlay
{
    [self.livePlayer stopPlay];
}

- (void)destoryPlay
{
    [self.livePlayer destroyPlayer];
    self.livePlayer = nil;//注意：此处不可缺，每次直播新创建livePlayer对象。
}

- (NSInteger)getLiveRealBufferTime
{
    return (_livePlayer.realBufferTime/1000)+3.0;
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

@end
