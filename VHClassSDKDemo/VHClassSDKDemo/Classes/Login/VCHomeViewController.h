//
//  VCHomeViewController.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/1/15.
//  Copyright © 2019年 class. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCHomeViewController : BaseViewController

- (instancetype)initWithAppKey:(NSString *)appKey appSecretKey:(NSString *)secretKey;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
