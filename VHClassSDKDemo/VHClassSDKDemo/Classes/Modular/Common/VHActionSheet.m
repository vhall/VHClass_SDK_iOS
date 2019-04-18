//
//  VHActionSheet.m
//  VHiPad
//
//  Created by vhall on 2018/5/21.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHActionSheet.h"

static const CGFloat kButtonHeight = 44;
static const CGFloat kButtonDistance = 16;

static const CGFloat kButtonTagBase = 109006;

@interface VHActionSheet ()

@property (nonatomic ,strong) UIView *alert;
@property (nonatomic ,strong) UILabel *titleLab;

@end



@implementation VHActionSheet

- (VHActionSheet *)initWithTitle:(NSString *)title
                        delegate:(id)delegate
                             tag:(NSUInteger)tag
                    buttonTitles:(NSArray *)buttonTitles
{
    VHActionSheet *actionsheet = [[VHActionSheet alloc] initWithFrame:[UIScreen mainScreen].bounds title:title buttonTitles:buttonTitles];
    actionsheet.delegate = delegate;
    actionsheet.tag = tag;
    
    return actionsheet;
}
- (void)show {
    UIWindow *topWindow = [[UIApplication sharedApplication] windows].firstObject;
    
//    for (UIView *view in topWindow.subviews) {
//        if ([view isMemberOfClass:[VHCameraAlert class]] || [view isMemberOfClass:[VHVideoAlert class]])
//        {
//            [view removeFromSuperview];
//        }
//    }
    
    [topWindow addSubview:self];
    [topWindow bringSubviewToFront:self];
}

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonTitles:(NSArray *)buttonTitles
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [self addAlert];

        [self addTitleLabelWithTitle:title];
        
        [self addButtonsWithTitles:buttonTitles];
        
        CGRect alertFrme = _alert.frame;
        alertFrme.size.height = CGRectGetMaxY(_titleLab.frame) + (buttonTitles.count + 1) * kButtonDistance + buttonTitles.count * kButtonHeight+5;
        alertFrme.origin.y = SCREEN_HEIGHT/2-alertFrme.size.height/2;
        _alert.frame = alertFrme;
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _alert.width, _titleLab.origin.y+_titleLab.size.height)];
        view.backgroundColor = UIColor(249, 249, 249, 1);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(5.0, 5.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        [_alert addSubview:view];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y+view.frame.size.height-0.25, _alert.width, 0.25)];
        line.backgroundColor = UIColor(0, 0, 0, 0.1);
        [_alert addSubview:line];
        
        
        [_alert bringSubviewToFront:_titleLab];
    }
    return self;
}

- (void)addAlert {
    _alert = [[UIView alloc] init];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        _alert.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//        _alert.bounds = CGRectMake(0, 0, 320*SCREEN_RATIO_WIDTH, 178*SCREEN_RATIO_HEIGHT);
//    }
//    else {
        _alert.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        _alert.bounds = CGRectMake(0, 0, SCREEN_WIDTH-100, 150);
//    }
    _alert.backgroundColor = [UIColor whiteColor];
    _alert.layer.cornerRadius = 5;
    _alert.layer.masksToBounds = YES;
    [self addSubview:_alert];
}
- (void)addTitleLabelWithTitle:(NSString *)title {
    if (title) {
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = title;
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = UIColor(68, 68, 68, 1);
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        
        CGRect rect = [title boundingRectWithSize:CGSizeMake(_alert.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _titleLab.font} context:nil];
        
        if (rect.size.height < 44) {
            rect.size.height = 44;
        }
        
        _titleLab.frame = CGRectMake(20, 0, _alert.frame.size.width-40, rect.size.height);
        
        [_alert addSubview:_titleLab];
    }
}

- (void)addButtonsWithTitles:(NSArray *)titles {
    
    NSArray *selectedColor = @[UIColor(82, 204, 144, 1),UIColor(82, 204, 144, 1),UIColor(252, 86, 89, 1)];
    
    
    for (int i = 0; i < titles.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(16, CGRectGetMaxY(_titleLab.frame) + kButtonDistance + (kButtonHeight + kButtonDistance)*i , _alert.frame.size.width-32, kButtonHeight);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = kButtonTagBase+i;
        button.layer.cornerRadius = kButtonHeight*0.5;
        
        [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:selectedColor[i] forState:UIControlStateHighlighted];
        
        [button setTitleColor:UIColor(68, 68, 68, 1) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.layer.borderColor = UIColor(0, 0, 0, 0.1).CGColor;
        button.layer.borderWidth = 0.5;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"灰色"] forState:UIControlStateSelected ];
//        [button setBackgroundImage:[UIImage imageNamed:@"灰色"] forState:UIControlStateHighlighted];
//        button.imageView.layer.masksToBounds = YES;
//        button.imageView.layer.cornerRadius = kButtonHeight*0.5;
        
        [self.alert addSubview:button];
    }
}


- (void)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
    {
        [self.delegate actionSheet:self clickedButtonAtIndex:sender.tag-kButtonTagBase];
    }
    [self removeFromSuperview];
}


@end
