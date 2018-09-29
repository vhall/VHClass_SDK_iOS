//
//  DocContentView.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/25.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "DocContentView.h"

@interface DocContentView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *selfSuperView;
@property (nonatomic, assign) CGRect selfFrame;

@end

@implementation DocContentView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentMaskView.frame = self.bounds;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        ///views
        [self addSubview:self.contentMaskView];
        
        ///action
        [self.contentMaskView.toolBar.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)fullScreenBtnClick:(UIButton *)fullScreenBtn {
    
    fullScreenBtn.selected = !fullScreenBtn.selected;
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    self.contentMaskView.scrollView.zoomScale = 1.0;

    if (fullScreenBtn.selected) {
        
        self.selfSuperView = self.superview;
        self.selfFrame = self.frame;
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        
        [UIView animateWithDuration:duration animations:^{
            
            self.transform = CGAffineTransformMakeRotation(M_PI / 2);
            
        } completion:^(BOOL finished) {
            
        }];
        self.frame = keyWindow.bounds;
        [self setNeedsDisplay];
        [self layoutIfNeeded];
    }
    else {
        [UIView animateWithDuration:duration animations:^{
            
            self.transform = CGAffineTransformMakeRotation(0);
            
        } completion:^(BOOL finished) {
            
        }];
        self.frame = self.selfFrame;
        [self.selfSuperView addSubview:self];
    }
}

#pragma mark - lazy load
- (DocContentMaskView *)contentMaskView {
    if (!_contentMaskView) {
        _contentMaskView = [[DocContentMaskView alloc] initWithFrame:self.bounds];
    }
    return _contentMaskView;
}

@end
