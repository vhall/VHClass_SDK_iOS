//
//  ChatViewController.m
//  demo
//
//  Created by vhall on 2018/8/31.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "ChatViewController.h"
#import "VHCIMClient.h"
#import "MMKeyBoardView.h"
#import "ChatViewCell.h"
#import "ChatModel.h"

@interface ChatViewController ()<VHCIMClientDelegate,MMKeyBoardViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) MMKeyBoardView *keyBoardInputView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ChatViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.keyBoardInputView.frame = CGRectMake(0, self.view.size.height-64, self.view.size.width, 64);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-self.keyBoardInputView.height);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //切记一定要移除代理
    [[VHCIMClient sharedIMClient] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
    
    [self startIMClient];
    
    [self getLastestMsg];
}
- (void)dealloc {
    [[VHCIMClient sharedIMClient] destoryIMClient];
}

- (void)initViews {
    //聊天视图
    [self.view addSubview:self.tableView];
    //聊天输入框
    [self.view addSubview:self.keyBoardInputView];
}

//启动聊天服务器
- (void)startIMClient {
    [[VHCIMClient sharedIMClient] connect];
    [[VHCIMClient sharedIMClient] addDelegate:self];
}

//获取最近的n条聊天数据
- (void)getLastestMsg {
    [[VHCIMClient sharedIMClient] getLatestMsgWithNum:20 completion:^(NSArray<VHCMsg *> *result) {
        for (int i = 0; i<result.count; i++) {
            ChatModel *model = [[ChatModel alloc] init];
            [model setAttributesWithData:result[i]];
            if (self.dataSource.count > 1000) {
                [self.dataSource removeObjectAtIndex:0];
            }
            [self.dataSource insertObject:model atIndex:0];
        }
        [self reloadData];
    } failed:^(VHCError *error) {
        
    }];
}

#pragma mark - VHCIMClientDelegate
/**
 @brief 收到聊天消息回调
 */
- (void)imClient:(VHCIMClient *)client event:(NSString *)event message:(VHCMsg *)message
{
    //4、处理您自己的聊天显示
    VHCLog(@"收到聊天消息：%@",message.text);
    ChatModel *model = [[ChatModel alloc] init];
    [model setAttributesWithData:message];
    if (self.dataSource.count > 1000) {
        [self.dataSource removeLastObject];
    }
    [self.dataSource insertObject:model atIndex:0];
    [self reloadData];
}
/**
 @brief 错误回调
 */
- (void)imClient:(VHCIMClient *)client error:(VHCError *)error
{
    VHCLog(@"聊天错误回调error：%@",error.errorDescription);
    [VHCTool showAlertWithMessage:error.errorDescription];
}
/**
 @brief 主播端禁止某用户发言回调
 @param isBan       YES：被禁言，NO：被取消禁言
 @param joinId      被禁言用户的参会id，全体禁言此id为空
 @warning    讲师端对某禁言/取消禁言，会回调此方法，首次进入聊天也会回调该状态。
 */
- (void)imClient:(VHCIMClient *)client banToChat:(BOOL)isBan withJoinId:(NSString *)joinId
{
    //如果被禁言/取消禁言的是自己
    if ([joinId isEqualToString:[User defaultUser].joinId]) {
        if (isBan) {
            [VHCTool showAlertWithMessage:@"您已被禁言!"];
        }
        else {
            [VHCTool showAlertWithMessage:@"您已被取消禁言!"];
        }
    }
}

/**
 @brief 全体禁止发言状态改变回调
 @param isSilence   是否全体禁言,YES：主播开启了全体禁言，NO：主播取消了全体禁言
 @discussion 主播端开启/关闭全体禁言会回调此方法。首次进入聊天也会回调该状态。
 */
- (void)imClient:(VHCIMClient *)client wholeUserIsBan:(BOOL)isSilence {
    if (isSilence) {
        [VHCTool showAlertWithMessage:@"主播已开启了全体禁言!"];
    }
    else {
        [VHCTool showAlertWithMessage:@"主播已取消了全体禁言!"];
    }
}

#pragma mark - MMKeyBoardViewDelegate
/**
 @brief 发送消息事件回调
 @param text 消息内容
 */
- (void)keyBoardView:(MMKeyBoardView *)view sendText:(NSString *)text {
    //发送聊天消息
    [[VHCIMClient sharedIMClient] sendMsg:text success:^{
        
        VHCLog(@"聊天发送成功");
        [self.keyBoardInputView.inputTextFiled clearText];
        
    } failure:^(VHCError *error) {
        VHCLog(@"聊天发送失败：%@",error);
        [VHCTool showAlertWithMessage:[NSString stringWithFormat:@"聊天发送失败：%@",error.errorDescription]];
    }];
    
    [self.view endEditing:YES];
}

/**
 @brief 键盘高度变化回调
 @param endHeight 键盘高度
 @param duration 动画时长
 @discussion 旋转屏幕时，iOS系统键盘会先hidden，然后再show，此方法会回调两次。
 */
- (void)keyBoardView:(MMKeyBoardView *)view keyBoardFrameChnage:(CGFloat)endHeight duration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        
        self.tableView.bottom = self.keyBoardInputView.top;
        
    } completion:nil];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatViewController_ChatViewCell";
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setMsg:self.dataSource[indexPath.row]];
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource[indexPath.row] cellHeight];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - private
- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (MMKeyBoardView *)keyBoardInputView {
    if (!_keyBoardInputView) {
        _keyBoardInputView = [[MMKeyBoardView alloc] init];
        _keyBoardInputView.delegate = self;
    }
    return _keyBoardInputView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-self.keyBoardInputView.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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
    if (curEvent == VHClassMainEventKickout)
    {
        [VHCTool showAlertWithMessage:@"您已被主播踢出房间，无权限接收消息！，无权限发送消息！"];
    }
}

@end
