//
//  VHVodHeader.h
//  VHVodPlayerDemo
//
//  Created by vhall on 2018/9/18.
//  Copyright © 2018年 vhall. All rights reserved.
//

#ifndef VHVodHeader_h
#define VHVodHeader_h

// 视频分辨率
typedef NS_ENUM(NSInteger,VHDefinition) {
    VHDefinitionDefault            = 0,    //默认原画
    VHDefinitionUHD                = 1,    //超高清(目前不支持)
    VHDefinitionHD                 = 2,    //高清
    VHDefinitionSD                 = 3,    //标清
    VHDefinitionAu                 = 4,    //音频流
};
// 播放器状态
typedef NS_ENUM(NSInteger,VHPlayerState) {
    //初始化时指定的状态，播放器初始化
    VHPlayerStateUnknow,
    //播放器正在准备，播放开始调度
    VHPlayerStatePreparing,
    //播放器正在连接，准备开始播放
    VHPlayerStateConnect,
    //播放器准备完成，调度结束
    VHPlayerStateReady,
    //播放器正在加载，正在缓冲
    VHPlayerStateLoading,
    //播放器缓冲结束，将要播放
    VHPlayerStateWillPlay,
    //播放器正在播放
    VHPlayerStatePlaying,
    //暂停，当播放器处于播放状态时，调用暂停方法，暂停视频
    VHPlayerStatePause,
    //停止，调用stopPlay方法停止本次播放，停止后需再次调用播放方法进行播放
    VHPlayerStateStop,
    //播放出错
    VHPlayerStateError,
    //本次播放完
    VHPlayerStateComplete,
};
// 画面填充模式
typedef NS_ENUM(NSInteger, VHLiveViewContentMode) {
    // 等比例填充，直到一个维度到达区域边界
    VHLiveViewContentModeAspectFit,
    // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
    VHLiveViewContentModeAspectFill,
    // 非等比例填充。两个维度完全填充至整个视图区域
    VHLiveViewContentModeFill
};

#endif /* VHVodHeader_h */
