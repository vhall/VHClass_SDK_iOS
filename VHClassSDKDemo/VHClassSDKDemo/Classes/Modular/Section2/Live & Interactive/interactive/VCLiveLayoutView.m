//
//  VCLiveLayoutView.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/19.
//  Copyright © 2019 class. All rights reserved.
//

#import "VCLiveLayoutView.h"
#import "VCInteractiveMaskView.h"
#import "VHCameraAlert.h"
#import "VHVideoAlert.h"
#import "VHCInteractiveRoom.h"

@interface VHLayoutItem : NSObject

@property (nonatomic, weak)     UIView *view;//对应的view
@property (nonatomic, assign)   BOOL isMain;
@property (nonatomic, assign)   AddViewType type;
@property (nonatomic, weak)     UITapGestureRecognizer *tapGes;
@property (nonatomic, weak)     UIPanGestureRecognizer *panGes;

@end

@implementation VHLayoutItem

- (instancetype)initWithView:(UIView *)view type:(AddViewType)type {
    if (self = [super init]) {
        _view = view;
        _type = type;
    }
    return self;
}



@end


@interface VCLiveLayoutView ()<VHCameraAlertDelegate,VHVideoAlertDelegate>

@property (nonatomic, assign) ViewLayoutType layoutType;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *items;

@end


@implementation VCLiveLayoutView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateUI];
}


- (instancetype)initWithFrame:(CGRect)frame layoutType:(ViewLayoutType)type {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor(51, 52, 56, 1);
        
        _layoutType = type;
        _items = [[NSMutableArray alloc] init];
        
        [_items addObject:[[VHLayoutItem alloc] initWithView:nil type:AddViewTypeHost]];
        [_items addObject:[[VHLayoutItem alloc] initWithView:nil type:AddViewTypeOwn]];
        
        if (_layoutType == ViewLayoutType1vN) {
            [self addSubview:self.scrollView];
        }
    }
    return self;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.height-70, self.width, 70)];
        _scrollView.backgroundColor = UIColor(38, 39, 43, 1);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

#pragma mark - public
- (void)addView:(UIView *)view type:(AddViewType)type {
    if ([self.subviews containsObject:view] || !view) {
        return;
    }
    
    //添加点击手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];
    [view addGestureRecognizer:tapGes];
    
    UIPanGestureRecognizer *panGes = nil;
    if (_layoutType == ViewLayoutType1v1) {
        //添加拖动手势
        panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
        [view addGestureRecognizer:panGes];
    }

    switch (type) {
        case AddViewTypeOther:
        {
            VHLayoutItem *item = [[VHLayoutItem alloc] initWithView:view type:type];
            item.tapGes = tapGes;
            item.panGes = panGes;
            item.isMain = NO;
            [_items addObject:item];
        }
            break;
        case AddViewTypeHost:
        {
            for (VHLayoutItem *item in _items) {
                if (item.type == AddViewTypeHost) {
                    item.view = view;
                    item.isMain = YES;
                    item.tapGes = tapGes;
                    item.panGes = panGes;
                }
                else {
                    item.isMain = NO;
                }
            }
        }
            break;
        case AddViewTypeShared:
        {
            VHLayoutItem *item = [[VHLayoutItem alloc] initWithView:view type:type];
            item.view = view;
            item.isMain = NO;
            item.tapGes = tapGes;
            item.panGes = panGes;
            [_items insertObject:item atIndex:0];
        }
            break;
        case AddViewTypeOwn:
        {
            for (VHLayoutItem *item in _items) {
                if (item.type == AddViewTypeOwn) {
                    item.view = view;
                    item.isMain = NO;
                    item.tapGes = tapGes;
                    item.panGes = panGes;
                    break;
                }
            }
        }
            break;
    }
    
    [self updateUI];
}
- (void)removeView:(UIView *)view
{
    BOOL isMainItem = NO;
    VHLayoutItem *viewItem = nil;
    for (VHLayoutItem *item in self.items)
    {
        if ([item.view isEqual:view])
        {
            viewItem = item;
            if (item.isMain)
            {
                isMainItem = YES;
            }
            break;
        }
    }
    
    //释放item对应的view
    viewItem.view = nil;
    
    //讲师和自己的item是不移除的
    if (viewItem.type == AddViewTypeOther || viewItem.type == AddViewTypeShared)
    {
        [self.items removeObject:viewItem];
    }
    
    //如果移除的是主位视图，则设置新的主位视图
    if (isMainItem) {
        VHLayoutItem *mainItem = self.items[0];
        mainItem.isMain = YES;
    }
    
    //将该视图从父视图上移除
    [view removeFromSuperview];
    
    [self updateUI];
}
- (void)removAllViews {
    for (VHLayoutItem *item in _items) {
        [item.view removeFromSuperview];
    }
    [_items removeAllObjects];
}

