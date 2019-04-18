//
//  VHCameraAlert.m
//  VHiPad
//
//  Created by vhall on 2018/6/7.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHCameraAlert.h"
#import "VCInteractiveMaskView.h"

@interface VHCameraAlert ()

@property (nonatomic ,strong) UIView *alert;
@property (nonatomic ,strong) UIView *titleView;

@end


@implementation VHCameraAlert

- (instancetype)initWithDelegate:(id <VHCameraAlertDelegate>)delegate title:(NSString *)title {

    VHCameraAlert *alert = [[VHCameraAlert alloc] initWithFrame:[UIScreen mainScreen].bounds title:title];
    alert.delegate = delegate;
    alert.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    return alert;
}
- (void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    [keyWindow bringSubviewToFront:self];
}




#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame])
    {
        
        [self addAlert];
        
        [self addTitleLabelWithTitle:title];
        
        
        NSArray *defaultImages = @[@"摄像头开启",@"麦克风开启",@"切换屏幕",@"切换摄像头"];
        
        [self addButtonWithImages:defaultImages];
        
        
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
    return self;
}

- (void)addAlert {
    _alert = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5-325*0.5, self.frame.size.height/2-178/2, 325, 178)];
    _alert.backgroundColor = [UIColor whiteColor];
    _alert.layer.cornerRadius = 5;
    _alert.layer.masksToBounds = YES;
    [self addSubview:_alert];
}
- (void)addTitleLabelWithTitle:(NSString *)title {
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
        
        UIImage *image = [UIImage imageNamed:@"自己"];
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

- (void)addButtonWithImages:(NSArray *)images {

    NSArray *titles = @[@"摄像头",@"麦克风",@"切换屏幕",@"切换摄像头"];


    CGFloat x = _alert.width*0.5-(4*50+3*20)*0.5;

    for (int i = 0; i < 4; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( x + (50+20)*i, _titleLabel.bottom+30, 50, 50);
        [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        button.tag = i+103945;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alert addSubview:button];


        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x-20, button.bottom+10, button.width+40, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColor(68, 68, 68, 1);
        label.font = [UIFont systemFontOfSize:11.0];
        label.text = titles[i];
        [_alert addSubview:label];
    }
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cameraAlert:clickedButton:index:)]) {
        [self.delegate cameraAlert:self clickedButton:sender index:sender.tag-103945];
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


- (void)setMaskView:(VCInteractiveMaskView *)maskView
{
    _maskView = maskView;
    
    UIButton *caButton = [_alert viewWithTag:103945];
    UIButton *miButton = [_alert viewWithTag:103946];
    
    UIImage *caImage = [UIImage imageNamed:@"摄像头禁止"];
    UIImage *micImage = [UIImage imageNamed:@"麦克风禁止"];
    
    if (maskView.actor.cameraClose) {
        caButton.selected = YES;
        [caButton setBackgroundImage:caImage forState:UIControlStateNormal];
    }
    if (maskView.actor.micphoneClose) {
        miButton.selected = YES;
        [miButton setBackgroundImage:micImage forState:UIControlStateNormal];
    }
}

- (void)setExchangedEnable:(BOOL)exchangedEnable {
    _exchangedEnable = exchangedEnable;
    UIButton *exBtn = [self.alert viewWithTag:103945+2];
    exBtn.enabled = _exchangedEnable;
}

@end
