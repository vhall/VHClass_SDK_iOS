//
//  VHCVODPlayerController.h
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/8.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCModularBaseViewController.h"
#import <VHClassSDK/VHCVodPlayer.h>

@class VHCVODPlayerController;

NS_ASSUME_NONNULL_BEGIN

@protocol VHCVODPlayerControllerDelegate <NSObject>

@required
- (void)VodVc:(VHCVODPlayerController *)vc playError:(VHCError *)error;


@optional
//回放播放器当前播放时间回调
- (void)vodViewController:(VHCVODPlayerController *)vc currentTime:(NSTimeInterval)currentTime;
//全屏事件回调
- (void)vodViewController:(VHCVODPlayerController *)vc fullscreenButtonClick:(UIButton *)fullscreenBtn;

@end

///回放界面
@interface VHCVODPlayerController : VHCModularBaseViewController

@property (nonatomic, weak) id <VHCVODPlayerControllerDelegate> delegate;

@property (nonatomic, strong, readonly) VHCVodPlayer *vodPlayer;

- (void)play;

- (void)pause;

- (void)resume;

- (void)stopPlay;

- (void)destroyPlayer;

@end

NS_ASSUME_NONNULL_END
