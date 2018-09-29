//
//  MMKeyBoardInputView.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "MMKeyBoardInputView.h"

//状态栏+导航栏 高度
#define kNavigationBarHeight (kIsIphoneX ? 88 : 64)
//判断是否有“齐刘海”
#define kIsIphoneX ([UIScreen mainScreen].bounds.size.width == 375.f && [UIScreen mainScreen].bounds.size.height == 812.f ? YES : NO)

@interface MMKeyBoardInputView ()<UITextFieldDelegate>
{
    CGRect _selfFrame;
}
//背景view
@property (nonatomic, strong) UIView *backView;
//发送按钮
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation MMKeyBoardInputView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backView.frame = self.bounds;
    self.inputTextFiled.frame = CGRectMake(8, 1, self.backView.frame.size.width-16-4-kMMChatKeyBoardSendButtonWidth, 36);
    self.sendButton.frame = CGRectMake(self.backView.frame.size.width-8-kMMChatKeyBoardSendButtonWidth, 1, kMMChatKeyBoardSendButtonWidth, 36);
    
    _selfFrame = self.frame;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        
        [self addSubview:self.backView];
        
        [self.backView addSubview:self.inputTextFiled];
        
        [self.backView addSubview:self.sendButton];
        
        //键盘出现监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //键盘将要隐藏监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text && textField.text.length >0) {
        
        //键盘发送按钮事件回调
        [self sendMsg:textField.text];
        
        return YES;
    }
    return NO;
}

#pragma mark - 键盘监听
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat keyboardHeight = endFrame.size.height;
    //键盘的动画时长
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //执行动画
    [UIView animateWithDuration:duration delay:0 options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        
        CGRect selfFrme = self.frame;
        selfFrme.origin.y = [UIScreen mainScreen].bounds.size.height-keyboardHeight-self.frame.size.height-kNavigationBarHeight;
        self.frame = selfFrme;
        
    } completion:nil];
    //回调
    [self keyBoardHeight:keyboardHeight duration:duration];
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //键盘高度
    CGFloat keyboardHeight = endFrame.size.height;
    //键盘的动画时长
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //执行动画
    [UIView animateWithDuration:duration delay:0 options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        
        self.frame = self->_selfFrame;
        
    } completion:nil];
    //回调
    [self keyBoardHeight:keyboardHeight duration:duration];
}

//发送按钮点击事件
- (void)sendeButtonClick:(UIButton *)sendeBtn
{
    if (_inputTextFiled.text && _inputTextFiled.text.length >0)
    {
        [self sendMsg:_inputTextFiled.text];
    }
}

//发送消息回调
- (void)sendMsg:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(keyBoardInputView:sendText:)]) {
        [self.delegate keyBoardInputView:self sendText:text];
    }
}
//键盘高度变化回调
- (void)keyBoardHeight:(CGFloat)height duration:(CGFloat)duration {
    if ([self.delegate respondsToSelector:@selector(keyBoardInputView:keyBoardFrameChnage:duration:)]) {
        [self.delegate keyBoardInputView:self keyBoardFrameChnage:height duration:duration];
    }
}

#pragma mark - 懒加载
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
    }
    return _backView;
}
- (MMTextFiled *)inputTextFiled {
    if (!_inputTextFiled) {
        _inputTextFiled = [[MMTextFiled alloc] init];
        _inputTextFiled.font = [UIFont systemFontOfSize:16.0];
        _inputTextFiled.layer.cornerRadius = 4;
        _inputTextFiled.layer.borderWidth = 1;
        _inputTextFiled.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        _inputTextFiled.delegate = self;
        _inputTextFiled.returnKeyType = UIReturnKeySend;
    }
    return _inputTextFiled;
}
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.layer.cornerRadius = 4;
        _sendButton.backgroundColor = [UIColor colorWithHex:@"52cc90"];
        [_sendButton addTarget:self action:@selector(sendeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


@end
