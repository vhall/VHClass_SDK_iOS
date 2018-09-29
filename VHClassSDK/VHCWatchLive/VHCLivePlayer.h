//
//  VHCLivePlayer.h
//  VHCWatchLive
//
//  Created by vhall on 2018/9/4.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VHWatchHeader.h"
#import "VHCError.h"

@class VHCLivePlayer;


@protocol VHCLivePlayerDelegate <NSObject>

@optional
/**
 播放器状态变化回调
 
 @param player VHCLivePlayer实例对象
 @param state  变化后的状态
 */
- (void)player:(VHCLivePlayer *)player stateDidChanged:(VHPlayerState)state;
/**
 视频所支持的分辨率回调
 
 @param definitions 支持的分辨率数组
 */
- (void)player:(VHCLivePlayer *)player supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions;
/**
 当前视频分辨率改变回调
 
 视频调度后如果切换线路，分辨率有可能改变
 
 @param definition 改变之后的分辨率
 */
- (void)player:(VHCLivePlayer *)player definitionDidChanged:(VHDefinition)definition;
/**
 播放出错回调
 
 @param error 错误
 
 @see VHCError
 */
- (void)player:(VHCLivePlayer *)player playError:(VHCError *)error;
/**
 下载速度回调
 
 @param speed 下载速度
 */
- (void)player:(VHCLivePlayer *)player loadingWithSpeed:(NSString *)speed;

/**
 @brief      上麦回调
 @discussion 上麦方式有两种：1、用户申请上麦，讲师端收到申请，审批同意后会执行此回调；2、讲师直接邀请参会用户上麦，会执行此回调。
 @warning    收到此回调后用户方可以进行上麦推流。
 */
- (void)playerDidRecivedMicroInvitation:(VHCLivePlayer *)player;

/**
 *  观看直播，互动权限变更回调。
 *  @param player         VHCLivePlayer实例
 *  @param state          互动权限，即是否开启“举手”功能
 */
- (void)player:(VHCLivePlayer *)player interactivePermission:(VHInteractiveState)state;

@end

///微吼课堂看直播播放器类，此类定义了看直播以及设置直播属性等Api，实现直播观看，进入互动等功能。
@interface VHCLivePlayer : NSObject

/**
 代理指针
 */
@property (nonatomic, weak) id <VHCLivePlayerDelegate> delegate;
/**
 播放器view。需要将此视图添加到父视图上，显示视频区域的view。需要定义宽、高。
 */
@property (nonatomic, weak, readonly) UIView *playerView;
/**
 设置RTMP的缓冲时间,默认为6秒
 */
@property (nonatomic, assign) NSUInteger bufferTime;
/**
 播放器实际缓冲时间，实际延迟时间
 */
@property (nonatomic, assign, readonly) NSUInteger realBufferTime;
/**
 播放器状态，只读的
 @see VHWatchHeader
 */
@property (nonatomic, assign, readonly) VHPlayerState playerState;
/**
 视频分辨率
 通过set方法可以设置当前观看视频的分辨率
 @see VHWatchHeader
 */
@property (nonatomic, assign) VHDefinition definition;
/**
 播放器画面填充模式
 @see VHWatchHeader
 */
@property (nonatomic, assign) VHLiveViewContentMode contentModel;

/**
 开始播放
 */
- (void)play;
/**
 停止播放器
 播放器在 非Unknow 的其他状态下，任何时候都可以停止本次播放，停止后再次播放需要重新调用play方法重新播放。
 停止播放后，再次播放播放器状态将从VHPlayerStatePreparing开始。
 */
- (void)stopPlay;
/**
 销毁播放器
 */
- (void)destroyPlayer;

/**
 静音
 @param isMute YES:静音 NO:不静音
 */
- (void)setMute:(BOOL)isMute;

/**
 @brief 申请上麦，异步函数
 @discussion 异步函数，当error = nil时，申请成功。申请成功后，收到讲师端邀请，方可上麦互动。举手回调成功后主播有30秒的应答时间，30秒后可方再次申请。
 */
- (void)microApplySucess:(void(^)(VHCError *error))complete;

/**
 @brief 拒绝上麦
 @param type 1：直接拒绝上麦 0：30秒超时拒绝
 @discussion 异步函数，当error = nil时，成功。讲师端邀请上麦时候可以选择拒绝上麦，拒绝后将会给讲师端发送消息。
 */
- (void)refusOfMicroApplyWithType:(NSInteger)type complete:(void(^)(VHCError *error))complete;

@end
