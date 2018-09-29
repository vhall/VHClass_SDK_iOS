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


@end
