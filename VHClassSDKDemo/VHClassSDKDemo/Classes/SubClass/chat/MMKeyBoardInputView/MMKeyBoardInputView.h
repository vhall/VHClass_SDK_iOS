//
//  MMKeyBoardInputView.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMTextFiled.h"

#define kMMChatKeyBoardSendButtonWidth 56

@class MMKeyBoardInputView;

@protocol MMKeyBoardInputViewDelegate <NSObject>

@optional

/**
 @brief 发送消息事件回调
 @param text 消息内容
 */
- (void)keyBoardInputView:(MMKeyBoardInputView *)inputView sendText:(NSString *)text;

/**
 @brief 键盘高度变化回调
 @param endHeight 键盘高度
 @param duration 动画时长
 */
- (void)keyBoardInputView:(MMKeyBoardInputView *)keyBoard keyBoardFrameChnage:(CGFloat)endHeight duration:(CGFloat)duration;

@end

@interface MMKeyBoardInputView : UIView

//键盘输入框
@property (nonatomic, strong) MMTextFiled *inputTextFiled;

@property (nonatomic, weak) id <MMKeyBoardInputViewDelegate>delegate;

@end
