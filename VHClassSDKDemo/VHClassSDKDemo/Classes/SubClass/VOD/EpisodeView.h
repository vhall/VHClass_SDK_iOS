//
//  EpisodeView.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/20.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeView : UIView

@property (nonatomic, copy) void ((^SelectedIndex)(NSUInteger index));

- (void)resetWithTitles:(NSArray *)titles;

- (void)show;
- (void)hidden;

@end
