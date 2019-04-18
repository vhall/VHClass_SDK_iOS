//
//  VHCInteractiveRoom.h
//  VHInteractive
//
//  Created by vhall on 2018/4/18.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//
//  进入房间-->进入房间结果回调
//  |
//  推流-->推流结果回调
//  |
//  上麦-->上麦结果回调
//

#import <Foundation/Foundation.h>
#import "VHCError.h"

@protocol   VHCInteractiveRoomDelegate;
@class      VHRenderView;

// 用户与互动直播间的连接状态
typedef NS_ENUM(NSInteger, VHCInteractiveRoomConnectedStatus) {
    /** 未知，初始化直播间时默认状态*/
    VHCInteractiveRoomConnectedStatusUnkonw,
    /** 连接中，进入房间后开始连接房间，进入房间开始推流状态*/
    VHCInteractiveRoomConnectedStatusConnecting,
    /** 已连接，互动中状态*/
    VHCInteractiveRoomConnectedStatusConnected,
    /** 失去连接，已下麦状态，被主播下麦、自己下麦、网络状态差失去连接等*/
    VHCInteractiveRoomConnectedStatusDisConnected,
};

// 设备
typedef NS_ENUM(NSInteger,VHCDeviceType) {
    VHCDeviceTypeMicphone,
    VHCDeviceTypeCamera,
};

///微吼课堂互动直播间实体类，此类定义了进入互动、离开互动、推流等Api，实现用户在线互动功能。
@interface VHCInteractiveRoom : NSObject

/**
 @brief 构造方法
 @warning cameraView 推流用的cameraView，即VHRenderView的实例对象，需用户自己手动创建。初始化时即绑定推流所用的cameraView，推流时只需调用- (void)startPublish方法即可。
 */
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPushCameraView:(nonnull VHRenderView *)cameraView;

@property (nonatomic, weak) id <VHCInteractiveRoomDelegate> delegate;

// 互动直播间房间id
@property (nonatomic, copy, readonly) NSString        *roomId;

// 用户与互动直播间当前的连接状态
@property (nonatomic, assign, readonly) VHCInteractiveRoomConnectedStatus connectStatus;

// 当前推流 cameraView 只在推流过程中存在
@property (nonatomic, weak, readonly) VHRenderView    *cameraView;

// 所有订阅的视频view key为streamId
@property (nonatomic, strong, readonly) NSDictionary    *renderViewsById;

// 房间中所有流id列表
@property (nonatomic, strong, readonly) NSArray         *streams;

// 当前自己是否关闭了麦克风
@property (nonatomic, assign) BOOL isAudioClosedByOwn;

// 当前是否被讲师关闭了麦克风，讲师关闭了自己的麦克风或全体静音时此值为YES
@property (nonatomic, assign) BOOL isAudioClosedByHost;

/**
 @brief 进入互动直播间
 @discussion 结果会在- (void)roomdidEnteredWithRoomMetaDataerror:中回调，如果进入成功，可以开始推流上麦。
 */
- (void)enterLiveRoom;

/**
 @brief 推流上麦
 @discussion 调用此方法会有两个回调，先回调推流是否成功：- (void)room:didPublishWithCameraView:error:，然后回调上麦是否成功- (void)room:microUpWithError:
 */
- (BOOL)startPublish;

/**
 @brief 停止推流
 @discussion 下麦的时候需要停止推流。
 */
- (void)stopPulish;

/**
 @brief 离开互动直播间，即下麦
 @discussion 停止推流后离开互动直播间需调用此方法。
 */
- (void)leaveLiveRoom;

/**
 @brief 订阅他人视频数据 即拉取某个连麦人的流 isAutoSubscribe为YES 时收到流会自动订阅
 @param streamId 他人视频 streamId
 @discussion 结果会在- (void)room:didAddAttendView:中回调
 */
- (void)subscribe:(NSString *)streamId;

/**
 @brief 取消订阅他人视频数据 不再拉取某个连麦人的流
 @param streamId 他人视频 streamId
 @discussion 结果会在- (void)room:didRemovedAttendView:中回调
 */
- (void)unsubscribe:(NSString *)streamId;

/**
 @brief 使用streamId 查询VHRenderView，包括未订阅的流
 @param streamId 他人视频 streamId
 @discussion 一般用于查询未订阅流的属性，订阅流可以直接- (void)room:didAddAttendView:中读取
 */
- (VHRenderView*)queryViewWithStreamId:(NSString *)streamId;

/**
 @brief 是否开启扬声器输出音频
 */
- (void)setSpeakerphoneOn:(BOOL)on;

/**
 @brief 设置麦克风开关
 @warning 推流后设置才可生效
 @return VHCError 设置失败 错误码：VHCErrorType_NoAuthority无权操作； VHCErrorType_NotEnterClass：未进入课堂或已掉线；VHCErrorType_InVaild：设置无效，未推流前设置都是无效的。
 */
