//
//  VHinteractiveViewController.m
//  UIModel
//
//  Created by vhall on 2018/7/30.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHinteractiveViewController.h"
#import "VHCInteractiveRoom.h"
#import "VHRenderView.h"

#define iconSize 34

@interface VHinteractiveViewController ()<VHCInteractiveRoomDelegate>
{
    UIButton *_micBtn;//麦克风按钮
    UIButton *_cameraBtn;//摄像头按钮
}
@property (nonatomic, strong) VHCInteractiveRoom *interactiveRoom;//互动房间
@property (nonatomic, strong) VHRenderView *cameraView;//本地摄像头

@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation VHinteractiveViewController

- (instancetype)init {
    if (self = [super init]) {

        _views = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    ///防止摄像头卡顿再此添加摄像头
    self.cameraView.frame = self.view.bounds;
    [self.view insertSubview:self.cameraView atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"互动直播间";
    
    [self setUpTopButtons];

    //进入互动房间
    [self.interactiveRoom enterLiveRoom];
    
    //程序进入前后台监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)appBecomeActive {
    //推流
    [_interactiveRoom publishWithCameraView:_cameraView];
}
- (void)appEnterBackground {
    //停止推流
    [_interactiveRoom stopPulish];
}

- (void)dealloc {
    [self leave];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc",self.description);
}

- (void)setUpTopButtons {
    //切换摄像头按钮
    UIButton *swapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    swapBtn.bounds = CGRectMake(0, 0, iconSize, iconSize);
    swapBtn.top = self.view.frame.size.height*0.5-((iconSize+6)*4)*0.5;
    swapBtn.right = self.view.right-12;
    [swapBtn setBackgroundImage:[UIImage imageNamed:@"icon_video_camera_switching"] forState:UIControlStateNormal];
    [swapBtn setBackgroundImage:[UIImage imageNamed:@"icon_video_camera_switching"] forState:UIControlStateSelected];
    [swapBtn addTarget:self action:@selector(swapStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:swapBtn];

    //开关摄像头按钮
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraBtn.frame = CGRectMake(swapBtn.left, swapBtn.bottom+12, iconSize, iconSize);
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"icon_video_open_camera"] forState:UIControlStateNormal];
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"icon_video_close_camera"] forState:UIControlStateSelected];
    [_cameraBtn addTarget:self action:@selector(videoStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];

    //麦克风按钮
    _micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _micBtn.frame = CGRectMake(_cameraBtn.left, _cameraBtn.bottom+12, iconSize, iconSize);
    [_micBtn setBackgroundImage:[UIImage imageNamed:@"icon_video_open_microphone"] forState:UIControlStateNormal];
    [_micBtn setBackgroundImage:[UIImage imageNamed:@"icon_video_close_microphone"] forState:UIControlStateSelected];
    [_micBtn addTarget:self action:@selector(micBtnStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_micBtn];

    //下麦按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(_micBtn.left, _micBtn.bottom+12, iconSize, iconSize);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_video_lowerwheat"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}


#pragma mark - VHRoomDelegate
/**
 @brief 进入互动直播间结果回调
 @param data   互动直播间数据
 @param error  错误
 @discussion   当error为nil时候，表示已进入互动直播间；error不为空时，表示进入失败，失败原因描述：error.errorDescription。成功进入互动直播间成功就可以开始推流上麦了。
 */
- (void)room:(VHCInteractiveRoom *)room didEnteredWithRoomMetaData:(NSDictionary *)data error:(VHCError *)error
{
    if (error) {
        VHCLog(@"互动房间连接出错");
        return;
    }
    VHCLog(@"互动房间连接成功，开始推流");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //上麦推流
        [room publishWithCameraView:self.cameraView];
    });
}

/**
 @brief 推流结果回调
 @param cameraView 推流的cameraView
 @param error      推流错误，当error不为空时表示推流失败
 @discussion 推流成功之后，会收到上麦结果的回调。
 */
- (void)room:(VHCInteractiveRoom *)room didPublishWithCameraView:(VHRenderView *)cameraView error:(VHCError *)error
{
    if (error) {
        VHCLog(@"推流出错！");
        return;
    }
    VHCLog(@"推流成功！");
}

/**
 @brief 停止推流回调
 @param cameraView 推流的cameraView
 @discussion 自己调用- unpublish停止推流，会回调此方法;被讲师下麦，会停止推流，回调此方法；推流出错,停止推流，会回调此方法。
 */
- (void)room:(VHCInteractiveRoom *)room didUnpublish:(VHRenderView *)cameraView
{
    VHCLog(@"停止推流！");
}

