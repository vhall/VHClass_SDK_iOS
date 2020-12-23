//
//  VHCDocBusinessViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/16.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCDocBusinessViewController.h"
#import <VHClassSDK/VHCDocumentView.h>

@interface VHCDocBusinessViewController ()

@property (nonatomic, strong) VHCDocumentView * docView;

@end

@implementation VHCDocBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
}

- (void)initViews
{
    self.docView.frame = self.view.bounds;
    [self.view insertSubview:self.docView atIndex:0];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    msgLabel.backgroundColor = [UIColor yellowColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.text = @"注意：直播时候才可观看此文档！";
    [self.view insertSubview:msgLabel aboveSubview:self.docView];
}

- (VHCDocumentView *)docView {
    if (!_docView) {
        _docView = [[VHCDocumentView alloc] init];
        _docView.docType = VCDocType_Live;
    }
    return _docView;
}

@end
