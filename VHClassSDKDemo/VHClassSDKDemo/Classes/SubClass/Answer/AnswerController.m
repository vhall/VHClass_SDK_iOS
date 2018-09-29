//
//  AnswerController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/4.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "AnswerController.h"

@interface AnswerController ()

@end

@implementation AnswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VHClassSDKDelegate
- (void)vhclass:(VHClassSDK *)sdk classStateDidChanged:(VHClassState)curState
{
    switch (curState) {
        case VHClassStateClassOn:
            [VHCTool showAlertWithMessage:@"上课了!"];
            break;
        case VHClassStatusClassOver:
            [VHCTool showAlertWithMessage:@"下课了!"];
            break;
        default:
            break;
    }
}

- (void)vhclass:(VHClassSDK *)sdk userEventChanged:(VHCUserEvent)curEvent
{
    
}

@end
