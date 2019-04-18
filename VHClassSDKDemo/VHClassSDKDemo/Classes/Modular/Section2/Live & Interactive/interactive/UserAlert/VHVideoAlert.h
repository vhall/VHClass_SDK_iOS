//
//  VHVideoAlert.h
//  VHiPad
//
//  Created by vhall on 2018/6/8.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VHVideoAlert;
@class VCInteractiveMaskView;

@protocol VHVideoAlertDelegate <NSObject>

- (void)vedioAlert:(VHVideoAlert *)alert clickedButton:(UIButton *)sender index:(NSInteger)index;

@end



@interface VHVideoAlert : UIView


@property (nonatomic, weak) id <VHVideoAlertDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *iconImageView;


- (instancetype)initWithDelegate:(id <VHVideoAlertDelegate>)delegate tag:(NSInteger)tag title:(NSString *)title icon:(UIImage *)image;
- (void)show;


@property (nonatomic, strong) VCInteractiveMaskView *maskView;

@property (nonatomic, assign) BOOL exchangedEnable;

@end
