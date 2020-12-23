//
//  VHCVodPlayer.h
//  VHCLive
//
//  Created by vhall on 2019/1/29.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VHCLiveHeader.h"
#import "VHCError.h"

@class VHCVodPlayer;

NS_ASSUME_NONNULL_BEGIN

@protocol VHCVodPlayerDelegate <NSObject>

@optional
/**
 播放器状态变化回调
 
 @param player VHCVodPlayer实例对象
 @param state  变化后的状态
 */
- (void)player:(VHCVodPlayer *)player stateDidChanged:(VHPlayerState)state;
/**
 视频所支持的分辨率
 
 @param definitions 支持的分辨率数组
 */
- (void)player:(VHCVodPlayer *)player supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions curDefinition:(VHCDefinition)definition;
/**
 播放出错回调
 
 @param error 错误
 
 @see LiveStatus
 */
- (void)player:(VHCVodPlayer *)player playError:(VHCError *)error;
/**
 下载速度回调
 
 @param speed 错误
 */
- (void)player:(VHCVodPlayer *)player loadingWithSpeed:(NSString *)speed;

/**
 当前播放时间回调
 */
- (void)player:(VHCVodPlayer*)player playTime:(NSTimeInterval)currentTime;

@end


@interface VHCVodPlayer : NSObject
/**
 代理指针
 */
@property (nonatomic, weak) id <VHCVodPlayerDelegate> delegate;
/**
 播放器view。需要将此视图添加到父视图上，显示视频区域的view。需要定义宽、高。
 */
@property (nonatomic, weak, readonly) UIView *playerView;
/**
 播放器状态，只读的
 */
@property (nonatomic, assign, readonly) VHPlayerState playerState;
/**
 视频分辨率
 
 通过set方法可以设置当前观看视频的分辨率
 */
@property (nonatomic, assign) VHCDefinition definition;
/**
 视频View的缩放比例 默认是自适应模式
 */
@property (nonatomic, assign) VHLiveViewContentMode contentModel;
/**
 * 点播视频总时长
 */
@property (nonatomic, readonly) NSTimeInterval          duration;
/**
 * 点播可播放时长
 */
@property (nonatomic, readonly) NSTimeInterval          playableDuration;
/**
 * 点播当前播放时间
 */
@property (nonatomic, assign)   NSTimeInterval          currentTime;
/**
 * 点播倍速播放速率
 * 0.50, 0.67, 0.80, 1.0, 1.25, 1.50, and 2.0
 */
@property (nonatomic) float rate;


/**
 * 开始播放
 */
- (void)play;
/**
 * 直接使用回放id播放的业务,例如插播.
 */
- (void)showVideoWithRecordId:(NSString *)record;

/**
 * 播放暂停
 */
- (void)pause;

/**
 * 重新播放
 */
- (void)resume;

/**
 * 停止播放
 */
- (void)stopPlay;

/**
 * 销毁播放
 */
- (void)destroyPlayer;

/*
 seek 播放跳转到音视频流某个时间
 * time: 流时间，单位为秒
 */
- (BOOL)seek:(float)time;
/**
 静音
 @param isMute YES:静音 NO:不静音
 */
- (void)setMute:(BOOL)isMute;


@end

NS_ASSUME_NONNULL_END
