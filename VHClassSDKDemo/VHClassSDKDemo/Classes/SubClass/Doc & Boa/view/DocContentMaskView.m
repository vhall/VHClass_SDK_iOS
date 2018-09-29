//
//  DocContentMaskView.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/21.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "DocContentMaskView.h"

@implementation DocContentMaskView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _toolBar.frame = CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40);
    _scrollView.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.documents.documentDrawView.frame = self.bounds;
        
        self.toolBar = [[DocToolBar alloc] init];
        
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.documents.documentDrawView];
        [self addSubview:self.toolBar];
    }
    return self;
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - UIScrollViewDelegate
//告诉scrollview要缩放的是哪个子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.documents.documentDrawView;
}
//
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if(scale <=1.0)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width+1,scrollView.frame.size.height+1);
}
//
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.documents.documentDrawView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                                         scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - frame observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"frame" isEqualToString:keyPath]) return;
    
    self.documents.documentDrawView.frame = self.scrollView.bounds;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width+1,_scrollView.frame.size.height+1);
}

#pragma mark - lazy load
- (VHCDocuments *)documents {
    if (!_documents) {
        _documents = [[VHCDocuments alloc] init];
    }
    return _documents;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView setContentMode:UIViewContentModeScaleAspectFit];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 1;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width+1,_scrollView.frame.size.height+1);
        _scrollView.backgroundColor = [UIColor blackColor];
        [_scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _scrollView;
}

@end
