//
//  VHCDocumentViewController.h
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/8.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCModularBaseViewController.h"

@class VHCDocumentViewController;

NS_ASSUME_NONNULL_BEGIN

//文档类型
typedef NS_ENUM(NSInteger,VCDocType) {
    VCDocType_Live = 1,     //直播文档
    VCDocType_Vod,      //回放文档
};


@protocol VHCDocumentViewControllerDataSource <NSObject>

@required

@optional
//直播时实现此协议方法，传入直播延迟时间
- (NSInteger)docVcliveRelaBufferTime;

@end


@interface VHCDocumentViewController : VHCModularBaseViewController

@property (nonatomic, weak) id <VHCDocumentViewControllerDataSource> dataSource;

@property (nonatomic) VCDocType docType;//文档类型，可以通过set方法设置当前文档，默认为直播文档

//清空文档数据和文档对象
- (void)destoryDocuments;

//回放时，通过调用此方法，传入当前回放播放器的播放进度，根据播放进度进行文档演示
- (void)setVodCurrentTime:(NSTimeInterval)currentTime;

@end

NS_ASSUME_NONNULL_END