- (void)room:(VHCInteractiveRoom *)room liveUser:(NSString *)joinId micphoneStatusChanged:(BOOL)isClose byUser:(NSString *)byUserId
{
    //全体禁音/取消全体禁音
    if (!joinId)
    {
        for (VHLayoutItem *item in _items)
        {
            VCInteractiveMaskView *maskView = [item.view viewWithTag:VCInteractiveVideoMaskViewTag];
            VCInteractor *tor = maskView.actor;
            //全体禁音不针对讲师
            if (tor.userRole != VHCLiveUserRoleHost) {
                tor.allCloseAudio = isClose;
                [maskView updateUI];
            }
        }
        return;
    }
    
    
    for (VHLayoutItem *item in _items)
    {
        VCInteractiveMaskView *maskView = [item.view viewWithTag:VCInteractiveVideoMaskViewTag];
        VCInteractor *tor = maskView.actor;
        if ([tor.joinId isEqualToString:joinId]) {
            tor.micphoneClose = isClose;
            [maskView updateUI];
            //break;//这里不break的原因是，当讲师自己静音时，需要设置共享桌面和讲师画面同时静音
        }
    }
}
- (void)liveUser:(NSString *)joinId cameraStatusChanged:(BOOL)isClose byUser:(NSString *)byUserId
{
    for (VHLayoutItem *item in _items)
    {
        if (item.type != AddViewTypeShared)
        {
            VCInteractiveMaskView *maskView = [item.view viewWithTag:VCInteractiveVideoMaskViewTag];
            VCInteractor *tor = maskView.actor;
            if ([tor.joinId isEqualToString:joinId]) {
                tor.cameraClose = isClose;
                [maskView updateUI];
                break;
            }
        }
    }
}

- (void)changeMainViewWithMaskView:(UIView *)renderView
{
    for (VHLayoutItem *item in _items) {
        item.isMain = [item.view isEqual:renderView];
    }
    [self updateUI];
}

- (void)setDocView:(UIView *)docView {
    _docView = docView;
    
    if (_docView)
    {
        for (VHLayoutItem *item in _items) {
            item.isMain = NO;
        }
        [self addSubview:docView];
    }
    else
    {
        for (VHLayoutItem *item in _items) {
            if (item.type == AddViewTypeHost) {
                item.isMain = YES;
                break;
            }
        }
    }
    
    [self updateUI];
}

#pragma mark - private
- (void)updateUI {
    switch (_layoutType)
    {
        case ViewLayoutType1v1:
        {
            [self update1v1UI];
        }
            break;
        case ViewLayoutType1vN:
        {
            [self update1vNUI];
        }
            break;
    }
}

