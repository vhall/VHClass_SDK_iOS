//
//  VHWatchHeader.h
//  VHWatchLiveDemo
//
//  Created by vhall on 2018/8/23.
//  Copyright © 2018年 Morris. All rights reserved.
//
//  看直播、看回放、播放调度使用此文件
//


#ifndef VHWatchHeader_h
#define VHWatchHeader_h

// 视频分辨率
typedef NS_ENUM(NSInteger,VHCDefinition) {
    VHCDefinitionDefault            = 0,    //默认原画
    VHCDefinitionUHD                = 1,    //超高清(目前不支持)
    VHCDefinitionHD                 = 2,    //高清
    VHCDefinitionSD                 = 3,    //标清
    VHCDefinitionAu                 = 4,    //纯音频
};
// 播放器状态
typedef NS_ENUM(NSInteger,VHPlayerState) {
    //初始化时指定的状态，播放器初始化
    VHPlayerStateUnknow  = 0,
    //播放器正在加载，正在缓冲
    VHPlayerStateLoading = 1,
    //播放器正在播放
    VHPlayerStatePlaying = 2,
    //暂停，当播放器处于播放状态时，调用暂停方法，暂停视频
    VHPlayerStatePause   = 3 ,
    //停止，调用stopPlay方法停止本次播放，停止后需再次调用播放方法进行播放
    VHPlayerStateStop    = 4,
    //本次播放完
    VHPlayerStateComplete = 5,
};
// 画面填充模式
typedef NS_ENUM(NSInteger, VHLiveViewContentMode) {
    //无(无效)
    VHLiveContentModeFill,
    //将图像等比例缩放，适配最长边，缩放后的宽和高都不会超过显示区域，居中显示，画面可能会留有黑边
    VHLiveViewContentModeAspectFit,
    //将图像等比例铺满整个屏幕，多余部分裁剪掉，此模式下画面不会留黑边，但可能因为部分区域被裁剪而显示不全
    VHLiveViewContentModeAspectFill,
};
// 直播类型（流类型）
typedef NS_ENUM(NSInteger,VHWatchType){
    VHWatchTypeNone = 0,        //未知
    VHWatchTypeVideoAndAudio,   //音视频
    VHWatchTypeOnlyVideo,       //纯视频
    VHWatchTypeOnlyAudio,       //纯音频
};
// 视频模式
typedef NS_ENUM(int,VHVideoModel){
    VHVideoModelOrigin = 1,  //普通视图的渲染
    VHVideoModelVR,          //VR视图的渲染
};
/**
 *  活动互动状态
 */
typedef NS_ENUM(NSInteger,VHInteractiveState) {
    VHInteractiveStateWithOut           = 0,   //当前不允许“举手”
    VHInteractiveStateHave              = 1,   //当前允许“举手”
};




#endif /* VHWatchHeader_h */
