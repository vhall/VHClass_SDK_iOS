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


///微吼课堂互动直播间实体类，此类定义了进入互动、离开互动、推流等Api，实现用户在线互动功能。
@interface VHCInteractiveRoom : NSObject

@property (nonatomic, weak) id <VHCInteractiveRoomDelegate> delegate;

// 互动直播间房间id
@property (nonatomic, copy, readonly) NSString        *roomId;

// 用户与互动直播间当前的连接状态
@property (nonatomic, assign, readonly) VHCInteractiveRoomConnectedStatus connectStatus;

// 当前推流 cameraView 只在推流过程中存在
@property (nonatomic, weak, readonly) VHRenderView    *cameraView;

// 所有其他进入本房间的视频view
@property (nonatomic, strong, readonly) NSDictionary    *renderViewsById;

// 房间中所有可以观看的流id列表
 @property (nonatomic, strong, readonly) NSArray         *streams;

/**
 @brief 进入互动直播间
 @discussion 结果会在- (void)roomdidEnteredWithRoomMetaDataerror:中回调，如果进入成功，可以开始推流上麦。
 */
- (void)enterLiveRoom;

/**
 @brief 推流上麦
 @param cameraView 推流的摄像机view，不可为空。
 @discussion 调用此方法会有两个回调，先回调推流是否成功：- (void)room:didPublishWithCameraView:error:，然后回调上麦是否成功- (void)room:microUpWithError:
 */
- (BOOL)publishWithCameraView:(nonnull VHRenderView *)cameraView;

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
 @brief 接收他人视频数据
 @param streamId 他人视频 streamId
 */
- (BOOL)addVideo:(NSString *)streamId;

/**
 @brief 不接收他人视频数据
 @param streamId 他人视频 streamId
 */
- (BOOL)removeVideo:(NSString *)streamId;

/**
 @brief 支持的推流视频分辨率
 */
+ (NSArray<NSString *> *)availableVideoResolutions;

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
 @brief 某用户上麦结果回调
 @param joinId 上麦用户的参会id
 @param error error为nil时上麦成功
 @discussion  当error为nil时，表示上麦成功。
 */
- (void)room:(VHCInteractiveRoom *)room microUpWithJoinId:(NSString *)joinId error:(VHCError *)error;

/**
 @brief 某用户下麦成功回调
 @param byUserId 操作者户参会id，一般的自己被讲师下麦，此id为讲师参会id；自己主动下麦，此id为自己参会id
 @param toUserId 操作者户参会id，如果是自己的参会id，则表示自己被讲师下麦。
 @discussion 自己被讲师下麦，会自动停止推流，并自动离开房间。停止推流和房间连接状态的回调也会执行，如果自己被主播下麦，建议再次处理自己的业务逻辑，退出当前直播间。
 */
- (void)room:(VHCInteractiveRoom *)room leaveRoomByUserId:(NSString *)byUserId toUser:(NSString *)toUserId;


/**
 @brief 用户与直播间的连接状态回调
 @param connectedStatus 用户与直播间的连接状态 @see VHCInteractiveRoomConnectedStatus
 @discussion 失去连接则表示该用户已经在主播端下麦，建议在此回调中处理下麦后的业务；当状态为VHCInteractiveRoomConnectedStatusConnected时，表示已成功上麦；当状态为VHCInteractiveRoomConnectedStatusDisConnected时，表示自己已下麦。
 */
- (void)room:(VHCInteractiveRoom *)room connectedStatusChanged:(VHCInteractiveRoomConnectedStatus)connectedStatus;

///--------------------
/// @name 互动相关事件回调
///--------------------

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
 @warning 自己操作自己的设备byUserId和toUserId都是自己的参会id。当toUserId == nil时候，表示全体静音
 */
- (void)room:(VHCInteractiveRoom *)room microphoneClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId;

@end
