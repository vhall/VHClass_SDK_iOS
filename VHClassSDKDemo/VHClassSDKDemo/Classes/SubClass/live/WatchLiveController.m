//
//  WatchLiveController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/4.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "WatchLiveController.h"
#import "VHCLivePlayer.h"
#import "VHinteractiveViewController.h"
#import "MicCountDownView.h"

#define kDefinitions (@[@"原画",@"超高清",@"高清",@"标清"])

@interface WatchLiveController ()<VHCLivePlayerDelegate,UIAlertViewDelegate>
{
    UIButton *_contentModelBtn;
    UIButton *_definitaionButton;
    UIButton *_playButton;
    UIButton *_handButton;
    
    BOOL _isEnterInteractive;
}
@property (nonatomic, strong) VHCLivePlayer *player;

@property (nonatomic, strong) MicCountDownView *handView;
@property (nonatomic) dispatch_queue_t asyncQueue;

@end

@implementation WatchLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"旁路直播间";
    
    self.view.backgroundColor = [UIColor blackColor];

    [self initViews];
    
    if (_asyncQueue == nil) {
        _asyncQueue = dispatch_queue_create("cn.vhall.client", DISPATCH_QUEUE_SERIAL);
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _isEnterInteractive = NO;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    self.player.playerView.frame = self.view.bounds;
    self.player.contentModel = VHLiveViewContentModeAspectFit;
    [self.view insertSubview:self.player.playerView atIndex:0];
    [self.player play];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    ///@warning 解决从互动退出到旁路卡顿问题，释放播放器对象。
    [self.player.playerView removeFromSuperview];
    dispatch_async(_asyncQueue, ^{
        [self.player stopPlay];
        [self.player destroyPlayer];
        self.player = nil;
    });

    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.player.playerView.frame = self.view.bounds;
}

- (void)dealloc {
    //需手动释放播放器对象
    [_player destroyPlayer];
}