- (void)update1v1UI
{
    //大课堂（1v1） 横屏布局
    //视频布局 主画面是讲师画面，次画面是自己画面，在又下角，自己画面可拖动
    //文档布局 主画面是文档，其他画面在右侧依次排列
    if (SCREEN_WIDTH > SCREEN_HEIGHT)
    {
        //文档布局
        if (_docView)
        {
            _docView.frame = CGRectMake(0, 0, self.width-107, self.height);
            
            self.scrollView.frame = CGRectMake(self.width-107, 0, 107, self.height);
            self.scrollView.contentSize = CGSizeMake(0, _items.count*80);
            [self.scrollView setContentOffset:CGPointMake(0, (_items.count*80 - self.height) * 0.5)];
            [self addSubview:self.scrollView];
            
            for (int i = 0; i < _items.count; i++)
            {
                VHLayoutItem *item = self.items[i];
                UIView *view = item.view;
                if (view)
                {
                    view.frame = CGRectMake(0, i*80, 107, 80);
                    [self.scrollView addSubview:view];
                    
                    item.tapGes.enabled = YES;
                    item.panGes.enabled = NO;

                    //设置蒙层布局
                    UIView *maskView = [view viewWithTag:VCInteractiveVideoMaskViewTag];
                    maskView.frame = view.bounds;
                }
            }
        }
        //视频布局
        else
        {
            int index = 1;
            for (int i = 0; i < _items.count; i++)
            {
                VHLayoutItem *item = self.items[i];
                UIView *view = item.view;
                if (view)
                {
                    if (item.isMain == YES)
                    {
                        view.frame = self.bounds;
                        item.tapGes.enabled = NO;
                        item.panGes.enabled = NO;
                        [self insertSubview:view atIndex:0];
                    }
                    else
                    {
                        view.frame = CGRectMake(self.width-130*index, self.height-97, 130, 97);
                        item.tapGes.enabled = YES;
                        item.panGes.enabled = NO;
                        [self addSubview:view];
                        [self bringSubviewToFront:view];
                        index++;
                    }
                    //设置蒙层布局
                    UIView *maskView = [view viewWithTag:VCInteractiveVideoMaskViewTag];
                    maskView.frame = view.bounds;
                }
            }
        }
    }
    
    //大课堂（1v1）竖屏布局
    //视频布局 主画面是讲师画面，次画面是自己画面，在右下角，自己画面可拖动
    //文档布局 竖屏时文档在“讲台”上，所以和视频布局一样
    else
    {
        int index = 1;
        for (int i = 0; i < _items.count; i++)
        {
            VHLayoutItem *item = self.items[i];
            UIView *view = item.view;
            if (view)
            {
                if (item.isMain == YES)
                {
                    view.frame = self.bounds;
                    item.tapGes.enabled = NO;
                    item.panGes.enabled = NO;
                    [self insertSubview:view atIndex:0];
                }
                else
                {
                    view.frame = CGRectMake(self.width-94*index, self.height-70, 94, 70);
                    item.tapGes.enabled = YES;
                    item.panGes.enabled = NO;
                    [self addSubview:view];
                    [self bringSubviewToFront:view];
                    index++;
                }
                //设置蒙层布局
                UIView *maskView = [view viewWithTag:VCInteractiveVideoMaskViewTag];
                maskView.frame = view.bounds;
            }
        }
    }
}
- (void)update1vNUI
{
    //横屏布局
    if (SCREEN_WIDTH > SCREEN_HEIGHT)
    {
        self.scrollView.frame = CGRectMake(self.width-107, 0, 107, self.height);
        
        //文档布局
        if (_docView)
        {
            _docView.frame = CGRectMake(0, 0, self.width-107, self.height);

            for (int i = 0; i < _items.count; i++)
            {
                VHLayoutItem *item = self.items[i];
                UIView *view = item.view;
                if (view)
                {
                    view.frame = CGRectMake(0, i*80, 107, 80);
                    item.tapGes.enabled = YES;
                    item.panGes.enabled = NO;
                    [self.scrollView addSubview:view];
                    
                    //设置蒙层布局
                    UIView *maskView = [view viewWithTag:VCInteractiveVideoMaskViewTag];
                    maskView.frame = view.bounds;
                }
            }

            self.scrollView.contentSize = CGSizeMake(0, _items.count*80);
            self.scrollView.contentOffset = CGPointMake(0, (_items.count*80 - self.height) * 0.5);
        }
        //视频布局
        else
        {
            int index = 0;
            for (int i = 0; i < _items.count; i++)
            {
                VHLayoutItem *item = self.items[i];
                UIView *view = item.view;
                if (view)
                {
                    if (item.isMain)
                    {
                        view.frame = CGRectMake(0, 0, self.width-107, self.height);
                        item.tapGes.enabled = NO;
                        item.panGes.enabled = NO;
                        [self addSubview:view];
                    }
                    else
                    {
                        view.frame = CGRectMake(0, index*80, 107, 80);
                        item.tapGes.enabled = YES;
                        item.panGes.enabled = NO;
                        [self.scrollView addSubview:view];
                        index++;
                    }
                    //设置蒙层布局
                    UIView *maskView = [view viewWithTag:VCInteractiveVideoMaskViewTag];
                    maskView.frame = view.bounds;
                }
            }
            
            self.scrollView.contentSize = CGSizeMake(0, (_items.count-1)*80);
            self.scrollView.contentOffset = CGPointMake(0, ((_items.count-1)*80 - self.height) * 0.5);
        }
    }
    //竖屏布局
    else
    {
        self.scrollView.frame = CGRectMake(0, self.height-70, self.width, 70);
        
        int index = 0;
        for (int i = 0; i < _items.count; i++)
        {
            VHLayoutItem *item = self.items[i];
            UIView *view = item.view;
            if (view)
            {
                if (item.isMain)
                {
                    view.frame = CGRectMake(0, 0, self.width, self.height-70);
                    item.tapGes.enabled = NO;
                    item.panGes.enabled = NO;
                    [self addSubview:view];
                }
                else
                {
                    view.frame = CGRectMake(index*94, 0, 94, 70);
                    item.tapGes.enabled = YES;
                    item.panGes.enabled = NO;
                    [self.scrollView addSubview:view];
                    index++;
                }
                //设置蒙层布局
                UIView *maskView = [view viewWithTag:VCInteractiveVideoMaskViewTag];
                maskView.frame = view.bounds;
            }
        }
        
        self.scrollView.contentSize = CGSizeMake((_items.count-1)*94, 0);
        self.scrollView.contentOffset = CGPointMake((_items.count-1)*94*0.5-self.width*0.5, 0);
    }
}






