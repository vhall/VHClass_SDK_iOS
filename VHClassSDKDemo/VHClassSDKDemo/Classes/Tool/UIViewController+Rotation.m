//
//  UIViewController+Rotation.m
//  xxx
//
//  Created by vhall on 2019/4/11.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "UIViewController+Rotation.h"
#import <objc/runtime.h>

static NSString const *kUIViewControllerRotationKey = @"UIViewControllerRotationKey";
static NSString const *kUIViewControllerAutoRotateKey = @"UIViewControllerAutoRotateKey";

//为了和系统的分类UIViewController (UIViewControllerRotation)冲突，分类命名为Rotation
@implementation UIViewController (Rotation)

- (void)setOrientation:(UIInterfaceOrientation)orientation {
    NSNumber *number = [NSNumber numberWithInteger:orientation];
    objc_setAssociatedObject(self, &kUIViewControllerRotationKey, number, OBJC_ASSOCIATION_RETAIN);//注意这里不能用OBJC_ASSOCIATION_ASSIGN
}
- (UIInterfaceOrientation)orientation {
    NSNumber *number = objc_getAssociatedObject(self, &kUIViewControllerRotationKey);
    if (number) {
        return [number integerValue];
    }
    return UIInterfaceOrientationPortrait;
}

- (void)setAutoRotate:(BOOL)autoRotate {
    NSNumber *number = [NSNumber numberWithBool:autoRotate];
    objc_setAssociatedObject(self, &kUIViewControllerAutoRotateKey, number, OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)autoRotate {
    NSNumber *number = objc_getAssociatedObject(self, &kUIViewControllerAutoRotateKey);
    if (number) {
        return [number boolValue];
    }
    return YES;
}

@end
