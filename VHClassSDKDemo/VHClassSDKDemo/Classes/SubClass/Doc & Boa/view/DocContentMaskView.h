//
//  DocContentMaskView.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/21.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocToolBar.h"
#import "VHCDocuments.h"
#import "DocContentMaskView.h"

@interface DocContentMaskView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) VHCDocuments *documents;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) DocToolBar *toolBar;

@end
