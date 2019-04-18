//
//  VHAlertView.m
//  VHiPad
//
//  Created by dry on 2018/5/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHAlertView.h"

static const CGFloat kButtonHeight = 44;

static const CGFloat kVHAlertViewLeftBtnTag = 642225;
static const CGFloat kVHAlertViewRightBtnTag = 642226;

@interface VHAlertView ()
{
    CGFloat spaceDistance;
    UILabel *_titleLab;
    UILabel *_messageLab;
}
@end

@implementation VHAlertView

#pragma mark - 便捷构造方法
- (VHAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
                      delegate:(id)delegate
                           tag:(NSUInteger)tag
             cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitle:(NSString *)otherButtonTitle
{
    VHAlertView *alertView = [[VHAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                          title:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:cancelButtonTitle
                                               otherButtonTitle:otherButtonTitle];
    alertView.delegate = delegate;
    alertView.tag = tag;
    
    return alertView;
}

#pragma mark - init方法
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      message:(NSString *)message
                     delegate:(id)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle
{
    if (self = [super initWithFrame:frame]) {
        
        spaceDistance = (!title || !message) ? 58 : 30;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

        [self addAlert];
    
        [self addTitleLabelWithTitle:title];
        
        [self addMessageLabelWithMassage:message];
        
        [self adjustAlertLayoutWithTitle:title message:message];
        
        [self addLeftBtnWithCancelButtonTitle:cancelButtonTitle tag:kVHAlertViewLeftBtnTag];
        [self addRightBtnWithOtherButtonTitles:otherButtonTitle tag:kVHAlertViewRightBtnTag];
    
        [self adjustLayoutWithCancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle];
        
        [self addLine];
    }
    return self;
}

- (void)addAlert {
    _alert = [[UIView alloc] init];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        _alert.center = CGPointMake(VCScreenWidth/2, VCScreenHeight/2);
//        _alert.bounds = CGRectMake(0, 0, 300*SCREEN_RATIO_WIDTH, 178*SCREEN_RATIO_HEIGHT);
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
        
        _titleLab.frame = CGRectMake(20, spaceDistance, _alert.frame.size.width-40, rect.size.height);
        
        [_alert addSubview:_titleLab];
    }
}
- (void)addMessageLabelWithMassage:(NSString *)message {
    if (message)
    {
        _messageLab = [[UILabel alloc] init];
        _messageLab.text = message;
        _messageLab.font = [UIFont systemFontOfSize:15];
        _messageLab.textColor = UIColor(68, 68, 68, 1);
        _messageLab.numberOfLines = 0;
        _messageLab.textAlignment = NSTextAlignmentCenter;
        
        CGRect rect = [message boundingRectWithSize:CGSizeMake(_alert.frame.size.width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_messageLab.font} context:nil];
        
        CGFloat originY = (_titleLab) ? (spaceDistance + _titleLab.frame.size.height + spaceDistance) : (spaceDistance);
        
        _messageLab.frame = CGRectMake(20, originY, _alert.frame.size.width - 40, rect.size.height);
        
        [_alert addSubview:_messageLab];
    }
}

- (void)adjustAlertLayoutWithTitle:(NSString *)title message:(NSString *)message
{
    CGRect alertFrame = self.alert.frame;
    if (!title || !message) {
        alertFrame.size.height = spaceDistance + _titleLab.frame.size.height + spaceDistance + _messageLab.frame.size.height + kButtonHeight;
    } else {
        alertFrame.size.height = spaceDistance + _titleLab.frame.size.height + spaceDistance + _messageLab.frame.size.height + spaceDistance + kButtonHeight;
        
        CGRect frame1 = _titleLab.frame;
        frame1.origin.y = (_alert.height-kButtonHeight-10-_titleLab.height-_messageLab.height)*0.5;
        _titleLab.frame = frame1;
        
        CGRect frame2 = _messageLab.frame;
        frame2.origin.y = _titleLab.origin.y+_titleLab.frame.size.height+10;
        _messageLab.frame = frame2;
    }
    self.alert.frame = alertFrame;
}

- (void)addLine {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _alert.frame.size.height - kButtonHeight-0.25, _alert.width, 0.25)];
    line.backgroundColor = UIColor(204, 204, 204, 1);
    [_alert addSubview:line];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(_alert.width*0.5-0.25, line.frame.origin.y+0.5, 0.5, kButtonHeight-0.5)];
    line1.backgroundColor = UIColor(204, 204, 204, 1);
    [_alert addSubview:line1];
}

- (void)addLeftBtnWithCancelButtonTitle:(NSString *)cancelButtonTitle tag:(NSUInteger)cancelButtonTag
{
    _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _leftBtn.frame = CGRectMake(0, _alert.frame.size.height - kButtonHeight, _alert.frame.size.width / 2, kButtonHeight);
    _leftBtn.backgroundColor = [UIColor whiteColor];
    [_leftBtn setTitle:cancelButtonTitle forState:(UIControlStateNormal)];
    [_leftBtn setTitleColor:UIColor(68, 68, 68, 1) forState:(UIControlStateNormal)];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _leftBtn.tag = cancelButtonTag;
    _leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle 4"] forState:(UIControlStateHighlighted)];
    [_leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.alert addSubview:_leftBtn];
}
- (void)addRightBtnWithOtherButtonTitles:(NSString *)otherButtonTitles tag:(NSUInteger)otherButtonTag {
    if (otherButtonTitles)
    {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rightBtn.frame = CGRectMake(_leftBtn.frame.size.width - 1, _alert.frame.size.height - kButtonHeight, _alert.frame.size.width / 2 + 1, kButtonHeight);
        _rightBtn.backgroundColor = [UIColor whiteColor];
        [_rightBtn setTitle:otherButtonTitles forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:UIColor(252, 86, 89, 1) forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rightBtn.tag = otherButtonTag;
//        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle 4"] forState:(UIControlStateHighlighted)];
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.alert addSubview:_rightBtn];
    }
}
- (void)adjustLayoutWithCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
    if (cancelButtonTitle && !otherButtonTitles)
    {
        CGRect leftFrame = _leftBtn.frame;
        leftFrame.size.width = _alert.frame.size.width;
        _leftBtn.frame = leftFrame;
        
        CGRect rightFrame = _rightBtn.frame;
        rightFrame.size.width = 0;
        _rightBtn.frame = rightFrame;
        
    }
    else if (!cancelButtonTitle && otherButtonTitles)
    {
        CGRect leftFrame = _leftBtn.frame;
        leftFrame.size.width = 0;
        _leftBtn.frame = leftFrame;
        
        CGRect rightFrame = _rightBtn.frame;
        rightFrame.size.width = _alert.frame.size.width;
        rightFrame.origin.x = 0;
        _rightBtn.frame = rightFrame;
    }
}

- (void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:(btn.tag - 642225)];
    }
    [self removeFromSuperview];
}

- (void)show
{
    UIWindow *topWindow = [[UIApplication sharedApplication] windows].firstObject;
    [topWindow addSubview:self];
    [topWindow bringSubviewToFront:self];
}

@end

