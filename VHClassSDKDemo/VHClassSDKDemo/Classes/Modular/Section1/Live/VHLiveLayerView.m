//
//  VHLiveLayerView.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/3/14.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHLiveLayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define kVCRecordViewToolBarHeight 45
#define kVCRecordViewTimeLabelWidth 200

//default is show
typedef NS_ENUM(NSUInteger,VCRecordViewToolBarState) {
    VCRecordViewToolBarStateShow,
    VCRecordViewToolBarStateAnimating,
    VCRecordViewToolBarStateHidden,
};

@interface VHLiveLayerView ()
{
    CGFloat _startY;
    UISlider *_volumSlider;
}
/// top bottom comtentView
@property (nonatomic, strong) UIView *bottomContentView;
@property (nonatomic, strong) UIView *topContentView;

@property (nonatomic, strong) UIButton *lockBtn;


///bottom tool bar
@property (nonatomic, strong) UIView *bottomToolBar;
@property (nonatomic, assign) VCRecordViewToolBarState bottomToolBarState;

///subviews of tool bar
@property (nonatomic, strong) UIButton *defiBtn;

///subviews of top
@property (nonatomic, strong) UIButton *returnBtn;

///indicator
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation VHLiveLayerView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bottomContentView.frame = CGRectMake(0, self.height-90, self.width, 90);
    
    self.bottomToolBar.frame = CGRectMake(0, self.bottomContentView.frame.size.height-kVCRecordViewToolBarHeight, self.bottomContentView.frame.size.width, kVCRecordViewToolBarHeight);
    self.playBtn.frame = CGRectMake(15, self.bottomToolBar.height*0.5-21*0.5, 21, 21);
    
    self.defiBtn.frame = CGRectMake(self.bottomToolBar.right-60-15, self.bottomToolBar.height*0.5-15, 60, 30);
    
    self.scallingBtn.frame = CGRectMake(self.defiBtn.origin.x - 10 - self.defiBtn.width, self.defiBtn.top, self.defiBtn.width, self.defiBtn.height);
    
    self.topContentView.frame = CGRectMake(0, 0, self.width, 90);
    
    self.returnBtn.frame = CGRectMake(20, 30, 44, 44);
    
    self.indicatorView.frame = self.bounds;
    _lockBtn.frame = CGRectMake(20, self.height*0.5-22, 44, 44);
    
    
    _returnBtn.hidden = YES;
    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        _returnBtn.hidden = NO;
    }
    
    
    self.defiBtn.backgroundColor = [UIColor brownColor];
    self.scallingBtn.backgroundColor = [UIColor purpleColor];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUpBottomViews];
        
        [self setUpTopViews];
        
        
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:[UIImage imageNamed:@"锁_开启"] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:@"锁_关闭"] forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGes];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
        [self addGestureRecognizer:panGes];
        
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.userInteractionEnabled = YES;
        
        [self addSubview:self.topContentView];
        [self addSubview:self.bottomContentView];
        [self addSubview:self.indicatorView];
        [self addSubview:self.lockBtn];
    }
    return self;
}

