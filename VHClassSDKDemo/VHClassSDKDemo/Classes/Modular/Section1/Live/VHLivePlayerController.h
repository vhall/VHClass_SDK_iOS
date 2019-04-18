//
//  VHLivePlayerController.h
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/16.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCModularBaseViewController.h"
#import "VHCLivePlayer.h"

@class VHLivePlayerController;

NS_ASSUME_NONNULL_BEGIN


@protocol VHLivePlayerControllerDelegate <NSObject>

@required
- (void)liveVc:(VHLivePlayerController *)vc playError:(VHCError *)error;


@optional

@end



///直播界面
@interface VHLivePlayerController : VHCModularBaseViewController

@property (nonatomic, strong, readonly) VHCLivePlayer *livePlayer;

@property (nonatomic, weak) id <VHLivePlayerControllerDelegate> delegate;

- (void)startPlay;

- (void)stopPlay;

- (void)destoryPlay;

- (NSInteger)getLiveRealBufferTime;

@end

NS_ASSUME_NONNULL_END
