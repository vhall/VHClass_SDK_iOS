//
//  VHCVodPlayer.h
//  VHCVodPlayer
//
//  Created by vhall on 2018/9/19.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VHVodHeader.h"
#import "VHCError.h"

@class VHCVodPlayer;

@protocol VHCVodPlayerDelegate <NSObject>

@optional
/**
 @brief 播放器状态变化回调
 
 @param player VHCLivePlayer实例对象
 @param state  变化后的状态
 */
- (void)player:(VHCVodPlayer *)player stateDidChanged:(VHPlayerState)state;
/**
 @brief 播放出错回调
 
 @param error 错误
 */
- (void)player:(VHCVodPlayer *)player playError:(VHCError *)error;
/**
 @brief 视频所支持的分辨率和当前视频分辨率回调
 
 @param definitions 支持的分辨率数组
 */
- (void)player:(VHCVodPlayer *)player supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions;
/**
 @brief 当前视频分辨率改变回调
 
 视频调度后如果切换线路，分辨率有可能改变
 
 @param definition 改变之后的分辨率
 */
- (void)player:(VHCVodPlayer *)player definitionDidChanged:(VHDefinition)definition;
/**
 @brief 播放进度回调
 */
- (void)player:(VHCVodPlayer *)player currentTime:(NSTimeInterval)currentTime;
/**
 @brief 开始缓冲回调
 */
- (void)player:(VHCVodPlayer *)player bufferStart:(id)info;
/**
 @brief 开始播放回调
 */
- (void)player:(VHCVodPlayer *)player bufferStop:(id)info;
/**
 @brief 播放完成
 @discussion 播放完后播放器会先回调此方法，然后自动stopPlay。
 */
- (void)playerPlayComplete:(VHCVodPlayer *)player;

@end

@interface VHCVodPlayer : NSObject

/**
 @brief 初始化
 @warning playerView 播放view,需传入，否则无法使用看回放播放器。
 */
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPlayerView:(UIView *)playerView;
+ (instancetype)playerWithPlayerView:(UIView *)playerView;

/**
 @brief 代理指针
 */
@property (nonatomic, weak) id <VHCVodPlayerDelegate> delegate;
/**
 @brief 播放器状态，只读的
 @see VHVodHeader
 */
@property (nonatomic, assign, readonly) VHPlayerState playerState;
/**
 @brief 当前播放的回放视频时长，只读的
 @warning 缓冲结束后才可以获取到该值，即在开始播放以及之后。
 */
@property (nonatomic, assign, readonly) NSTimeInterval duration;
/**
 @brief 当前时长，只读的
 @warning 默认为0
 */
@property (nonatomic, assign, readonly) NSTimeInterval curTime;
/**
 @brief 视频分辨率
 通过set方法可以设置当前观看视频的分辨率
 @see VHVodHeader
 */
@property (nonatomic, assign) VHDefinition definition;
/**
 @brief 播放器画面填充模式
 @see VHVodHeader
 */
@property (nonatomic, assign) VHLiveViewContentMode contentModel;

/**
 @brief 播放器播放方法
 */
- (void)play;
/**
 @brief 暂停播放
 
 当播放器处于 playing 的状态时调用该方法可以暂停播放器
 */
- (void)pause;
/**
 @brief 恢复播放
 
 当播放器处于暂停状态时，调用此方法恢复播放。
 */
- (void)resume;
/**
 @brief 播放跳转到音视频流某个时间
 @param time 单位：秒
 */
- (void)seek:(float)time;
/**
 @brief 停止播放器
 
 播放器在 非Unknow 的其他状态下，任何时候都可以停止本次播放，停止后再次播放需要重新调用- (void)play方法重新播放。
 
 停止播放后，再次播放播放器状态将从VHPlayerStatePreparing开始。
 */
- (void)stopPlay;
/**
 @brief 销毁播放器
 */
- (void)destroyPlayer;

@end