- (void)tapGesAction:(UITapGestureRecognizer *)tapGes
{
    UIView *view = tapGes.view;
    if (view.width >= [UIScreen mainScreen].bounds.size.width*0.5)
    {
        return;
    }
    
    VCInteractiveMaskView *maskView = [view viewWithTag:VCInteractiveVideoMaskViewTag];
    VCInteractor *actor = maskView.actor;
    
    if (actor.joinId == [VCCourseData shareInstance].joinId)
    {
        VHCameraAlert *alert = [[VHCameraAlert alloc] initWithDelegate:self title:actor.nickName];
        [alert setMaskView:maskView];
        [alert setExchangedEnable:(_docView)?NO:YES];
        [alert show];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"学员"];
        if (actor.userRole == VHCLiveUserRoleHelper) {
            image = [UIImage imageNamed:@"助教"];
        } else if (actor.userRole == VHCLiveUserRoleGuest) {
            image = [UIImage imageNamed:@"嘉宾"];
        } else if (actor.userRole == VHCLiveUserRoleHost) {
            image = [UIImage imageNamed:@"讲师"];
        }
        VHVideoAlert *alert = [[VHVideoAlert alloc] initWithDelegate:self tag:4543 title:actor.nickName icon:image];
        [alert setMaskView:maskView];
        [alert setExchangedEnable:(_docView)?NO:YES];
        [alert show];
    }
}
- (void)panGesAction:(UIPanGestureRecognizer *)panGes
{
    UIView *view = panGes.view;
    
    if (view.width >= [UIScreen mainScreen].bounds.size.width) {
        return;
    }

    CGPoint point = [panGes translationInView:view];
    
    view.transform = CGAffineTransformTranslate(view.transform, point.x, point.y);
    [panGes setTranslation:CGPointMake(0, 0) inView:self];
    
    //手指离开屏幕时回弹到边缘
    if (panGes.state == UIGestureRecognizerStateEnded)
    {
        CGFloat originX = view.origin.x,originY = view.origin.y;
        if (originX<0) {
            originX = 0;
        }
        
        if (originX > (self.width-view.width)) {
            originX = self.width - view.width;
        }

        if (originY<0) {
            originY = 0;
        }
        
        if (originY>(self.height-view.height)) {
            originY = self.height - view.height;
        }
        
        view.frame = CGRectMake(originX, originY, view.width, view.height);
        
        return;
    }
    
    
//    //边界控制
//    if (CGRectContainsRect(self.frame, view.frame))
//    {
//        CGPoint point = [panGes translationInView:view];
//
//        view.transform = CGAffineTransformTranslate(view.transform, point.x, point.y);
//        [panGes setTranslation:CGPointMake(0, 0) inView:self];
//    }
}

#pragma mark - VHCameraAlertDelegate
- (void)cameraAlert:(VHCameraAlert *)alert clickedButton:(UIButton *)sender index:(NSInteger)index
{
    //"摄像头","麦克风","切换屏幕","切换摄像头"
    [self alertClickCallBack:sender index:index view:alert.maskView.superview];
}

#pragma mark - VHVideoAlertDelegate
- (void)vedioAlert:(VHVideoAlert *)alert clickedButton:(UIButton *)sender index:(NSInteger)index
{
    [self alertClickCallBack:sender index:2 view:alert.maskView.superview];
}

#pragma mark - 回调
- (void)alertClickCallBack:(UIButton *)sender index:(NSInteger)index view:(UIView *)view
{
    if ([self.delegate respondsToSelector:@selector(layoutView:layoutEvent:renderView:clickButton:)])
    {
        [self.delegate layoutView:self layoutEvent:(LayoutEvent)index renderView:view clickButton:sender];
    }
}

@end
