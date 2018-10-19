//
//  MMKeyBoardView.h
//  MMKeyBoard
//
//  Created by vhall on 2018/10/12.
//  Copyright © 2018年 vhall. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "MMTextFiled.h"

#define kMMChatKeyBoardSendButtonWidth 56

@class MMKeyBoardView;

@protocol MMKeyBoardViewDelegate <NSObject>

@optional

/**
 @brief 发送消息事件回调
 @param text 消息内容
 */
- (void)keyBoardView:(MMKeyBoardView *)view sendText:(NSString *)text;

/**
 @brief 键盘高度变化回调
 @param endHeight 键盘高度
 @param duration 动画时长
 @discussion 旋转屏幕时，iOS系统键盘会先hidden，然后再show，此方法会回调两次。
 */
- (void)keyBoardView:(MMKeyBoardView *)view keyBoardFrameChnage:(CGFloat)endHeight duration:(CGFloat)duration;

@end

@interface MMKeyBoardView : UIView

//键盘输入框
@property (nonatomic, strong) MMTextFiled *inputTextFiled;

@property (nonatomic, weak) id <MMKeyBoardViewDelegate>delegate;

@end
