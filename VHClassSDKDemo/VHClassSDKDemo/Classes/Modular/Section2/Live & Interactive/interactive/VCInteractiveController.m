//
//  VCInteractiveController.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/18.
//  Copyright © 2019 class. All rights reserved.
//

#import "VCInteractiveController.h"
#import "VHCInteractiveRoom.h"
#import "VHRenderView.h"
#import "VCLiveLayoutView.h"
#import "VCInteractiveMaskView.h"
#import "VCInteractor.h"
#import "VCInteractiveModel.h"
#import "VHCError.h"

@interface VCInteractiveController ()<VHCInteractiveRoomDelegate,VCLiveLayoutViewDelegate,VHAlertViewDelegate>

@property (nonatomic, assign) CourseType courseType;

@property (nonatomic, strong) VHCInteractiveRoom *interactiveRoom;//互动房间
@property (nonatomic, strong) VCInteractiveModel *viewModel;

@property (nonatomic, strong) VHRenderView *cameraView;//本地摄像头
@property (nonatomic, strong) VCLiveLayoutView *layoutView;//互动布局

@end

@implementation VCInteractiveController

- (instancetype)init {
    if (self = [super init]) {
        _courseType = CourseTypeDefault;
    }
    return self;
}
- (instancetype)initWithCourseType:(CourseType)type {
    if (self = [super init]) {
        _courseType = type;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self)weakSelf = self;
    [self.viewModel getMyAttendMaskViewWithCameraView:self.cameraView sucess:^(VCInteractiveMaskView * _Nonnull maskView) {
        [weakSelf.cameraView addSubview:maskView];
        [weakSelf.layoutView addView:weakSelf.cameraView type:AddViewTypeOwn];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _layoutView.frame = self.view.bounds;
    [_cameraView setDeviceOrientation:[UIDevice currentDevice].orientation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //互动布局
    if (_courseType == CourseType_1VN) {
        self.layoutView = [[VCLiveLayoutView alloc] initWithFrame:self.view.bounds layoutType:ViewLayoutType1vN];
    }
    else {
        self.layoutView = [[VCLiveLayoutView alloc] initWithFrame:self.view.bounds layoutType:ViewLayoutType1v1];
    }
    self.layoutView.delegate = self;
    [self.view addSubview:self.layoutView];
    
    //进入互动房间
    [self.interactiveRoom enterLiveRoom];

    //程序进入前后台监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)appBecomeActive {
    //推流
    [_interactiveRoom startPublish];
}
- (void)appEnterBackground {
    //停止推流
    [_interactiveRoom stopPulish];
}

- (void)dealloc {
    [_layoutView removeFromSuperview];
    _layoutView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc",self.description);
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
        NSLog(@"互动房间连接出错");
        return;
    }
    NSLog(@"互动房间连接成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        //上麦推流
        [room startPublish];
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
        NSLog(@"推流出错！");
        return;
    }
    NSLog(@"推流成功！");
    //设置外放音量
    [room setSpeakerphoneOn:YES];
}

/**
 @brief 停止推流回调
 @param cameraView 推流的cameraView
 @discussion 自己调用- unpublish停止推流，会回调此方法;被讲师下麦，会停止推流，回调此方法；推流出错,停止推流，会回调此方法。
 */
- (void)room:(VHCInteractiveRoom *)room didUnpublish:(VHRenderView *)cameraView
{
    NSLog(@"停止推流！");
}

/**
 @brief 某用户上麦结果回调
 @param joinId 上麦用户的参会id
 @param error error为nil时上麦成功
 @param info 其他信息
 @discussion  当error为nil时，表示上麦成功。
 */
- (void)room:(VHCInteractiveRoom *)room microUpWithJoinId:(NSString *)joinId attributes:(NSDictionary *)info error:(VHCError *)error
{
    if (error) {
        if ([joinId isEqualToString:[VCCourseData shareInstance].joinId]) {
            [self showTextView:VHKWindow message:@"上麦失败!"];
            //上麦失败，退到看直播
            [self didError:[VHCError errorWithCode:0 errorDescription:@"上麦失败!"]];
        }
        return;
    }
    
    if ([joinId isEqualToString:[VCCourseData shareInstance].joinId])
    {
        [self showTextView:VHKWindow message:@"您已上麦"];
    }
    else
    {
        [self showTextView:VHKWindow message:[NSString stringWithFormat:@"用户%@上麦了",info[@"user"][@"nick_name"]]];
    }
}
/**
 @brief 某用户下麦回调
 @param info 其他信息
 @param joinId 下麦用户的参会id
 */
- (void)room:(VHCInteractiveRoom *)room microDownWithJoinId:(NSString *)joinId attributes:(NSDictionary *)info
{
    if ([joinId isEqualToString:[VCCourseData shareInstance].joinId])
    {
        //自己下麦后self对象被释放，收不到该回调，此处提示无用
        //[self showTextView:VHKWindow message:@"您已下麦!"];
    }
    else
    {
        [self showTextView:VHKWindow message:[NSString stringWithFormat:@"用户%@下麦了",info[@"user"][@"nick_name"]]];
    }
}

/**
 @brief 某用户被讲师下麦回调
 @param byUserId 操作者户参会id，一般的自己被讲师下麦，此id为讲师参会id
 @param toUserId 被操作者户参会id，如果是自己的参会id，则表示自己被讲师下麦。
 */
- (void)room:(VHCInteractiveRoom *)room leaveRoomByUserId:(NSString *)byUserId toUser:(NSString *)toUserId
{
    NSString *myId = [VCCourseData shareInstance].joinId;
    if ([toUserId isEqualToString:myId] && ![byUserId isEqualToString:myId]) {
        [self showTextView:VHKWindow message:@"您已被讲师下麦!"];
        //上麦失败，退到看直播
        [self didError:[VHCError errorWithCode:0 errorDescription:@"您已被讲师下麦!"]];
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
            NSLog(@"正在连接互动房间...");
            break;
        case VHCInteractiveRoomConnectedStatusConnected:/** 已连接，互动中状态*/
            NSLog(@"已连接。");
            break;
        case VHCInteractiveRoomConnectedStatusDisConnected:/** 失去连接，已下麦状态，被主播下麦、自己下麦、网络状态差失去连接等*/
            [self showTextView:VHKWindow message:@"您已失去了与互动房间的连接!"];
            [self didError:[VHCError errorWithCode:0 errorDescription:@"您已失去了与互动房间的连接!"]];
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
    __weak typeof(self)weakSelf = self;
    //去重
    VHRenderView *v = [self.viewModel isHaveAttender:attendView];
    if (v != nil) {
        [self.layoutView removeView:v];
        [self.viewModel removeAttenderView:v];
    }
    //添加
    [weakSelf.viewModel getAttendMaskViewWithUserId:attendView.userId sucess:^(VCInteractiveMaskView * _Nonnull maskView) {
        [attendView addSubview:maskView];
        if (maskView.actor.userRole == VHCLiveUserRoleHost) {
            if (attendView.streamType == VHInteractiveStreamTypeScreen) {
                //共享桌面设置填充模式为fit，否则会裁剪掉部分内容，其他设置填满。
                attendView.scalingMode = VHRenderViewScalingModeAspectFit;
                maskView.actor.micphoneClose = NO;
                maskView.actor.cameraClose = NO;
                [weakSelf.layoutView addView:attendView type:AddViewTypeShared];
            }
            else {
                [weakSelf.layoutView addView:attendView type:AddViewTypeHost];
            }
        } else {
            [weakSelf.layoutView addView:attendView type:AddViewTypeOther];
        }
        //保存attendView
        [weakSelf.viewModel saveAttenderView:attendView];
    } failed:^(VHCError * _Nonnull error, VCInteractiveMaskView * _Nonnull maskView) {
        [attendView addSubview:maskView];
        [weakSelf.layoutView addView:attendView type:AddViewTypeOther];
        [weakSelf.viewModel saveAttenderView:attendView];
    }];
}

/**
 @brief 减少一路流（有成员离开房间，即有人下麦）
 @discussion 流id：attendView.streamId；上麦用户参会id：attendView.userId。
 */
- (void)room:(VHCInteractiveRoom *)room didRemovedAttendView:(VHRenderView *)attendView
{
    [_layoutView removeView:attendView];
    //移除本地对attendView的保留
    [self.viewModel removeAttenderView:attendView];
}

/**
 @brief 关闭画面回调
 @param isClose YES:关闭，NO：打开
 @discussion byUserId操作者参会id，toUserId被操作者参会id。
 @warning 自己操作自己的设备byUserId和toUserId都是自己的参会id。
 */
- (void)room:(VHCInteractiveRoom *)room screenClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId
{
    NSString *msg = [self.viewModel videoAlertMsgWithMicrophoneClosed:isClose byUser:byUserId toUser:toUserId];
    if (msg) {
        [self showTextView:VHKWindow message:msg];
    }

    [_layoutView liveUser:toUserId cameraStatusChanged:isClose byUser:byUserId];
}

/**
 @brief 关闭麦克风回调，即静音操作回调
 @param isClose YES:关闭，NO：打开
 @discussion byUserId操作者参会id，toUserId被操作者参会id。
 @warning 自己操作自己的设备byUserId和toUserId都是自己的参会id。当toUserId == nil时候，表示全体静音。全体禁音针对的群体是除讲师外的所有学员，因此将时端开启全体禁音时，讲师并不会被禁音，除非讲师自己禁音。
 */
- (void)room:(VHCInteractiveRoom *)room microphoneClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId
{
    NSString *msg = [self.viewModel audioAlertMsgWithMicrophoneClosed:isClose byUser:byUserId toUser:toUserId];
    if (msg) {
        [self showTextView:VHKWindow message:msg];
    }
    [_layoutView room:room liveUser:toUserId micphoneStatusChanged:isClose byUser:byUserId];
}

#pragma mark - VCLiveLayoutViewDelegate
- (void)layoutView:(VCLiveLayoutView *)layoutView layoutEvent:(LayoutEvent)event renderView:(UIView *)renderView clickButton:(UIButton *)sender
{
    switch (event) { //"摄像头","麦克风","切换屏幕","切换摄像头"
        case LayoutEvent_VideoStauts:
        {
            [self videoStatusChanged:!sender.selected];
        }
            break;
        case LayoutEvent_Audio:
        {
            [self micBtnStatusChanged:!sender.isSelected];
        }
            break;
        case LayoutEvent_ScreenChange:
        {
            [_layoutView changeMainViewWithMaskView:renderView];
        }
            break;
        case LayoutEvent_VideoSwitch:
        {
            [_cameraView switchCamera];
        }
            break;
        default:
            break;
    }
}

#pragma mark - private
//麦克风按钮事件
- (void)micBtnStatusChanged:(BOOL)isClose {
    //麦克风操作
    VHCError *error = [_interactiveRoom closeMicphone:isClose];
    if (error) {
        [self showTextView:VHKWindow message:@"暂时无权操作"];
    }
    ///注意：不建议直接使用cameraView去开关摄像头麦克风，使用cameraView去操作仅仅是强制操作设备，不会和讲师端保持状态统一。
}
//摄像头按钮事件
- (void)videoStatusChanged:(BOOL)isClose {
    //摄像头操作
    VHCError *error = [_interactiveRoom closeVideo:isClose];
    if (error) {
        [self showTextView:VHKWindow message:@"暂时无权操作"];
    }
    ///注意：不建议直接使用cameraView去开关摄像头麦克风，使用cameraView去操作仅仅是强制操作设备，不会和讲师端保持状态统一。
}

#pragma mark - 出错回调
- (void)didError:(VHCError *)error {
    if ([self.delegate respondsToSelector:@selector(interactiveViewController:didError:)]) {
        [self.delegate interactiveViewController:self didError:error];
    }
}


#pragma mark - public

- (void)leave {
    //停止推流
    [_interactiveRoom stopPulish];
    //离开互动房间
    [_interactiveRoom leaveLiveRoom];
    //移除互动视频
    [_layoutView removAllViews];
}
- (void)setDocView:(nullable UIView *)docView {
    [_layoutView setDocView:docView];
}
//锁屏设置
- (void)lockedScreen:(BOOL)isLock {
    
}

#pragma mark - 懒加载
- (VHCInteractiveRoom *)interactiveRoom {
    if (!_interactiveRoom) {
        _interactiveRoom = [[VHCInteractiveRoom alloc] initWithPushCameraView:self.cameraView];
        _interactiveRoom.delegate = self;
        if (_type == MicroTypeOnlyVoice) {  //如果是语音上麦，关闭视频
            [_interactiveRoom closeVideo:YES];
        }
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
        _cameraView.scalingMode = VHRenderViewScalingModeAspectFill;
    }
    return _cameraView;
}
- (VCInteractiveModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[VCInteractiveModel alloc] init];
    }
    return _viewModel;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
