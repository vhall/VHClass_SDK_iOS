//
//  VodPlayerView.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/19.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VodPlayerView.h"
#import "VodPlayerMaskView.h"

@interface VodPlayerView ()

@property (nonatomic, strong) VodPlayerMaskView *playerMaskView;

@property (nonatomic, weak) UIView *selfSuperView;
@property (nonatomic, assign) CGRect customFrame;

@end

@implementation VodPlayerView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playerMaskView.frame = self.bounds;
}

- (void)dealloc {
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        ///subViews
        [self addSubview:self.playerMaskView];
        
        ///Action
        [self.playerMaskView.playBtn addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.playerMaskView.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.playerMaskView.episodeBtn addTarget:self action:@selector(episodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.playerMaskView.slider addTarget:self action:@selector(slideTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [self.playerMaskView.slider addTarget:self action:@selector(slideTouchEnd:) forControlEvents:UIControlEventTouchUpOutside];
        [self.playerMaskView.slider addTarget:self action:@selector(slideTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        [self.playerMaskView.slider addTarget:self action:@selector(slideTouchEnd:) forControlEvents:UIControlEventTouchCancel];
        [self.playerMaskView.slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

#pragma mark - action
- (void)playButtonClick:(UIButton *)playBtn
{
    if ([self.delegate respondsToSelector:@selector(playerView:playButtonClick:)])
    {
        [self.delegate playerView:self playButtonClick:playBtn];
    }
}
- (void)slideTouchBegin:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(playerView:slideTouchBegin:)])
    {
        [self.delegate playerView:self slideTouchBegin:slider];
    }
}
- (void)slideTouchEnd:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(playerView:slideTouchEnd:)])
    {
        [self.delegate playerView:self slideTouchEnd:slider];
    }
}
- (void)slideValueChanged:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(playerView:slideValueChanged:)])
    {
        [self.delegate playerView:self slideValueChanged:slider];
    }
}
- (void)episodeButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(playerView:episodeButtonClick:)])
    {
        [self.delegate playerView:self episodeButtonClick:sender];
    }
}
- (void)tapGesAction:(UITapGestureRecognizer *)tapGes
{
    
}
- (void)fullScreenBtnClick:(UIButton *)sender
{
    //sender.selected = !sender.selected;

    //sender.selected ? [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft] : [self fullScreenWithDirection:UIInterfaceOrientationPortrait];

    if ([self.delegate respondsToSelector:@selector(playerView:fullscreenButtonClick:)])
    {
        [self.delegate playerView:self fullscreenButtonClick:sender];
    }
}

#pragma mark - public
- (void)setValue:(float)value {
    _value = value;
    self.playerMaskView.slider.value = _value;
    self.playerMaskView.curTimeLabel.text = [self timeFormat:_value];
}
- (void)setMinimumValue:(float)minimumValue {
    _minimumValue = minimumValue;
    self.playerMaskView.slider.minimumValue = _minimumValue;
}
- (void)setMaximumValue:(float)maximumValue {
    _maximumValue = maximumValue;
    self.playerMaskView.slider.maximumValue = _maximumValue;
    self.playerMaskView.totalTimeLabel.text = [self timeFormat:_maximumValue];
}
- (void)setEpisodeBtnTitle:(NSString *)episodeBtnTitle
{
    [self.playerMaskView.episodeBtn setTitle:episodeBtnTitle forState:UIControlStateNormal];
}
- (void)startIndicatorAnimating
{
    [self.playerMaskView.indicatorView startAnimating];
}
- (void)stopIndicatorAnimating
{
    [self.playerMaskView.indicatorView stopAnimating];
}

#pragma mark - private
//full screen
- (void)fullScreenWithDirection:(UIInterfaceOrientation)direction
{
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//    if (direction == UIInterfaceOrientationLandscapeLeft)
//    {
//        _selfSuperView = self.superview;
//        _customFrame = self.frame;
//
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        [keyWindow addSubview:self];
//
//
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
//        [UIView animateWithDuration:duration animations:^{
//            self.transform = CGAffineTransformMakeRotation(M_PI / 2);
//        }completion:^(BOOL finished) {
//
//        }];
//        self.frame = [UIScreen mainScreen].bounds;
//        [self setNeedsDisplay];
//        [self layoutIfNeeded];
//    }
//    else if (direction == UIInterfaceOrientationPortrait)
//    {
//        //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
//        [UIView animateWithDuration:duration animations:^{
//            self.transform = CGAffineTransformMakeRotation(0);
//        }completion:^(BOOL finished) {
//
//        }];
//        self.frame = _customFrame;
//        [_selfSuperView addSubview:self];
//    }
}
- (NSString *)timeFormat:(float)value {
    int secend = ceil(value);
    return [NSString stringWithFormat:@"%02d:%02d:%02d",secend/3600,(secend%3600)/60,secend%60];
}

#pragma mark - lazy load
- (VodPlayerMaskView *)playerMaskView {
    if (!_playerMaskView) {
        _playerMaskView = [[VodPlayerMaskView alloc] init];
    }
    return _playerMaskView;
}

#pragma mark - get
- (UIButton *)playBtn {
    return self.playerMaskView.playBtn;
}


@end
