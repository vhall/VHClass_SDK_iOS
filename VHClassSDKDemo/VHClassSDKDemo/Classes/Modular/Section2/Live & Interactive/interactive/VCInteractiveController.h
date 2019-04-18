//
//  VCInteractiveController.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/18.
//  Copyright © 2019 class. All rights reserved.
//

#import "VHCModularBaseViewController.h"

@class VCInteractiveController;

NS_ASSUME_NONNULL_BEGIN

//上麦方式
typedef NS_ENUM(NSInteger,MicroType) {
    MicroTypeDefault, //默认为推视频+音频流
    MicroTypeOnlyVoice,//语音上麦
};

//互动类型
typedef NS_ENUM(NSInteger,CourseType) {
    CourseTypeDefault = 0, //1 V 1     小课堂布局
    CourseType_1VN  = 1,    // 1 V N   公开课布局
};

@protocol VCInteractiveControllerDelegate <NSObject>

@optional

- (void)interactiveViewController:(VCInteractiveController *)vc didError:(VHCError *)error;

@end


@interface VCInteractiveController : VHCModularBaseViewController

@property (nonatomic, weak) id <VCInteractiveControllerDelegate> delegate;

@property (nonatomic, assign) MicroType type;

- (instancetype)initWithCourseType:(CourseType)type;

- (void)leave;

- (void)setDocView:(nullable UIView *)docView;

//锁屏设置
- (void)lockedScreen:(BOOL)isLock;

@end

NS_ASSUME_NONNULL_END
