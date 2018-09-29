//
//  VHCModularBaseViewController.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "BaseViewController.h"
#import "VHClassSDK.h"

///子界面的父类，此类遵守了VHClassSDKDelegate协议，该协议中有对课堂状态和用户主要行为的代理回调。
@interface VHCModularBaseViewController : BaseViewController <VHClassSDKDelegate>


@end
