//
//  EpisodeView.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/20.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "EpisodeView.h"

@implementation EpisodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return self;
}
- (void)resetWithTitles:(NSArray *)titles
{
    [self removeAllSubviews];
    
    CGFloat originY = self.height - titles.count*(40+10);
    
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = 101010+i;
        [self addSubview:button];
        
        button.frame = CGRectMake(16, originY+i*40+10, self.width-32, 40);
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.SelectedIndex) {
        self.SelectedIndex(sender.tag-101010);
    }
}

- (void)show {
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.x = self.superview.width-self.width;
        self.frame = frame;
    } completion:nil];
}
- (void)hidden {
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.x = self.superview.width;
        self.frame = frame;
    } completion:nil];
}


@end
