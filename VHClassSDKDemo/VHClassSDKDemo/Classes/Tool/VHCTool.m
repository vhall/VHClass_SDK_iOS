//
//  VHCTool.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/10.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHCTool.h"
#import "AppDelegate.h"

@implementation VHCTool

+ (void)showAlertWithMessage:(NSString *)message {
    if (!message || ![message isKindOfClass:[NSString class]]) {
        return;
    }
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIView *lastContentView = [app.window viewWithTag:93648234];
    if (lastContentView) {
        [lastContentView removeFromSuperview];
        lastContentView = nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    contentView.layer.cornerRadius = 3;
    contentView.layer.masksToBounds = YES;
    contentView.tag = 93648234;
    [app.window addSubview:contentView];
    
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.numberOfLines = 0;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.text = message;
    [contentView addSubview:alertLabel];
    
    if(message && message.length)
    {
        CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        
        CGFloat width = 0;
        if(size.width >  app.window.bounds.size.width-80)
        {
            width = app.window.bounds.size.width-80;//最大宽度
        }
        else
        {
            width = size.width;
        }
        
        CGRect rect = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                            options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesFontLeading |
                       NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                            context:nil];
        
        contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3*2);
        contentView.bounds = CGRectMake(0, 0, width+30, rect.size.height+20);
        contentView.layer.cornerRadius = (contentView.frame.size.height)*0.5;
        
        alertLabel.frame = CGRectMake(15, 10, width, rect.size.height);
    }
    
    [contentView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}

+ (NSString *)urlEncoded:(NSString*)str
{
    str = [NSString stringWithFormat:@"%@",str];
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}

+(BOOL)predicateCheck:(NSString *)str regex:(NSString*)regex
{
    NSPredicate *epredicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [epredicateTest evaluateWithObject:str];
}
+ (BOOL)isHaveEmoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return ![modifiedString isEqualToString:text];
}

+ (NSString *)disableEmoji:(NSString *)text
{
    if(text == nil) return nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    //    @"小明 ‍韓國米思納美品牌創始人"@"黄经纬 ‍太陽熊搬家™️"
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"‍"];
    modifiedString = [[modifiedString componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    return modifiedString;
}
//CGSizeMake(width, MAXFLOAT)
+(CGSize)calStrSize:(NSString*)str width:(CGFloat)width font:(UIFont*)font
{
    if(str == nil || font == nil)
        return CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize: CGSizeMake(width, MAXFLOAT)
                                    options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)
                                 attributes: attributes
                                    context: nil].size;
    return size;
}
//CGSizeMake(MAXFLOAT, MAXFLOAT)
+(CGSize)calStrSize:(NSString*)str font:(UIFont*)font
{
    if(str == nil || font == nil)
        return CGSizeZero;
    
    return [VHCTool calStrSize:str width:MAXFLOAT font:font];
    
    //    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    //    return size;
}
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font rangeSize:(CGSize)size {
    return [text boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                              context:nil];
}

@end