/**
 @brief 某用户上麦结果回调
 @param joinId 上麦用户的参会id
 @param error error为nil时上麦成功
 @discussion  当error为nil时，表示上麦成功。
 */
- (void)room:(VHCInteractiveRoom *)room microUpWithJoinId:(NSString *)joinId error:(VHCError *)error
{
    if (error) {
        if ([joinId isEqualToString:[User defaultUser].joinId]) {
            VHCLog(@"上麦失败!");
            [VHCTool showAlertWithMessage:@"上麦失败!"];
            //上麦失败，退到看直播
            [self closeButtonClick:nil];
        }
        return;
    }

    if ([joinId isEqualToString:[User defaultUser].joinId])
    {
        VHCLog(@"上麦成功!");
        [VHCTool showAlertWithMessage:@"您已上麦"];
    }
    else {
        [VHCTool showAlertWithMessage:[NSString stringWithFormat:@"用户%@上麦了",joinId]];
    }
}

/**
 @brief 某用户下麦成功回调
 @param byUserId 操作者户参会id，一般的自己被讲师下麦，此id为讲师参会id；自己主动下麦，此id为自己参会id
 @param toUserId 操作者户参会id，如果是自己的参会id，则表示自己被讲师下麦。
 @discussion 自己被讲师下麦，会自动停止推流，并自动离开房间。停止推流和房间连接状态的回调也会执行，如果自己被主播下麦，建议再次处理自己的业务逻辑，退出当前直播间。
 */
- (void)room:(VHCInteractiveRoom *)room leaveRoomByUserId:(NSString *)byUserId toUser:(NSString *)toUserId
{
    if ([toUserId isEqualToString:[User defaultUser].joinId])
    {
        VHCLog(@"已下麦!");
        [VHCTool showAlertWithMessage:@"您已下麦"];
        //已下麦，退到看直播
        [self closeButtonClick:nil];
    }
    else {
        [VHCTool showAlertWithMessage:[NSString stringWithFormat:@"用户%@已下麦了",toUserId]];
    }
}

/**
 @brief 用户与直播间的连接状态回调
 @param connectedStatus 用户与直播间的连接状态 @see VHCInteractiveRoomConnectedStatus
 @discussion 失去连接则表示该用户已经在主播端下麦，建议在此回调中处理下麦后的业务；当状态为VHCInteractiveRoomConnectedStatusConnected时，表示已成功上麦；当状态为VHCInteractiveRoomConnectedStatusDisConnected时，表示自己已下麦。
 */
- (void)room:(VHCInteractiveRoom *)room connectedStatusChanged:(VHCInteractiveRoomConnectedStatus)connectedStatus
{
    switch (connectedStatus) {
        case VHCInteractiveRoomConnectedStatusUnkonw:
            
            break;
        case VHCInteractiveRoomConnectedStatusConnecting:/** 连接中，进入房间后开始连接房间，进入房间开始推流状态*/
            VHCLog(@"正在连接互动房间...");
            break;
        case VHCInteractiveRoomConnectedStatusConnected:/** 已连接，互动中状态*/
            VHCLog(@"已连接。");
            break;
        case VHCInteractiveRoomConnectedStatusDisConnected:/** 失去连接，已下麦状态，被主播下麦、自己下麦、网络状态差失去连接等*/
            VHCLog(@"已失去了与互动房间的连接!");
            [VHCTool showAlertWithMessage:@"您已失去了与互动房间的连接!"];
            [self closeButtonClick:nil];
            break;
    }
}

///--------------------
/// @name 互动相关事件回调
///--------------------

/**
 @brief 新加入一路流（有成员进入互动房间，即有人上麦)
 @discussion 流id：attendView.streamId；上麦用户参会id：attendView.userId。
 */
- (void)room:(VHCInteractiveRoom *)room didAddAttendView:(VHRenderView *)attendView
{
    attendView.scalingMode = VHRenderViewScalingModeAspectFill;
    [self addView:attendView];
}

/**
 @brief 减少一路流（有成员离开房间，即有人下麦）
 @discussion 流id：attendView.streamId；上麦用户参会id：attendView.userId。
 */
- (void)room:(VHCInteractiveRoom *)room didRemovedAttendView:(VHRenderView *)attendView
{
    [self removeView:attendView];
}

/**
 @brief 关闭画面回调
 @param isClose YES:关闭，NO：打开
 @discussion byUserId操作者参会id，toUserId被操作者参会id。
 @warning 自己操作自己的设备byUserId和toUserId都是自己的参会id。
 */
- (void)room:(VHCInteractiveRoom *)room screenClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId
{
    if ([toUserId isEqualToString:[User defaultUser].joinId]) {
        _cameraBtn.selected = isClose;
    }
}

