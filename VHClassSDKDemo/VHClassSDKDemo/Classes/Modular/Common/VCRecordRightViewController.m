//
//  VCRecordRightViewController.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/3/11.
//  Copyright © 2019 class. All rights reserved.
//

#import "VCRecordRightViewController.h"
#import <VHClassSDK/VHCLiveHeader.h>

#define kVCRecordRightViewWidth (SCREEN_WIDTH*0.5)

@interface VCRecordRightViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *rightContentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *rateDataSource;
@property (nonatomic, strong) NSMutableArray *definationDataSource;


@property (nonatomic, readwrite) RecordRightVCShowType showType;


@property (nonatomic) NSString *curRateStr;
@property (nonatomic) NSString *curDefiStr;

@end

@implementation VCRecordRightViewController

- (instancetype)init {
    if (self = [super init])
    {
        self.curDefiStr = @"原画";
        self.curRateStr = @"1.0x";
        
        self.rightContentView = [[UIView alloc] init];
        self.rightContentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel = titleLabel;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColor(204, 204, 204, 1);
        self.line = line;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.33];
    
    [self.rightContentView addSubview:self.titleLabel];
    [self.view addSubview:self.rightContentView];
    [self.rightContentView addSubview:self.line];
    [self.rightContentView addSubview:self.tableView];
    
    self.rightContentView.frame = CGRectMake(self.view.width+kVCRecordRightViewWidth, 0, kVCRecordRightViewWidth, self.view.height);
    self.titleLabel.frame = CGRectMake(0, 0, kVCRecordRightViewWidth, 56);
    self.line.frame = CGRectMake(0, 56, kVCRecordRightViewWidth, 0.5);
    self.tableView.frame = CGRectMake(0, 56.5, kVCRecordRightViewWidth, self.view.height-56.5);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.rightContentView.frame = CGRectMake(self.view.width+kVCRecordRightViewWidth, 0, kVCRecordRightViewWidth, self.view.height);
    self.titleLabel.frame = CGRectMake(0, 0, kVCRecordRightViewWidth, 56);
    self.line.frame = CGRectMake(0, 56, kVCRecordRightViewWidth, 0.5);
    self.tableView.frame = CGRectMake(0, 56.5, kVCRecordRightViewWidth, self.view.height-56.5);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:.3 animations:^{
        self.rightContentView.right = self.view.right;
    }];
}


#pragma mark - private

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.x < (self.view.width - kVCRecordRightViewWidth))
    {
        [self remove];
    }
}

- (void)remove {
    [UIView animateWithDuration:.3 animations:^{
        self.rightContentView.left = self.view.right;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - public
//分辨率设置完成
- (void)supportDefinitions:(NSArray <__kindof NSNumber *> *)definitions curDefinition:(NSInteger)definition
{
    if (definition>0 && definition < 5) {
        NSArray *arr = @[@"原画",@"超高清",@"高清",@"标清",@"纯音频"];
        self.curDefiStr = arr[definition];
        [self.definationDataSource removeAllObjects];
        for (int i = 0; i < definitions.count; i++) {
            NSNumber *number = definitions[i];
            NSInteger defi = [number integerValue];
            [self.definationDataSource addObject:arr[defi]];
        }
    }
}
//倍速设置成功
- (void)rateSetComplete:(NSString *)rateStr {
    self.curRateStr = rateStr;
}

//切换显示
- (void)changedShowType:(RecordRightVCShowType)type
{
    _showType = type;
    if (type == RecordRightVCShowTypeDefination)
    {
        self.titleLabel.text = @"    清晰度";
    }
    else
    {
        self.titleLabel.text = @"    倍速";
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showType == RecordRightVCShowTypeDefination) {
        return self.definationDataSource.count;
    }
    return self.rateDataSource.count;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellId = @"VCRecordRightViewController_cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (_showType == RecordRightVCShowTypeDefination)
    {
        NSString *str = self.definationDataSource[indexPath.row];
        cell.textLabel.text = str;
        cell.textLabel.textColor = [UIColor whiteColor];
        if ([str isEqualToString:self.curDefiStr]) {
            cell.textLabel.textColor = UIColor(82, 204, 144, 1);
        }
    }
    else
    {
        NSString *str = self.rateDataSource[indexPath.row];
        cell.textLabel.text = str;
        cell.textLabel.textColor = [UIColor whiteColor];
        if ([str isEqualToString:self.curRateStr]) {
            cell.textLabel.textColor = UIColor(82, 204, 144, 1);
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_showType == RecordRightVCShowTypeDefination)
    {
        NSString *defiStr = self.definationDataSource[indexPath.row];
        NSArray *arr = @[@"原画",@"超高清",@"高清",@"标清",@"纯音频"];
        NSInteger defi = [arr indexOfObject:defiStr];
        if ([self.delegate respondsToSelector:@selector(selectedDefination:defiStr:)]) {
            [self.delegate selectedDefination:defi defiStr:defiStr];
        }
    }
    else
    {
        NSString *rateStr = self.rateDataSource[indexPath.row];
        NSArray *arr = @[@2.0,@1.5,@1.25,@1.0,@1.75];
        NSInteger rate = [arr[indexPath.row] integerValue];
        if ([self.delegate respondsToSelector:@selector(selectedRate:rateStr:)]) {
            [self.delegate selectedRate:rate rateStr:rateStr];
        }
    }
    
    [self remove];
}



- (NSMutableArray *)rateDataSource {
    if (!_rateDataSource) {
        _rateDataSource = [NSMutableArray array];
        [_rateDataSource addObjectsFromArray:@[@"2.0x",@"1.5x",@"1.25x",@"1.0x",@"0.75x"]];
    }
    return _rateDataSource;
}
- (NSMutableArray *)definationDataSource {
    if (!_definationDataSource) {
        _definationDataSource = [NSMutableArray array];
        [_definationDataSource addObject:@"原画"];
    }
    return _definationDataSource;
}

@end