- (void)initViews
{
    [self player];
    
    [self addSomeControl];
}
- (void)addSomeControl
{
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.backgroundColor = [UIColor redColor];
    [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playButton setTitle:@"暂停" forState:UIControlStateNormal];
    [_playButton setTitle:@"播放" forState:UIControlStateSelected];
    [_playButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    _playButton.frame = CGRectMake(16, 20+320+16, 46, 28);
    _playButton.layer.cornerRadius = 4;
    [self.view addSubview:_playButton];
    _playButton.tag = 1000;
    [_playButton addTarget:self action:@selector(playButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _handButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _handButton.frame = CGRectMake(16, _playButton.bottom+16, 46, 28);
    _handButton.backgroundColor = [UIColor redColor];
    [_handButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_handButton setTitle:@"举手" forState:UIControlStateNormal];
    [_handButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    _handButton.layer.cornerRadius = 4;
    [self.view addSubview:_handButton];
    _handButton.tag = 1001;
    [_handButton addTarget:self action:@selector(handButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _handView = [[MicCountDownView alloc] init];
    _handView.bounds = CGRectMake(0, 0, 37, 27.5);
    _handView.center = _handButton.center;
    _handView.bottom = _handButton.top-5;
    _handView.image = [UIImage imageNamed:@"video_time_popup"];
    [_handView hiddenCountView];
    [self.view addSubview:_handView];

    NSArray *customTitles2 = @[@"None",@"AspectFit",@"AspectFill"];
    for (int i = 0; i < customTitles2.count; i++) {
        UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
        sender.backgroundColor = [UIColor lightGrayColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setTitle:customTitles2[i] forState:UIControlStateNormal];
        [sender.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        sender.frame = CGRectMake(16+i*(66+16), 20+320+16+28+16+28+16, 66, 28);
        sender.layer.cornerRadius = 4;
        [self.view addSubview:sender];
        
        sender.tag = 1002+i;
        if (i == 1) {
            _contentModelBtn = sender;
            _contentModelBtn.backgroundColor = [UIColor redColor];
        }
        [sender addTarget:self action:@selector(contentModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    NSArray *customTitles3 = @[@"原画",@"超高清",@"高清",@"标清"];
    for (int i = 0; i < customTitles3.count; i++) {
        UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
        sender.backgroundColor = [UIColor lightGrayColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setTitle:customTitles3[i] forState:UIControlStateNormal];
        [sender.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        sender.frame = CGRectMake(16+i*(66+16), 20+320+16+28+16+28+16+28+16, 66, 28);
        sender.layer.cornerRadius = 4;
        [self.view addSubview:sender];
        
        sender.tag = 1005+i;
        sender.enabled = NO;
        
        [sender addTarget:self action:@selector(dfinitionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//播放、停止
- (void)playButtonButtonClick:(UIButton *)sender {
    
    switch (_player.playerState) {
        case VHPlayerStateStop:
            //播放
            [self.player play];
            sender.backgroundColor = [UIColor lightGrayColor];
            break;
        case VHPlayerStatePlaying:
            //暂停
            [self.player stopPlay];
            sender.backgroundColor = [UIColor redColor];
            break;
        case VHPlayerStateComplete:
            
            break;
        default:
            break;
    }
}
//举手
- (void)handButtonButtonClick:(UIButton *)button
{
    if (_handView.hidden) {
        [self.player microApplySucess:^(VHCError *error) {
            [self->_handView countdDown:30];
            if (error) {
                [VHCTool showAlertWithMessage:[NSString stringWithFormat:@"%@",error.errorDescription]];
                [self->_handView hiddenCountView];
            }
        }];
    }
}
//设置填充模式
- (void)contentModeBtnClick:(UIButton *)sender {
    _contentModelBtn.backgroundColor = [UIColor lightGrayColor];
    sender.backgroundColor = [UIColor redColor];
    _contentModelBtn = sender;
    [self.player setContentModel:sender.tag-1002];
}
//切换分辨率
- (void)dfinitionBtnClick:(UIButton *)sender
{
    _definitaionButton = sender;
    [_player setDefinition:sender.tag-1005];
}

#pragma mark - VHCLivePlayerDelegate
/**
 举手设置回调
 */
- (void)player:(VHCLivePlayer *)player interactivePermission:(VHInteractiveState)state
{
    switch (state) {
        case VHInteractiveStateWithOut://当前不允许“举手“
            _handButton.hidden = YES;
            NSLog(@"不允许举手！");
            break;
        case VHInteractiveStateHave:
            _handButton.hidden = NO;
            NSLog(@"允许举手！");
            break;
    }
}
/**
 播放器状态变化回调
 @param player VHCLivePlayer实例对象
 @param state  变化后的状态
 */
- (void)player:(VHCLivePlayer *)player stateDidChanged:(VHPlayerState)state
{
    switch (state) {
        case VHPlayerStatePreparing://准备播放
            [MBProgressHUD showHUDAddedTo:self.player.playerView animated:YES];
            break;
        case VHPlayerStatePlaying:
            [MBProgressHUD hideHUDForView:self.player.playerView animated:NO];
            
            break;
        case VHPlayerStateStop://停止
            [MBProgressHUD hideHUDForView:self.player.playerView animated:NO];
            
            break;
        case VHPlayerStateError://出错
            [MBProgressHUD hideHUDForView:self.player.playerView animated:NO];
            
            break;
        case VHPlayerStateComplete://直播结束(下课了)
            [MBProgressHUD hideHUDForView:self.player.playerView animated:NO];
            break;
        default:
            break;
    }
}
/**
 视频所支持的分辨率
 @param definitions 支持的分辨率数组
 */
- (void)player:(VHCLivePlayer *)player supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions
{
    for (int i = 0; i<definitions.count; i++) {
        NSNumber *number = definitions[i];
        NSInteger dx = [number integerValue];
        UIButton *button = [self.view viewWithTag:dx+1005];
        button.enabled = YES;
    }
}
/**
 当前视频分辨率改变回调
 视频调度后如果切换线路，分辨率有可能改变
 @param definition 改变之后的分辨率
 */
- (void)player:(VHCLivePlayer *)player definitionDidChanged:(VHDefinition)definition
{
    NSArray *arr = @[@"原画",@"超高清",@"高清",@"标清"];
    VHCLog(@"当前视频分辨率：%@",arr[definition]);
    
    _definitaionButton.backgroundColor = [UIColor lightGrayColor];
    UIButton *button = [self.view viewWithTag:1005+definition];
    button.backgroundColor = [UIColor redColor];
}
/**
 播放出错回调
 @param error 错误
 @see LiveStatus
 */
- (void)player:(VHCLivePlayer *)player playError:(VHCError *)error
{
    VHCLog(@"直播出错：%@",error.errorDescription);
    [VHCTool showAlertWithMessage:error.errorDescription];
}
/**
 下载速度回调
  @param speed 错误
 */
- (void)player:(VHCLivePlayer *)player loadingWithSpeed:(NSString *)speed
{
    //VHCLog(@"直播下载速度：%@",speed);
}
/**
 @brief      上麦回调
 @discussion 上麦方式有两种：1、用户申请上麦，讲师端收到申请，审批同意后会执行此回调；2、讲师直接邀请参会用户上麦，会执行此回调。
 @warning    收到此回调后用户方可以进行上麦推流。
 */
- (void)playerDidRecivedMicroInvitation:(VHCLivePlayer *)player
{
    VHCLog(@"讲师邀请您连麦互动！");
    
    //Coding ...
    //如果当前不是在看直播 return;
    
    //如果已进入互动界面 return
    if (_isEnterInteractive) {
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"讲师邀请您上麦" delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"上麦",@"语音上麦", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"拒绝上麦");
        [self.player refusOfMicroApplyWithType:1 complete:nil];
    }
    else {
        _isEnterInteractive = YES;
        VHinteractiveViewController *controller = [[VHinteractiveViewController alloc] init];
        if (buttonIndex == 2)
        {
            controller.type = MicroTypeOnlyVoice;
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (VHCLivePlayer *)player {
    if (!_player) {
        _player = [[VHCLivePlayer alloc] init];
        _player.delegate = self;
    }
    return _player;
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
            [_player play];
            break;
        case VHClassStatusClassOver:
            [VHCTool showAlertWithMessage:@"下课了!"];
            [_player stopPlay];
            break;
        default:
            break;
    }
}

- (void)vhclass:(VHClassSDK *)sdk userEventChanged:(VHCUserEvent)curEvent
{
    
}

@end