/**
 @brief 关闭麦克风回调，即静音操作回调
 @param isClose YES:关闭，NO：打开
 @discussion byUserId操作者参会id，toUserId被操作者参会id。
 @warning 自己操作自己的设备byUserId和toUserId都是自己的参会id。当toUserId == nil时候，表示全体静音
 */
- (void)room:(VHCInteractiveRoom *)room microphoneClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId
{
    if ([toUserId isEqualToString:[User defaultUser].joinId]) {
        _micBtn.selected = isClose;
    }
}

#pragma mark - button click
//退出
- (void)closeButtonClick:(UIButton *)sender {
    //返回上级页面
    [self.navigationController popViewControllerAnimated:YES];
}
//摄像头切换
- (void)swapStatusChanged:(UIButton *)sender {
    [_cameraView switchCamera];
}

//麦克风按钮事件
- (void)micBtnStatusChanged:(UIButton *)sender {
    //麦克风按钮图标变更
    sender.selected = !sender.selected;
    //麦克风操作
    (sender.selected) ? [_cameraView muteAudio] : [_cameraView unmuteAudio];
}
//摄像头按钮事件
- (void)videoStatusChanged:(UIButton *)sender {
    //麦克风按钮图标变更
    sender.selected = !sender.selected;
    //摄像头操作
    (sender.selected) ? [_cameraView muteVideo] : [_cameraView unmuteVideo];
}

#pragma mark - 互动观众
- (void)addView:(UIView*)view
{
    NSUInteger idx = [self.views indexOfObject:view];
    if(idx != NSNotFound) return;
    
    [self.views addObject:view];
    [self updateUI];
}
- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];
    [self.views removeObject:view];
    [self updateUI];
}
- (void)removeAllViews
{
    for (UIView *v in self.views) {
        [v removeFromSuperview];
    }
    [self.views removeAllObjects];
}
- (void)updateUI
{
    int i = 0;
    for (UIView *view in self.views) {
        view.frame = CGRectMake(8, 28+i*(80+1), 140, 80);
        [self.view addSubview:view];
        i++;
    }
}

- (void)leave {
    //停止推流
    [_interactiveRoom stopPulish];
    //离开互动房间
    [_interactiveRoom leaveLiveRoom];
    //移除互动视频
    [self removeAllViews];
}

- (VHCInteractiveRoom *)interactiveRoom {
    if (!_interactiveRoom) {
        _interactiveRoom = [[VHCInteractiveRoom alloc] init];
        _interactiveRoom.delegate = self;
    }
    return _interactiveRoom;
}
- (VHRenderView *)cameraView {
    if (!_cameraView) {
        //语音上麦，只推语音流
        NSDictionary *option = nil;
        if (_type == MicroTypeOnlyVoice) {
            option = @{VHVideoWidthKey:@"192",VHVideoHeightKey:@"144",VHVideoFpsKey:@(25),VHMaxVideoBitrateKey:@(200),VHStreamOptionStreamType:@(5)};
        }
        _cameraView = [[VHRenderView alloc] initCameraViewWithFrame:CGRectZero pushType:VHPushTypeSD options:option];
        if (_type == MicroTypeOnlyVoice)
        {
            [_cameraView muteVideo];
        }
        _cameraView.scalingMode = VHRenderViewScalingModeAspectFill;
    }
    return _cameraView;
}

//#pragma mark 权限
//- (BOOL)audioAuthorization
//{
//    BOOL authorization = NO;
//
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
//    switch (authStatus) {
//        case AVAuthorizationStatusNotDetermined:
//            //没有询问是否开启麦克风
//            break;
//        case AVAuthorizationStatusRestricted:
//            //未授权，家长限制
//            break;
//        case AVAuthorizationStatusDenied:
//            //玩家未授权
//            break;
//        case AVAuthorizationStatusAuthorized:
//            //玩家授权
//            authorization = YES;
//            break;
//        default:
//            break;
//    }
//    return authorization;
//}
//
//- (BOOL)cameraAuthorization
//{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus == AVAuthorizationStatusRestricted ||
//        authStatus == AVAuthorizationStatusDenied)
//    {
//        return NO;
//    }
//    return YES;
//}

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
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (void)vhclass:(VHClassSDK *)sdk userEventChanged:(VHCUserEvent)curEvent
{
    switch (curEvent) {
        case VHClassMainEventKickout:
            [VHCTool showAlertWithMessage:@"您已被主播踢出房间!"];
            break;
        case VHCUserEventInteractiveStart:
            [VHCTool showAlertWithMessage:@"可以开始互动了"];
            break;
        default:
            break;
    }
}


@end
