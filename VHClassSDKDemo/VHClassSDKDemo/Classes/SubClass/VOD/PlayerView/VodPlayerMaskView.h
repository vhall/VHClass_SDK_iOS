//
//  VodPlayerMaskView.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/20.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBottomToolBarHeight 40
#define kTimeLabelWidth 60

//default is show
typedef NS_ENUM(NSUInteger,BottomToolBarState) {
    BottomToolBarStateShow,
    BottomToolBarStateAnimating,
    BottomToolBarStateHidden,
};

@interface VodPlayerMaskView : UIView

///bottom tool bar
@property (nonatomic, strong) UIView *bottomToolBar;
@property (nonatomic, assign, readonly) BottomToolBarState bottomToolBarState;

///subviews of tool bar
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *curTimeLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIButton *episodeBtn;

///indicator
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)show;
- (void)hidden;

@end
