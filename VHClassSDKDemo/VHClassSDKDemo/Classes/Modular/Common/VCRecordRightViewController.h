//
//  VCRecordRightViewController.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/3/11.
//  Copyright © 2019 class. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RecordRightVCShowType) {
    RecordRightVCShowTypeDefault,
    RecordRightVCShowTypeDefination,
};

@protocol VCRecordRightViewControllerDelegate <NSObject>

@optional

//分辨率回调
- (void)selectedDefination:(NSInteger)defination defiStr:(NSString *)str;

//倍速回调
- (void)selectedRate:(NSInteger)rate rateStr:(NSString *)str;

@end


///选择分辨率/倍速
@interface VCRecordRightViewController : BaseViewController

@property (nonatomic, weak) id <VCRecordRightViewControllerDelegate> delegate;

@property (nonatomic, readonly) RecordRightVCShowType showType;

//切换显示
- (void)changedShowType:(RecordRightVCShowType)type;


//倍速设置成功
- (void)rateSetComplete:(NSString *)rateStr;
//分辨率设置完成
- (void)supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions curDefinition:(NSInteger)definition;

@end

NS_ASSUME_NONNULL_END
