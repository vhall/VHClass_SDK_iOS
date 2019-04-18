//
//  LiveViewController.h
//  VHClassSDKDemo
//
//  Created by vhall on 2019/3/14.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCModularBaseViewController.h"

@class LiveViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol LiveViewControllerDelegate <NSObject>

@optional

//上麦回调
- (void)liveViewController:(LiveViewController *)vc willEnterInteractive:(BOOL)isVoiceOnly;
//分辨率回调
- (void)liveViewController:(LiveViewController *)vc isSupportAudio:(BOOL)support isAudioOnly:(BOOL)audio;

@end


@interface LiveViewController : VHCModularBaseViewController

@property (nonatomic, weak) id <LiveViewControllerDelegate> delegate;

//销毁播放器
- (void)destoryPlayer;

//举手
- (void)appplyHand;

//开启音频模式
- (void)audioLiveOnly:(BOOL)isAudio;

@end

NS_ASSUME_NONNULL_END
