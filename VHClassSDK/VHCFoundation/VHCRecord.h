//
//  VHCRecord.h
//  VHCFoundation
//
//  Created by vhall on 2019/3/11.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHClassBaseInfo.h"
#import "VHCError.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VHCRecordType) {
    VHCRecordTypeDefault = 1,   //回放
    VHCRecordTypeVideo,         //音视频
};

@interface VHCRecord : VHClassBaseInfo

@property (nonatomic) VHCRecordType recordType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *record_webinar_id;
@property (nonatomic, assign) VHClassType resource_course_type;

@property (nonatomic, copy) NSString *vod_id;//音视频id
@property (nonatomic, copy) NSString *play_url;//播放地址
@property (nonatomic, assign) VHCActivityType play_type;
/**
 进入录播课堂  异步函数
 
 */
+ (void)enterRecoredClassWebinar_id:(NSString *)webinar_id joinId:(NSString *)joinId sucess:(void(^)(VHCRecord *record))sucess
                         failed:(void(^)(VHCError *error))failed;

@end

NS_ASSUME_NONNULL_END
