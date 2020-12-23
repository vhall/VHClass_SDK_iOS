//
//  AnswerController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/4.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "AnswerController.h"
#import <VHClassSDK/VHCIMClient.h>
#import "QuestionViewCell.h"

@interface AnswerController ()<VHCIMClientDelegate,UITableViewDataSource>

@property (nonatomic, strong, nullable) VHCQuestion *currentQuestion;//当前的问卷

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation AnswerController

- (void)dealloc {
    [[VHCIMClient sharedIMClient] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[VHCIMClient sharedIMClient] addDelegate:self];
    
    [self initViews];
}

- (void)initViews {
    [self.view addSubview:self.tableView];
}





#pragma mark - VHCIMClientDelegate
/**
 @brief 问卷消息回调
 */
- (void)imClient:(VHCIMClient *)client questionMsg:(VHCQuestion *)question {
    VHCLog(@"问卷消息：%@",question);
    
    
    
    
    
    
    
    
    if (question.state == VHCQuestionStateStop) {
        self.currentQuestion = nil;
        [VHCTool showAlertWithMessage:@"本次答题结束！"];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AnswerController_cell";
    QuestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[QuestionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
