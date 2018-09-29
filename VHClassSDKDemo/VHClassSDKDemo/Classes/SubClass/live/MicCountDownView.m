//
//  MicCountDownView.m
//  LightEnjoy
//
//  Created by vhall on 2018/7/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "MicCountDownView.h"

@interface MicCountDownView ()
{
    NSUInteger timeCount;
}
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation MicCountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:10.0];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timeLabel.frame = CGRectMake(1, 1, self.width-2, self.height-4-2);
}



- (void)countdDown:(NSUInteger)count {
    //重置倒计时
    [self stopTimer];
    //重置
    timeCount = count;
    //初始时间
    self.timeLabel.text = [NSString stringWithFormat:@"%lus",(unsigned long)count];
    self.hidden = NO;
    //开始倒计时
    self.timer.fireDate = [NSDate distantPast];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)removeTimer {
    if (_timer) {
        //停止timer
        [self stopTimer];
        
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)stopTimer {
    //停止timer
    _timer.fireDate = [NSDate distantFuture];
}

- (void)timerAction
{
    if (timeCount <= 0) {
        
        [self stopTimer];
        
        self.hidden = YES;
    }
    else {
        
        timeCount--;
        
        self.timeLabel.text = [NSString stringWithFormat:@"%lus",(unsigned long)timeCount];
    }
}
- (void)hiddenCountView {
    [self stopTimer];
    [UIView animateWithDuration:.3 animations:^{
        
        self.hidden = YES;
    }];
}


@end
