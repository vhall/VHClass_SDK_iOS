//
//  VHCTool.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/10.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHCTool : NSObject

+ (void)showAlertWithMessage:(NSString *)message;

+ (NSString *)urlEncoded:(NSString*)str;
+(BOOL)predicateCheck:(NSString *)str regex:(NSString*)regex;

//字符串中是否包含表情符号
+ (BOOL)isHaveEmoji:(NSString *)text;
//去掉字符串中的表情符号
+ (NSString *)disableEmoji:(NSString *)text;

//计算字符串所占区域大小
+(CGSize)calStrSize:(NSString*)str width:(CGFloat)width font:(UIFont*)font;//CGSizeMake(width, MAXFLOAT)
+(CGSize)calStrSize:(NSString*)str font:(UIFont*)font;//CGSizeMake(MAXFLOAT, MAXFLOAT)
//计算文字大小
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font rangeSize:(CGSize)size;

@end
