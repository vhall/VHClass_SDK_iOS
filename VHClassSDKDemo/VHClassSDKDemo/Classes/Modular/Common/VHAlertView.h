//
//  VHAlertView.h
//  VHiPad
//
//  Created by dry on 2018/5/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VHAlertView;


@protocol VHAlertViewDelegate <NSObject>

- (void)alertView:(VHAlertView *)alertView clickedButtonAtIndex:(NSInteger)index;

@end


@interface VHAlertView : UIView

@property (nonatomic ,strong) UIView *alert;
@property (nonatomic ,strong) UIButton *leftBtn;
@property (nonatomic ,strong) UIButton *rightBtn;

@property (nonatomic ,weak) id <VHAlertViewDelegate> delegate;

- (VHAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
                      delegate:(id)delegate
                           tag:(NSUInteger)tag
             cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitle:(NSString *)otherButtonTitle;
- (void)show;

@end

