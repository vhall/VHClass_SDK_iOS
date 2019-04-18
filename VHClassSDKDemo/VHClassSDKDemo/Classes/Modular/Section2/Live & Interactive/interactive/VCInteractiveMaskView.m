//
//  VCInteractiveMaskView.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/19.
//  Copyright © 2019 class. All rights reserved.
//

#import "VCInteractiveMaskView.h"

@interface VCInteractiveMaskView ()

@property (nonatomic , strong) UIImageView *bottomImageView;
@property (nonatomic , strong) UIImageView *idImageView;//身份表示
@property (nonatomic , strong) UILabel *nickNameLabel;//昵称
@property (nonatomic , strong) UIImageView *microphoneImageView;//麦克风图标

@property (nonatomic , strong) UIImageView *cameraBackView;//摄像头图标底图
@property (nonatomic , strong) UIImageView *cameraImageView;//摄像头图标

@end

@implementation VCInteractiveMaskView

- (void)setActor:(VCInteractor *)actor {
    _actor = actor;
    
    [self updateUI];
}


- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateUI];
}

- (void)updateUI {
    
    self.cameraBackView.frame = self.bounds;
    
    //大画面
    if (self.width >= [UIScreen mainScreen].bounds.size.width*0.5)
    {
        //视频底部阴影
        self.bottomImageView.frame = CGRectMake(0, self.height-64, self.width, 65);
        //大画面需要显示用户身份图标、用户昵称、麦克风状态、视频状态
        //身份标识
        if (_actor.userRole == VHCLiveUserRoleHost) {
            self.idImageView.frame = CGRectMake(12, self.height-6-15, 15, 15);
            self.idImageView.image = [UIImage imageNamed:@"星星"];
        }
        else {
            self.idImageView.frame = CGRectMake(12, self.height-6-15, 35, 15);
            if (_actor.userRole == VHCLiveUserRoleHelper) {
                self.idImageView.image = [UIImage imageNamed:@"助教"];
            } else if (_actor.userRole == VHCLiveUserRoleGuest) {
                self.idImageView.image = [UIImage imageNamed:@"嘉宾"];
            }
            else {
                if ([_actor.joinId isEqualToString:VH_userId]) {
                    self.idImageView.image = [UIImage imageNamed:@"自己"];
                }
                else {
                    self.idImageView.image = [UIImage imageNamed:@"学员"];
                }
            }
        }
        //用户昵称
        self.nickNameLabel.font = [UIFont systemFontOfSize:13.0];
        CGRect nameRect = [VHCTool rectWithText:_actor.nickName font:self.nickNameLabel.font rangeSize:CGSizeMake(self.width*0.5, 20)];
        self.nickNameLabel.frame = CGRectMake(self.idImageView.right+2, self.height-13-6, nameRect.size.width, 13);
        self.nickNameLabel.text = _actor.nickName;
        //麦克风状态
        self.microphoneImageView.frame = CGRectMake(self.nickNameLabel.right+2, self.height-6-16, 16, 16);
        //摄像头图标
        self.cameraImageView.frame = CGRectMake(self.cameraBackView.width*0.5-72*0.5, self.cameraBackView.height*0.5-58*0.5, 72, 58);
    }
    //小画面
    else
    {
        //视频底部阴影
        self.bottomImageView.frame = CGRectMake(0, self.height-19, self.width, 20);
        //小画面不显示用户昵称，只显示麦克风状态、视频状态；讲师显示用户身份标识，学员不显示
        self.idImageView.frame = CGRectZero;
        self.nickNameLabel.frame = CGRectZero;
        self.microphoneImageView.frame = CGRectMake(6, self.height-3-16, 16, 16);
        //摄像头图标
        self.cameraImageView.frame = CGRectMake(self.cameraBackView.width*0.5-35*0.5, self.cameraBackView.height*0.5-27*0.5, 35, 27);
        if (_actor.userRole == VHCLiveUserRoleHost) {
            self.idImageView.frame = CGRectMake(6, self.height-3-15, 15, 15);
            self.idImageView.image = [UIImage imageNamed:@"星星"];
            
            self.microphoneImageView.left = self.idImageView.right+2;
        }
    }
    
    self.cameraBackView.hidden = !_actor.cameraClose;
    self.microphoneImageView.hidden = (_actor.allCloseAudio || _actor.micphoneClose) ? NO : YES;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        
        self.cameraBackView = [[UIImageView alloc] init];
        self.cameraBackView.backgroundColor = UIColor(51, 52, 56, 1);
        self.cameraBackView.userInteractionEnabled = YES;
        [self addSubview:self.cameraBackView];
        
        
        self.cameraImageView = [[UIImageView alloc] init];
        self.cameraImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.cameraImageView.image = [UIImage imageNamed:@"禁止摄像头"];
        self.cameraImageView.userInteractionEnabled = YES;
        [self.cameraBackView addSubview:self.cameraImageView];

        
        self.bottomImageView = [[UIImageView alloc] init];
        self.bottomImageView.image = [UIImage imageNamed:@"video_bottom_image"];
        [self insertSubview:self.bottomImageView aboveSubview:self.cameraImageView];

        
        self.idImageView = [[UIImageView alloc] init];
        [self addSubview:self.idImageView];
        
        
        self.nickNameLabel = [[UILabel alloc] init];
        self.nickNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nickNameLabel];
        
        
        self.microphoneImageView = [[UIImageView alloc] init];
        self.microphoneImageView.image = [UIImage imageNamed:@"静音开启"];
        [self addSubview:self.microphoneImageView];
    }
    return self;
}

@end
