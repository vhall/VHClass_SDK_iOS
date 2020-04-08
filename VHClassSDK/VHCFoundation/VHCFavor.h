//
//  VHCFavor.h
//  VHCFoundation
//
//  点赞
//  Created by vhall on 2019/9/25.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHCError.h"
NS_ASSUME_NONNULL_BEGIN

@interface VHCFavor : NSObject
+ (void)favorHostSucessed:(void(^)(NSDictionary *result))sucess failed:(void(^)(VHCError *error))failed;
+ (NSInteger)getFavorNum;
@end

NS_ASSUME_NONNULL_END
