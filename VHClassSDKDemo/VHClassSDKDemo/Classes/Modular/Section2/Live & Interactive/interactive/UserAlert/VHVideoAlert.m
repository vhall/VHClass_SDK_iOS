//
//  VHVideoAlert.m
//  VHiPad
//
//  Created by vhall on 2018/6/8.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHVideoAlert.h"
#import "VCInteractiveMaskView.h"

@interface VHVideoAlert ()

@property (nonatomic ,strong) UIView *alert;
@property (nonatomic ,strong) UIView *titleView;

@end


@implementation VHVideoAlert

- (instancetype)initWithDelegate:(id <VHVideoAlertDelegate>)delegate tag:(NSInteger)tag title:(NSString *)title icon:(UIImage *)image {
    
    VHVideoAlert *alert = [[VHVideoAlert alloc] initWithFrame:[UIScreen mainScreen].bounds title:title icon:(UIImage *)image];
    alert.delegate = delegate;
    alert.tag = tag;
    alert.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    return alert;
}
- (void)show {
    UIWindow *topWindow = [[UIApplication sharedApplication] windows].firstObject;
    [topWindow addSubview:self];
    [topWindow bringSubviewToFront:self];
}


#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title icon:(UIImage *)image
{
    if (self = [super initWithFrame:frame])
    {
        
        [self addAlert];
        
        [self addTitleLabelWithTitle:title icon:image];
        
        
        
        [self addButton];
        
        
        if (title) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, _alert.width, 44)];
            view.backgroundColor = UIColor(249, 249, 249, 1);
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(5.0, 5.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = view.bounds;
            maskLayer.path = maskPath.CGPath;
            view.layer.mask = maskLayer;
            [_alert addSubview:view];
            self.titleView = view;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.bottom-0.25, _alert.width, 0.5)];
            line.backgroundColor = UIColor(0, 0, 0, 0.1);
            [_alert addSubview:line];
            
            [_alert bringSubviewToFront:_titleLabel];
        }
        else {
            CGRect frame = _alert.frame;
            frame.size.height -= 44;
            _alert.frame = frame;
        }
    }
    return self;
}

- (void)addAlert {
    _alert = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5-325*0.5, self.frame.size.height/2-178*0.5, 325, 178)];
    _alert.backgroundColor = [UIColor whiteColor];
    _alert.layer.cornerRadius = 5;
    _alert.layer.masksToBounds = YES;
    [self addSubview:_alert];
}
- (void)addTitleLabelWithTitle:(NSString *)title icon:(UIImage *)image {
    if (title) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColor(68, 68, 68, 1);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = 5;
        _titleLabel.layer.masksToBounds = YES;
        
        CGRect rect = [title boundingRectWithSize:CGSizeMake(_alert.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLabel.font} context:nil];

        if (rect.size.height < 44) {
            rect.size.height = 44;
        } else {
            rect.size.height += 10;
        }
        
        _titleLabel.frame = CGRectMake(20, 5, _alert.frame.size.width-40, rect.size.height);
        
        [_alert addSubview:_titleLabel];
        
        
        if (image) {
            //拿到整体的字符串
            NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",title]];
            // 创建图片图片附件
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = image;
            attach.bounds = CGRectMake(0, 0, 40.8, 16.8);
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            //将图片插入到合适的位置
            [nameString insertAttributedString:attachString atIndex:0];
            
            CGFloat height = _titleLabel.font.lineHeight;
            attach.bounds = CGRectMake(0, -4, 42, height);
            
            _titleLabel.attributedText = nameString;
        }
        else {
            
            _titleLabel.text = title;
        }
    }
}

- (void)addButton {
    
    int  i = 0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_alert.width*0.5-25, _titleLabel.bottom+30, 50, 50);
    [button setBackgroundImage:[UIImage imageNamed:@"切换屏幕"] forState:UIControlStateNormal];
    
    button.tag = i+103945;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alert addSubview:button];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x-20, button.bottom+10, button.width+40, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor(68, 68, 68, 1);
    label.font = [UIFont systemFontOfSize:11.0];
    label.text = @"切换屏幕";
    [_alert addSubview:label];
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(vedioAlert:clickedButton:index:)]) {
        [self.delegate vedioAlert:self clickedButton:sender index:sender.tag-103945];
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *view = [touches anyObject].view;
    if (view != _alert && view != _titleView) {
        [self removeFromSuperview];
    }
}

- (void)setMaskView:(VCInteractiveMaskView *)maskView {
    _maskView = maskView;
}


- (void)setExchangedEnable:(BOOL)exchangedEnable {
    _exchangedEnable = exchangedEnable;
    UIButton *exBtn = [self.alert viewWithTag:103945];
    exBtn.enabled = _exchangedEnable;
}


@end
