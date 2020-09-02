//
//  VHCDocumentView.h
//  VHCDocuments
//
//  Created by 郭超 on 2020/7/1.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHCDocuments.h"

NS_ASSUME_NONNULL_BEGIN
//文档类型
typedef NS_ENUM(NSInteger,VCDocType) {
    VCDocType_Live = 1,     //直播文档
    VCDocType_Vod,      //回放文档
};
//数据源
@protocol VHCDocumentViewDataSource <NSObject>

@required

//直播时，实现此数据源方法，传入直播延迟时间，进行视频和文档同步
- (NSInteger)liveRelaBufferTime;

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

//初始化
- (instancetype)initWithType:(VCDocType)type;

//清空文档数据和文档对象
- (void)destoryDocuments;

//回放时，通过调用此方法，传入当前回放播放器的播放进度，根据播放进度进行文档演示
- (void)setVodCurrentTime:(NSTimeInterval)currentTime;

@end

NS_ASSUME_NONNULL_END
