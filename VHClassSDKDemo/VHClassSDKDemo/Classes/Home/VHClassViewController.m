//
//  VHClassViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/3.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHClassViewController.h"

@interface VHClassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *classNames;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VHClassViewController

#pragma mark - life cicel
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //恢复重力感应
    self.navigationController.autoRotate = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //设置页面不支持重力感应
    self.navigationController.autoRotate = NO;
    //转为竖屏
    [self rotateScreen:UIInterfaceOrientationPortrait];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.title = @"微吼课堂";
        
        [self initTitles];
        
        [self initClassNames];
    }
    return self;
}
- (void)initTitles
{
    NSString *sec1Title = @"基本功能";
    NSArray *sec1CellTitles = @[@"直播",
                                @"回放",
                                @"文档/白板",
                                @"讨论",
                                ];
    
    NSString *sec2Title = @"组合功能";
    NSArray *sec2CellTitles = @[@"直播 + 互动",
                                @"回放 + 文档",
                                @"直播 + 文档",
                                ];

    NSArray *section1 = @[sec1Title,sec1CellTitles];
    NSArray *section2 = @[sec2Title,sec2CellTitles];

    self.sections = [NSArray arrayWithObjects:section1,section2, nil];
}
- (void)initClassNames
{
    NSArray *sec1ClassNames = @[@"VHCLiveBusinessViewController",
                                @"VHCVODBusinessViewController",
                                @"VHCDocBusinessViewController",
                                @"VHCChatViewController",
                                ];
    
    NSArray *sec2ClassNames = @[@"LiveInteractiveViewController",
                                @"VHCVODDocViewController",
                                @"VHCLiveDocViewController",
                                ];
    
    self.classNames = [NSArray arrayWithObjects:sec1ClassNames,sec2ClassNames, nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self initTableView];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(loginOut)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
}

- (void)rotateScreen:(UIInterfaceOrientation)orientation
{
    //转屏时，先设置支持重力感应，否则此方法无效
    self.navigationController.autoRotate = YES;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        NSNumber *num = [[NSNumber alloc] initWithInt:orientation];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    SEL selector=NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    
    self.navigationController.autoRotate = NO;
    
    self.navigationController.orientation = orientation;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
}

- (void)dealloc {
    
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)loginOut
{
    [VCCourseData leaveRoom];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sections[section][1] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sections[section][0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"VHClassTableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = _sections[indexPath.section][1][indexPath.row];
    
    cell.detailTextLabel.text = self.classNames[indexPath.section][indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.classNames[indexPath.section][indexPath.row];
    
    UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
    
    subViewController.title = _sections[indexPath.section][1][indexPath.row];
    
    [self.navigationController pushViewController:subViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
