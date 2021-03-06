//
//  VHCDocuments.h
//  VHCDocuments
//
//  Created by vhall on 2018/9/17.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VHCDocuments;

typedef NS_ENUM(NSInteger,VHCDocumentsType) {
    VHCDocumentsType_Live,
    VHCDocumentsType_VOD,
};

//文档事件类型
typedef NS_ENUM(NSInteger,VHCDocEventType) {
    VHCDocEventType_Flip,       //ppt翻页
    VHCDocEventType_Paint_Doc,  //ppt画笔
    VHCDocEventType_Paint_Board,//白板画笔
    VHCDocEventType_Over,       //关闭文档
};

@protocol VHCDocumentsDataSource <NSObject>

/**
 直播时使用文档需要实现该数据源，传入直播播放器的实际延迟时间，作用是文档和视频同步。
 注意单位：秒
 */
- (float)documentsForLiveRealBufferTime:(VHCDocuments *)doc;

@end


@protocol VHCDocumentsDelegate <NSObject>

@optional

//文档事件回调
- (void)documents:(VHCDocuments *)doc docEventType:(VHCDocEventType)type;

@end


///微吼课堂SDK文档&白板类，该类提供了文档和白板的添加、切换等功能。使用此模块功能时，请先确保当前已进入课堂！
@interface VHCDocuments : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(VHCDocumentsType)type delegate:(id <VHCDocumentsDelegate>)delegate dataSource:(id <VHCDocumentsDataSource>)dataSource;
- (void)destoryDocments;

@property (nonatomic, weak) id <VHCDocumentsDataSource> dataSource;

@property (nonatomic, weak) id <VHCDocumentsDelegate> delegate;

/**
 @brief 文档&白板父视图view。
 */
@property (nonatomic, strong, readonly) UIView *documentDrawView;

/**
 更新paas doc的 frame
 */
- (void)docFrame:(CGRect)docFrame;

/**
 @brief 回放 按时间查询绘制信息
 time 查询时间
 isSeek 是否seek time 之前全部信息 否则返回 time之前一秒的信息
 */
- (void)queryTime:(CGFloat)time seek:(BOOL)isSeek;

#pragma mark - 画笔
/*
 * 是否可以编辑 作为发起端 默认NO 不可编辑
 */
@property (nonatomic, assign) BOOL editEnable;
/*
 * 绘制命令类型
 */
- (void)setDrawAction:(int)drawAction;

/*
 * 绘制类型
 * 注意：设置此参数时  editType 自动设置为 VHEditType_Add 模式
 */
- (void)setDrawType:(int)drawType;

/*
 * 设置绘制图形颜色
 */
- (void)setDrawColor:(UIColor*)color;

/*
 * 设置绘制图形线宽
 */
- (void)setDrawLineWidth:(NSInteger)size;
@end
