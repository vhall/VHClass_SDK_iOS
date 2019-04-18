//
//  VCNavigationController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/16.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VCNavigationController.h"

@interface VCNavigationController ()

@end

@implementation VCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    return self.autoRotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return  UIInterfaceOrientationMaskAllButUpsideDown;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.orientation;
}

@end