- (void)setUpBottomViews
{
    self.bottomContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-90, self.width, 90)];
    
    self.bottomToolBar = [[UIView alloc] init];
    self.bottomToolBar.backgroundColor = [UIColor clearColor];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"play_play"] forState:UIControlStateSelected];
    self.playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.defiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.defiBtn setTitle:@"原画" forState:UIControlStateNormal];
    [self.defiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.defiBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.defiBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    self.scallingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scallingBtn setTitle:@"Fill" forState:UIControlStateNormal];
    [self.scallingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.scallingBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.scallingBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [self.playBtn addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.defiBtn addTarget:self action:@selector(defiBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scallingBtn addTarget:self action:@selector(scallingBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.bottomContentView addSubview:self.bottomToolBar];
    
    [self.bottomToolBar addSubview:self.playBtn];
    [self.bottomToolBar addSubview:self.defiBtn];
    [self.bottomToolBar addSubview:self.scallingBtn];
    
    [self performSelector:@selector(hiddenButtons) withObject:nil afterDelay:3];
}
- (void)setUpTopViews {
    self.topContentView = [[UIView alloc] init];
    
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnBtn setImage:[UIImage imageNamed:@"箭头左"] forState:UIControlStateNormal];
    [self.returnBtn addTarget:self action:@selector(returnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topContentView addSubview:self.returnBtn];
}

- (void)dealloc {
    
}



#pragma mark - public
- (void)startIndicatorAnimating
{
    [self.indicatorView startAnimating];
}
- (void)stopIndicatorAnimating
{
    [self.indicatorView stopAnimating];
}
- (void)hiddenToolBar:(BOOL)isHidden
{
    self.bottomToolBar.hidden = isHidden;
}
- (void)setDefination:(NSString *)defi {
    [self.defiBtn setTitle:defi forState:UIControlStateNormal];
}
- (void)setScallingModel:(NSInteger)scalling {
    NSArray *titles = @[@"Fill",@"AFit",@"AFill"];
    NSInteger index = MAX(0, MIN(scalling, 2));
    [self.scallingBtn setTitle:titles[index] forState:UIControlStateNormal];
}


#pragma mark - action
- (void)playButtonClick:(UIButton *)playBtn
{
    if ([self.delegate respondsToSelector:@selector(recordView:playButtonClick:)])
    {
        [self.delegate recordView:self playButtonClick:playBtn];
    }
}
- (void)defiBtnButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(recordView:definationButtonClick:)])
    {
        [self.delegate recordView:self definationButtonClick:sender];
    }
}
- (void)scallingBtnButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(recordView:scallingBtnClick:)])
    {
        [self.delegate recordView:self scallingBtnClick:sender];
    }
}
- (void)returnButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(recordView:returnButtonClick:)])
    {
        [self.delegate recordView:self returnButtonClick:sender];
    }
}

- (void)lockBtnClicked:(UIButton *)button
{
    button.selected = !button.selected;
    
    self.topContentView.hidden = button.selected;
    self.bottomContentView.hidden = button.selected;
}

- (void)tapGesAction:(UITapGestureRecognizer *)tapGes
{
    if (self.lockBtn.hidden)
    {
        [self showButtons];
    }
    else
    {
        [self hiddenButtons];
    }
}

- (void)panGesAction:(UIPanGestureRecognizer *)panGes
{
    CGPoint point = [panGes locationInView:self];
    
    if (panGes.state == UIGestureRecognizerStateBegan)
    {
        _startY = point.y;
    }
    else if (panGes.state == UIGestureRecognizerStateChanged)
    {
        //真实的滑动距离
        CGFloat slide = (_startY - point.y);
        //设置一个参数，控制滑动设置
        CGFloat newSlide = slide * 0.25;
        //将滑动距离映射到语序的调节范围(0~1)内
        CGFloat cur = newSlide / self.height;
        
        if (point.x < self.center.x)     //音量设置
        {
            //最终值
            CGFloat volume = [AVAudioSession sharedInstance].outputVolume + cur;
            volume = MIN(MAX(0, volume), 1);
            //NSLog(@"最终值：%f",volume);
            if (!_volumSlider) {
                _volumSlider = [self getSystemVolumSlider];
            }
            _volumSlider.value = volume;
        }
        else    //亮度设置
        {
            //最终值
            CGFloat bright = [UIScreen mainScreen].brightness + cur;
            bright = MIN(MAX(0, bright), 1);
            //NSLog(@"最终值：%f",bright);
            [[UIScreen mainScreen] setBrightness:bright];
        }
    }
}

#pragma mark - private
- (void)showButtons
{
    if (_lockBtn.selected) //当前是锁屏状态
    {
        self.lockBtn.hidden = NO;
    }
    else
    {
        self.topContentView.hidden = NO;
        self.lockBtn.hidden = NO;
        self.bottomContentView.hidden = NO;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenButtons) object:nil];
    [self performSelector:@selector(hiddenButtons) withObject:nil afterDelay:3];
}
- (void)hiddenButtons
{
    self.topContentView.hidden = YES;
    self.lockBtn.hidden = YES;
    self.bottomContentView.hidden = YES;
}

- (UISlider*)getSystemVolumSlider
{
    static UISlider * volumeViewSlider = nil;
    if (volumeViewSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView* newView in volumeView.subviews)
        {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"])
            {
                volumeViewSlider = (UISlider*)newView;
                break;
            }
        }
    }
    return volumeViewSlider;
}






@end
