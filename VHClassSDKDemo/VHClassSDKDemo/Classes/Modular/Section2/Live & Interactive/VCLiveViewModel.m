//
//  VCLiveViewModel.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/25.
//  Copyright © 2019 class. All rights reserved.
//

#import "VCLiveViewModel.h"

@interface VCLiveViewModel ()

@property (nonatomic, strong, readwrite) NSMutableArray *supportDefinations;
@property (nonatomic, assign, readwrite) NSInteger curDifination;

@end


@implementation VCLiveViewModel

- (NSMutableArray *)supportDefinations {
    if (!_supportDefinations) {
        _supportDefinations = [[NSMutableArray alloc] init];
    }
    return _supportDefinations;
}

- (void)updateSupportDefinations:(NSArray *)definations curDifination:(NSInteger)curDifinatin
{
    [self.supportDefinations removeAllObjects];
    [self.supportDefinations addObjectsFromArray:definations];
    self.curDifination = curDifinatin;
}

- (BOOL)isSupportDefinition:(NSInteger)defination {
    NSNumber *defi = [NSNumber numberWithInteger:defination];
    return [self.supportDefinations containsObject:defi];
}

@end
