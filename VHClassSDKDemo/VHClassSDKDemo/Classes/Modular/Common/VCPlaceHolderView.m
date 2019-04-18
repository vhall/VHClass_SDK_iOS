//
//  VCPlaceHolderView.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/26.
//  Copyright © 2019 class. All rights reserved.
//

#import "VCPlaceHolderView.h"

@implementation VCPlaceHolderView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIImage *image = self.imageView.image;
    
    self.imageView.center = CGPointMake(self.center.x, self.center.y-(20+13)*0.5);
    self.imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    
    self.label.frame = CGRectMake(0, 0, self.width, 20);
    self.label.top = self.imageView.bottom+13;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *placeHoldImageview = [[UIImageView alloc]init];
        placeHoldImageview.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:placeHoldImageview];
        self.imageView = placeHoldImageview;
        
        UILabel *label = [[UILabel alloc]init];
        label.textColor = AppBaseColorFont2;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        [self addSubview:label];
        self.label = label;
    }
    return self;
}


@end
