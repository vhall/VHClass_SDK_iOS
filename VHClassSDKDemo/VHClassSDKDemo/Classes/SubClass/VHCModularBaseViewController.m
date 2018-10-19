//
//  VHCModularBaseViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHCModularBaseViewController.h"
#import "VHClassSDK.h"

@interface VHCModularBaseViewController ()

@end

@implementation VHCModularBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [VHClassSDK sharedSDK].delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)vhclass:(VHClassSDK *)sdk classStateDidChanged:(VHClassState)curState
{
    
}

- (void)vhclass:(VHClassSDK *)sdk userEventChanged:(VHCUserEvent)curEvent
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
