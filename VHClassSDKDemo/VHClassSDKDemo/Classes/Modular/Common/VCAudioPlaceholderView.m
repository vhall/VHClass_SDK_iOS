//
//  VCAudioPlaceholderView.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/3/13.
//  Copyright © 2019 class. All rights reserved.
//

#import "VCAudioPlaceholderView.h"

@interface VCAudioPlaceholderView ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation VCAudioPlaceholderView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.image = [UIImage imageNamed:@"音频背景"];
        [self addSubview:self.imageView];
    }
    return self;
}


@end
