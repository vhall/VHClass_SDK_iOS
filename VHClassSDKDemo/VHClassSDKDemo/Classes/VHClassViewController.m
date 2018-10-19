//
//  VHClassViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/3.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHClassViewController.h"
#import "VHClassSDK.h"
#import "WatchLiveController.h"
#import "WatchVODController.h"
#import "LoginViewController.h"

@interface VHClassViewController ()<UITableViewDataSource,UITableViewDelegate,VHClassSDKDelegate>
{
    BOOL isLogin;
}
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *classNames;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VHClassViewController

#pragma mark - life cicel

- (instancetype)init {
    if (self = [super init]) {
        
        self.title = @"微吼课堂";
        
        [self initTitles];
        
        [self initClassNames];
        
        isLogin = NO;
    }
    return self;
}
- (void)initTitles
{
    NSString *sec1Title = @"基本功能";
    NSArray *sec1CellTitles = @[@"看直播 & 进互动",
                                @"看回放",
                                @"文档 & 白板",
                                @"聊天",
                                @"答题",];
    NSArray *section1 = @[sec1Title,sec1CellTitles];
    
    self.sections = [NSArray arrayWithObjects:section1, nil];
}
- (void)initClassNames
{
    NSArray *sec1ClassNames = @[@"WatchLiveController",
                                @"WatchVODController",
                                @"DocAndBoardController",
                                @"ChatViewController",
                                @"AnswerController",];
    
    self.classNames = [NSArray arrayWithObjects:sec1ClassNames, nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self initTableView];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(leaveClass)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [VHClassSDK sharedSDK].delegate = self;

    if (!isLogin) {
        [self loginOut];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

//离开课堂
- (void)leaveClass {
    [[VHClassSDK sharedSDK] leaveRoom];
    isLogin = NO;
    [self loginOut];
}

- (void)loginOut {
    if (!isLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
        
        loginVC.LoginSucess = ^{
            self->isLogin = YES;
        };
    }
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

#pragma mark - VHClassSDKDelegate
- (void)vhclass:(VHClassSDK *)sdk classStateDidChanged:(VHClassState)curState
{
    
}
- (void)vhclass:(VHClassSDK *)sdk userEventChanged:(VHCUserEvent)curEvent
{
    //已掉线
    if (curEvent == VHCUserEventLeave) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您已离开课堂！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self->isLogin = NO;
            [self loginOut];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
