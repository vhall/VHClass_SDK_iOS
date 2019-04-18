//
//  VHCDocumentViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/4/8.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCDocumentViewController.h"
#import "VHCDocuments.h"

@interface VHCDocumentViewController ()<UIScrollViewDelegate,VHCDocumentsDataSource,VHCDocumentsDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong, nullable) VHCDocuments *documents;

@end

@implementation VHCDocumentViewController

- (void)dealloc {
    //[_scrollView removeObserver:self forKeyPath:@"frame"];//Crash 什么鬼？

    [self destoryDocuments];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.documents.documentDrawView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    self.documents.documentDrawView.frame = self.scrollView.bounds;
}

#pragma mark - public
//回放时，通过调用此方法，传入当前回放播放器的播放进度，根据播放进度进行文档演示
- (void)setVodCurrentTime:(NSTimeInterval)currentTime
{
    [_documents queryTime:currentTime seek:NO];
}

- (void)setDocType:(VCDocType)docType {
    if (_docType == docType) {
        return;
    }
    
    //注意：此处两行代码顺序不可颠倒，否则将无法创建文档
    [self destoryDocuments];
    _docType = docType;
    
    switch (_docType) {
        case VCDocType_Live:
        {
            self.documents = [[VHCDocuments alloc] initWithType:VHCDocumentsType_Live];
            self.documents.dataSource = self;
            self.documents.delegate = self;
        }
            break;
        case VCDocType_Vod:
        {
            self.documents = [[VHCDocuments alloc] initWithType:VHCDocumentsType_VOD];
            self.documents.delegate = self;
        }
            break;
    }
    
    self.documents.documentDrawView.frame = self.scrollView.bounds;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.documents.documentDrawView];
}

//注意：调用此方法需注意，防止调用后_docType被修改后创建文档不成功问题
- (void)destoryDocuments {
    [self.documents destoryDocments];
    self.documents = nil;
    _docType = 0;//勿删
}

#pragma mark - VHCDocumentsDataSource
- (NSInteger)documentsForLiveRealBufferTime:(VHCDocuments *)doc {
    if ([self.dataSource respondsToSelector:@selector(docVcliveRelaBufferTime)]) {
        return [self.dataSource docVcliveRelaBufferTime];
    }
    return 0;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.documents.documentDrawView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if(scale <=1.0)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width+1,scrollView.frame.size.height+1);
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.documents.documentDrawView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                                         scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        self.documents.documentDrawView.frame = self.scrollView.bounds;
        self.scrollView.zoomScale = 1.0;
        self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width+1,_scrollView.frame.size.height+1);
    }
}

#pragma mark - VHCDocumentsDelegate
- (void)documents:(VHCDocuments *)doc docEventType:(VHCDocEventType)type {
    //关闭文档
    if (type == VHCDocEventType_Over)
    {
        
    }
    else
    {
        
    }
}


#pragma mark - lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView setContentMode:UIViewContentModeScaleAspectFit];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 1;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width+1,_scrollView.frame.size.height+1);
        _scrollView.backgroundColor = [UIColor clearColor];
        //[_scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];//Crash ？
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
