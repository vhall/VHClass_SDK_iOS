//
//  VCLiveViewModel.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/25.
//  Copyright © 2019 class. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCLiveViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *supportDefinations;
@property (nonatomic, assign, readonly) NSInteger curDifination;

- (void)updateSupportDefinations:(NSArray *)definations curDifination:(NSInteger)curDifinatin;

- (BOOL)isSupportDefinition:(NSInteger)defination;

@end

NS_ASSUME_NONNULL_END
