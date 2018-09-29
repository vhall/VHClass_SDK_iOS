//
//  VHCDocuments.h
//  VHCDocuments
//
//  Created by vhall on 2018/9/17.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

///微吼课堂SDK文档&白板类，该类提供了文档和白板的添加、切换等功能。使用此模块功能时，请先确保当前已进入课堂！
@interface VHCDocuments : NSObject
/**
 @brief 文档&白板父视图view。
 */
@property (nonatomic, strong, readonly) UIView *documentDrawView;
/**
 @brief 展示文档延迟时间，默认为0
 @discussion 用于flash播放和看直播播放，相对时间保持一致性。如果文档功能和看直播功能一起使用，则需要实现数据源方法，传入播放器实际延迟时间，即realBufferTime。
 */
@property (nonatomic, assign) CGFloat delayTime;

@end
