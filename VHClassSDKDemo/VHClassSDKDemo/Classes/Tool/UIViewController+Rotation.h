//
//  UIViewController+Rotation.h
//  xxx
//
//  Created by vhall on 2019/4/11.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Rotation)

//是否支持重力感应 注意不要和系统的shouldAutorotate属性重名，以免覆盖系统提供的功能
@property (nonatomic) BOOL autoRotate;

//方向 注意尽量不要和系统的interfaceOrientation属性重名，以免覆盖系统提供的功能
@property (nonatomic) UIInterfaceOrientation orientation;

@end

NS_ASSUME_NONNULL_END
