//
//  DocToolBar.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/21.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "DocToolBar.h"

@implementation DocToolBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.fullScreenBtn.frame = CGRectMake(self.frame.size.width-16-66, self.frame.size.height-16-28, 66, 28);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initViews];
    }
    return self;
}
- (void)initViews
{
    //全屏按钮
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"fullScreen_custom"] forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"fullScreen_selected"] forState:UIControlStateSelected];
    self.fullScreenBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.fullScreenBtn];
}

@end
