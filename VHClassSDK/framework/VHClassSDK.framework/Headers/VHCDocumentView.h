//
//  VHCDocumentView.h
//  VHCDocuments
//
//  Created by 郭超 on 2020/7/1.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHCDocuments.h"

typedef NS_ENUM(NSInteger,VHCDrawAction) {
    VHCDrawAction_Add          = 1 ,   //添加画板元素 设置 VHDrawType 时会自动设置为此选项
    VHCDrawAction_Modify       = 2 ,   //选择后修改 画板元素
    VHCDrawAction_Delete       = 3 ,   //删除画板元素
};


typedef NS_ENUM(NSInteger,VHCDrawType) {
    VHCDrawType_Pen                  = 1 ,   //画笔
    VHCDrawType_Highlighter          = 2 ,   //荧光笔
    VHCDrawType_Rectangle            = 3 ,   //矩形
    VHCDrawType_Circle               = 4 ,   //圆
    VHCDrawType_Arrow                = 5 ,   //箭头 此版本暂不支持
    VHCDrawType_Text                 = 6 ,   //文字 此版本暂不支持
    VHCDrawType_Image                = 7 ,   //图片 此版本暂不支持
    VHCDrawType_Isosceles_Triangle   = 8 ,   //等腰三角形
    VHCDrawType_right_Triangle       = 9 ,   //直角三角形
    VHCDrawType_Single_Arrow         = 11 ,  //单箭头
    VHCDrawType_Double_Arrow         = 12 ,  //双箭头
};


NS_ASSUME_NONNULL_BEGIN
//文档类型
typedef NS_ENUM(NSInteger,VCDocType) {
    VCDocType_Live = 1,     //直播文档
    VCDocType_Vod,      //回放文档
};
//数据源
@protocol VHCDocumentViewDataSource <NSObject>

@required

//直播时，实现此数据源方法，传入直播延迟时间，进行视频和文档同步，直播播放器realBufferTime 参数
//互动时传 0
- (float)liveRealBufferTime;

@end

@protocol VHCDocumentViewDelegate <NSObject>

@optional

//文档事件回调
- (void)docEventType:(VHCDocEventType)type;

@end

@interface VHCDocumentView : UIView

@property (nonatomic, weak) id <VHCDocumentViewDelegate> delegate;

@property (nonatomic, weak) id <VHCDocumentViewDataSource> dataSource;

@property (nonatomic) VCDocType docType; //文档类型，可以通过set方法设置当前文档

@property (nonatomic, strong) UIScrollView *scrollView;//文档view 容器
//初始化
- (instancetype)initWithType:(VCDocType)type;

//清空文档数据和文档对象
- (void)destoryDocuments;

//回放时，通过调用此方法，传入当前回放播放器的播放进度，根据播放进度进行文档演示
- (void)setVodCurrentTime:(NSTimeInterval)currentTime;

//取消授权画笔
- (void)cancelBrushSuccess:(void(^)(void))success failure:(void(^)(VHCError *error))failure;

#pragma mark - 画笔
/*
 * 是否可以编辑 作为发起端 默认NO 不可编辑
 */
@property (nonatomic, assign) BOOL editEnable;
/*
 * 绘制命令类型
 */
- (void)setDrawAction:(VHCDrawAction)drawAction;

/*
 * 绘制类型
 * 注意：设置此参数时  editType 自动设置为 VHEditType_Add 模式
 */
- (void)setDrawType:(VHCDrawType)drawType;

/*
 * 设置绘制图形颜色
 */
- (void)setDrawColor:(UIColor*)color;

/*
 * 设置绘制图形线宽
 */
- (void)setDrawLineWidth:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
