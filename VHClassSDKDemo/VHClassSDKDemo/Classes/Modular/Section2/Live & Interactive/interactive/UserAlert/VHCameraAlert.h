//
//  VHCameraAlert.h
//  VHiPad
//
//  Created by vhall on 2018/6/7.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCInteractiveMaskView;
@class VHCameraAlert;

@protocol VHCameraAlertDelegate <NSObject>

- (void)cameraAlert:(VHCameraAlert *)alert clickedButton:(UIButton *)sender index:(NSInteger)index;

@end

@interface VHCameraAlert : UIView

@property (nonatomic, weak) id <VHCameraAlertDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithDelegate:(id <VHCameraAlertDelegate>)delegate title:(NSString *)title;
- (void)show;


@property (nonatomic, strong) VCInteractiveMaskView *maskView;

@property (nonatomic, assign) BOOL exchangedEnable;

@end
