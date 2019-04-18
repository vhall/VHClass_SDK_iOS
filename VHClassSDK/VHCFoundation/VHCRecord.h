//
//  VHCRecord.h
//  VHCFoundation
//
//  Created by vhall on 2019/3/11.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHClassBaseInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VHCRecordType) {
    VHCRecordTypeDefault = 1,   //回放
    VHCRecordTypeVideo,         //音视频
};

@interface VHCRecord : VHClassBaseInfo

@property (nonatomic) VHCRecordType recordType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *recordId;//音视频id

/**
 进入录播课堂  异步函数
 
 */
+ (void)enterRecoredClassSucess:(void(^)(VHCRecord *record))sucess
                         failed:(void(^)(VHCError *error))failed;

@end

NS_ASSUME_NONNULL_END