- (VHCError *)closeMicphone:(BOOL)isClose;
/**
 @brief 设置摄像头开关
 @warning 推流后设置才可生效
 @return VHCError 设置失败 错误码：VHCErrorType_NoAuthority无权操作； VHCErrorType_NotEnterClass：未进入课堂或已掉线；VHCErrorType_InVaild：设置无效，未推流前设置都是无效的。
 */
- (VHCError *)closeVideo:(BOOL)isClose;

@end


/// 互动房间代理，此代理定义了进入互动房间结构回调、推流结果回调、上麦结果回调等与互动房间有关的回调方法。在回调中可以处理您关于互动的相关操作。
@protocol VHCInteractiveRoomDelegate <NSObject>

@optional

///----------------------------
/// @name 互动直播间生命周期相关回调
///----------------------------

/**
 @brief 进入互动直播间结果回调
 @param data   互动直播间数据
 @param error  错误
 @discussion   当error为nil时候，表示已进入互动直播间；error不为空时，表示进入失败，失败原因描述：error.errorDescription。成功进入互动直播间成功就可以开始推流上麦了。
 */
- (void)room:(VHCInteractiveRoom *)room didEnteredWithRoomMetaData:(NSDictionary *)data error:(VHCError *)error;

/**
 @brief 推流结果回调
 @param cameraView 推流的cameraView
 @param error      推流错误，当error不为空时表示推流失败
 @discussion 推流成功之后，会收到上麦结果的回调。
 */
- (void)room:(VHCInteractiveRoom *)room didPublishWithCameraView:(VHRenderView *)cameraView error:(VHCError *)error;

/**
 @brief 停止推流回调
 @param cameraView 推流的cameraView
 @discussion 自己调用- unpublish停止推流，会回调此方法;被讲师下麦，会停止推流，回调此方法；推流出错,停止推流，会回调此方法。
 */
- (void)room:(VHCInteractiveRoom *)room didUnpublish:(VHRenderView *)cameraView;

/**
 @brief 某用户被讲师下麦回调
 @param byUserId 操作者户参会id，一般的自己被讲师下麦，此id为讲师参会id
 @param toUserId 被操作者户参会id，如果是自己的参会id，则表示自己被讲师下麦。
 */
- (void)room:(VHCInteractiveRoom *)room leaveRoomByUserId:(NSString *)byUserId toUser:(NSString *)toUserId;

/**
 @brief 某用户上麦结果回调
 @param joinId 上麦用户的参会id
 @param error error为nil时上麦成功
 @param info 其他信息
 @discussion  当error为nil时，表示上麦成功。
 */
- (void)room:(VHCInteractiveRoom *)room microUpWithJoinId:(NSString *)joinId attributes:(NSDictionary *)info error:(VHCError *)error;
/**
 @brief 某用户下麦回调
 @param info 其他信息
 @param joinId 下麦用户的参会id
 */
- (void)room:(VHCInteractiveRoom *)room microDownWithJoinId:(NSString *)joinId attributes:(NSDictionary *)info;

/**
 @brief 用户与直播间的连接状态回调
 @param connectedStatus 用户与直播间的连接状态 @see VHCInteractiveRoomConnectedStatus
 @discussion 失去连接则表示该用户已经在主播端下麦，建议在此回调中处理下麦后的业务；当状态为VHCInteractiveRoomConnectedStatusConnected时，表示已成功上麦；当状态为VHCInteractiveRoomConnectedStatusDisConnected时，表示自己已下麦。
 */
- (void)room:(VHCInteractiveRoom *)room connectedStatusChanged:(VHCInteractiveRoomConnectedStatus)connectedStatus;
//
/////--------------------
///// @name 互动相关事件回调
/////--------------------

/**
 @brief 新加入一路流（有成员进入互动房间，即有人上麦)
 @discussion 流id：attendView.streamId；上麦用户参会id：attendView.userId。
 */
- (void)room:(VHCInteractiveRoom *)room didAddAttendView:(VHRenderView *)attendView;

/**
 @brief 减少一路流（有成员离开房间，即有人下麦）
 @discussion 流id：attendView.streamId；上麦用户参会id：attendView.userId。
 */
- (void)room:(VHCInteractiveRoom *)room didRemovedAttendView:(VHRenderView *)attendView;

/**
 @brief 关闭画面回调
 @param isClose YES:关闭，NO：打开
 @discussion byUserId操作者参会id，toUserId被操作者参会id。
 @warning 自己操作自己的设备byUserId和toUserId都是自己的参会id。
 */
- (void)room:(VHCInteractiveRoom *)room screenClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId;

/**
 @brief 关闭麦克风回调，即静音操作回调
 @param isClose YES:关闭，NO：打开
 @discussion byUserId操作者参会id，toUserId被操作者参会id。
 @warning 自己操作自己的设备byUserId和toUserId都是自己的参会id。当toUserId == nil时候，表示全体静音。全体禁音针对的群体是除讲师外的所有学员，因此将时端开启全体禁音时，讲师并不会被禁音，除非讲师自己禁音。
 */
- (void)room:(VHCInteractiveRoom *)room microphoneClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId;

@end
