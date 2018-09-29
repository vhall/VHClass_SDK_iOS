//
//  DocAndBoardController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/4.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "DocAndBoardController.h"
#import "DocContentView.h"

@interface DocAndBoardController ()

@property (nonatomic, strong) DocContentView *docContentView;

@end

@implementation DocAndBoardController

- (void)dealloc {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initViews];
}

- (void)initViews
{
    [self.view addSubview:self.docContentView];
}


#pragma mark - lazy load
- (DocContentView *)docContentView {
    if (!_docContentView) {
        _docContentView = [[DocContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    }
    return _docContentView;
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
