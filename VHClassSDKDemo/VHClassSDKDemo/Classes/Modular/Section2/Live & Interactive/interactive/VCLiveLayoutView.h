//
//  VCLiveLayoutView.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/19.
//  Copyright © 2019 class. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCInteractiveMaskView;
@class VCLiveLayoutView;
@class VHCInteractiveRoom;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,ViewLayoutType) {
    ViewLayoutType1v1,
    ViewLayoutType1vN,
};

typedef NS_ENUM(NSUInteger,AddViewType) {
    AddViewTypeHost,    //讲师视图
    AddViewTypeShared,  //讲师的共享桌面
    AddViewTypeOwn,     //学员自己的视图
    AddViewTypeOther,   //其他学员视图
};

typedef NS_ENUM(NSUInteger,LayoutEvent) {//"摄像头","麦克风","切换屏幕","切换摄像头"
    LayoutEvent_VideoStauts,    //摄像头事件
    LayoutEvent_Audio,          //麦克风事件
    LayoutEvent_ScreenChange,   //切换屏幕
    LayoutEvent_VideoSwitch,    //切换摄像头
};

@protocol VCLiveLayoutViewDelegate <NSObject>

- (void)layoutView:(VCLiveLayoutView *)layoutView layoutEvent:(LayoutEvent)event renderView:(UIView *)renderView clickButton:(UIButton *)sender;

@end


@interface VCLiveLayoutView : UIView

@property (nonatomic, weak) id <VCLiveLayoutViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame layoutType:(ViewLayoutType)type;



- (void)addView:(UIView *)view type:(AddViewType)type;
- (void)removeView:(UIView *)view;
- (void)removAllViews;



- (void)room:(VHCInteractiveRoom *)room liveUser:(NSString *)joinId micphoneStatusChanged:(BOOL)isClose byUser:(NSString *)byUserId;
- (void)liveUser:(NSString *)joinId cameraStatusChanged:(BOOL)isClose byUser:(NSString *)byUserId;



- (void)changeMainViewWithMaskView:(UIView *)renderView;


@property (nonatomic, weak, nullable) UIView *docView;

@end

NS_ASSUME_NONNULL_END
