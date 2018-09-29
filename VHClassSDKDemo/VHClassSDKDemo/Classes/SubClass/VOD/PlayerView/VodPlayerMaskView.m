//
//  VodPlayerMaskView.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/20.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VodPlayerMaskView.h"

@interface VodPlayerMaskView ()

@property (nonatomic, assign, readwrite) BottomToolBarState bottomToolBarState;

@end

@implementation VodPlayerMaskView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bottomToolBar.frame = CGRectMake(0, self.frame.size.height-kBottomToolBarHeight, self.frame.size.width, kBottomToolBarHeight);
    
    self.playBtn.frame = CGRectMake(8, 0, kBottomToolBarHeight, kBottomToolBarHeight);
    
    self.curTimeLabel.frame = CGRectMake(self.playBtn.right, 0, kTimeLabelWidth, kBottomToolBarHeight);
    
    self.fullScreenBtn.frame = CGRectMake(self.frame.size.width-kBottomToolBarHeight-8, 0, kBottomToolBarHeight, kBottomToolBarHeight);
    
    self.episodeBtn.frame = CGRectMake(self.fullScreenBtn.left-kBottomToolBarHeight, 0, kBottomToolBarHeight, kBottomToolBarHeight);
    
    self.totalTimeLabel.frame = CGRectMake(self.episodeBtn.left-kTimeLabelWidth, 0, kTimeLabelWidth, kBottomToolBarHeight);
    
    self.slider.frame = CGRectMake(self.curTimeLabel.right, 0, self.totalTimeLabel.left-self.curTimeLabel.right, kBottomToolBarHeight);
    
    self.indicatorView.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI {
    self.bottomToolBar = [[UIView alloc] init];
    self.bottomToolBar.backgroundColor = [UIColor clearColor];

    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"Stop"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateSelected];
    self.playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _curTimeLabel = [[UILabel alloc] init];
    _curTimeLabel.font = [UIFont systemFontOfSize:12.0];
    _curTimeLabel.textColor = [UIColor whiteColor];
    _curTimeLabel.text = @"00:00:00";
    
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"Rotation"] forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"Rotation"] forState:UIControlStateSelected];
    self.fullScreenBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.episodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.episodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.episodeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];

    _totalTimeLabel = [[UILabel alloc] init];
    _totalTimeLabel.font = [UIFont systemFontOfSize:12.0];
    _totalTimeLabel.textColor = [UIColor whiteColor];
    _totalTimeLabel.text = @"00:00:00";

    _slider = [[UISlider alloc] init];
    _slider.minimumValue = 0.0;
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    
    
    [self addSubview:self.bottomToolBar];
    [self.bottomToolBar addSubview:self.playBtn];
    [self.bottomToolBar addSubview:_curTimeLabel];
    [self.bottomToolBar addSubview:self.fullScreenBtn];
    [self.bottomToolBar addSubview:self.episodeBtn];
    [self.bottomToolBar addSubview:_totalTimeLabel];
    [self.bottomToolBar addSubview:_slider];
    
    [self addSubview:_indicatorView];
}
- (void)show
{
    if (_bottomToolBarState == BottomToolBarStateAnimating){
        return;
    }
    _bottomToolBarState = BottomToolBarStateAnimating;

    [UIView animateWithDuration:.5 animations:^{
        
        CGRect frame = self.frame;
        frame.origin.y = self.superview.height-self.frame.size.height;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        self.bottomToolBarState = BottomToolBarStateShow;
    }];
}
- (void)hidden
{
    if (_bottomToolBarState == BottomToolBarStateAnimating) {
        return;
    }
    _bottomToolBarState = BottomToolBarStateAnimating;
    
    [UIView animateWithDuration:.5 animations:^{
        
        CGRect frame = self.frame;
        frame.origin.y = self.superview.height;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        self.bottomToolBarState = BottomToolBarStateHidden;
    }];
}

@end
