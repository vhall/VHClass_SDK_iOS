//
//  VHLiveLayerView.h
//  VHClassSDKDemo
//
//  Created by vhall on 2019/3/14.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VHLiveLayerView;

@protocol VHLiveLayerViewDelegate <NSObject>

@optional

//play and puss button action
- (void)recordView:(VHLiveLayerView *)view playButtonClick:(UIButton *)playBtn;

//分辨率
- (void)recordView:(VHLiveLayerView *)view definationButtonClick:(UIButton *)button;

//返回
- (void)recordView:(VHLiveLayerView *)view returnButtonClick:(UIButton *)button;

//画面填充模式
- (void)recordView:(VHLiveLayerView *)view scallingBtnClick:(UIButton *)button;

@end

@interface VHLiveLayerView : UIView

@property (nonatomic, weak) id <VHLiveLayerViewDelegate> delegate;

@property (nonatomic, strong) UIButton *playBtn;

///subviews of tool bar , set scalling model
@property (nonatomic, strong) UIButton *scallingBtn;

//loading
- (void)startIndicatorAnimating;
- (void)stopIndicatorAnimating;

- (void)playButtonClick:(UIButton *)playBtn;

- (void)hiddenToolBar:(BOOL)isHidden;

- (void)setDefination:(NSString *)defi;

- (void)setScallingModel:(NSInteger)scalling;

@end

NS_ASSUME_NONNULL_END
