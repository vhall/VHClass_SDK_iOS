//
//  VHinteractiveViewController.h
//
//  Created by vhall on 2018/7/30.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHCModularBaseViewController.h"

//上麦方式
typedef NS_ENUM(NSInteger,MicroType) {
    MicroTypeDefault, //默认为推视频+音频流
    MicroTypeOnlyVoice,//语音上麦
};

@interface VHinteractiveViewController : VHCModularBaseViewController

@property (nonatomic, assign) MicroType type;

@end
