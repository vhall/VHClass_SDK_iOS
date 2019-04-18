//
//  VHCDocBusinessViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/16.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCDocBusinessViewController.h"
#import "VHCDocumentViewController.h"

@interface VHCDocBusinessViewController ()

@property (nonatomic, strong) VHCDocumentViewController *docVc;

@end

@implementation VHCDocBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
}

- (void)initViews
{
    self.docVc.view.frame = self.view.bounds;
    [self.view insertSubview:self.docVc.view atIndex:0];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    msgLabel.backgroundColor = [UIColor yellowColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.text = @"注意：直播时候才可观看此文档！";
    [self.view insertSubview:msgLabel aboveSubview:self.docVc.view];
}

- (VHCDocumentViewController *)docVc {
    if (!_docVc) {
        _docVc = [[VHCDocumentViewController alloc] init];
        _docVc.docType = VCDocType_Live;
    }
    return _docVc;
}

@end
