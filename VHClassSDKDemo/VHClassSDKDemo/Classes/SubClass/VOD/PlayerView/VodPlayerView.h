//
//  VodPlayerView.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/19.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VodPlayerView;

@protocol VodPlayerViewDelegate <NSObject>

//play and puss button action
- (void)playerView:(VodPlayerView *)view playButtonClick:(UIButton *)playBtn;

//slider
- (void)playerView:(VodPlayerView *)view slideTouchBegin:(UISlider *)slider;
- (void)playerView:(VodPlayerView *)view slideTouchEnd:(UISlider *)slider;
- (void)playerView:(VodPlayerView *)view slideValueChanged:(UISlider *)slider;

//episode button action
- (void)playerView:(VodPlayerView *)view episodeButtonClick:(UIButton *)episodeBtn;

//full screen button action
- (void)playerView:(VodPlayerView *)view fullscreenButtonClick:(UIButton *)fullscreenBtn;

@end


///player view of AVPlayerController
@interface VodPlayerView : UIView

@property (nonatomic, weak) id <VodPlayerViewDelegate> delegate;

@property (nonatomic, copy) NSString *episodeBtnTitle;

//slider
@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value

//loading
- (void)startIndicatorAnimating;
- (void)stopIndicatorAnimating;

@end
