//
//  LoginViewController.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/10.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "LoginViewController.h"
#import "VHClassSDK.h"

@interface LoginViewController ()
{
    UIView *_roomIdView;
    UIView *_roomNameView;
    UIView *_roomKeyView;
    
    UIButton *_enterButton;
    UITextField *_roomIdTextField;
    UITextField *_roomNameTextField;
    UITextField *_roomKeyTextField;

    BOOL _enter;
    
    UILabel *_roomInfoL1;//房间名称
    UILabel *_roomInfoL2;//房间状态
    UILabel *_roomInfoL3;//房间布局
    UILabel *_roomInfoL4;//房间类型
}
@property (nonatomic, strong) UILabel *iconLabel;

@end

@implementation LoginViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _iconLabel.frame = CGRectMake(SCREEN_WIDTH*0.5-80, 64, 160, 40);
    _roomIdView.frame = CGRectMake(16, SCREEN_HEIGHT*0.5-22, SCREEN_WIDTH-32, 44);
    _enterButton.frame = CGRectMake(16, self.view.frame.size.height-16-44, self.view.frame.size.width-32, 44);
    _roomNameView.frame = CGRectMake(16, _roomIdView.bottom+8, SCREEN_WIDTH-32, 44);
    _roomKeyView.frame = CGRectMake(16, _roomNameView.bottom+8, SCREEN_WIDTH-32, 44);
    _roomInfoL1.frame = CGRectMake(16, 108+10, 300, 20);
    _roomInfoL2.frame = CGRectMake(16, _roomInfoL1.bottom+10, 300, 20);
    _roomInfoL3.frame = CGRectMake(16, _roomInfoL2.bottom+10, 300, 20);
    _roomInfoL4.frame = CGRectMake(16, _roomInfoL3.bottom+10, 300, 20);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHex:@"f4f4f4"];
    
    
    _iconLabel = [[UILabel alloc] init];
    _iconLabel.text = @"微吼课堂";
    _iconLabel.font = [UIFont systemFontOfSize:32];
    _iconLabel.textColor = [UIColor colorWithHex:@"666666"];
    [self.view addSubview:_iconLabel];
    
    
    _roomInfoL1 = [[UILabel alloc] init];
    _roomInfoL1.font = [UIFont systemFontOfSize:15];
    _roomInfoL1.textColor = [UIColor colorWithHex:@"666666"];
    [self.view addSubview:_roomInfoL1];
    
    _roomInfoL2 = [[UILabel alloc] init];
    _roomInfoL2.font = [UIFont systemFontOfSize:15];
    _roomInfoL2.textColor = [UIColor colorWithHex:@"666666"];
    [self.view addSubview:_roomInfoL2];

    _roomInfoL3 = [[UILabel alloc] init];
    _roomInfoL3.font = [UIFont systemFontOfSize:15];
    _roomInfoL3.textColor = [UIColor colorWithHex:@"666666"];
    [self.view addSubview:_roomInfoL3];

    _roomInfoL4 = [[UILabel alloc] init];
    _roomInfoL4.font = [UIFont systemFontOfSize:15];
    _roomInfoL4.textColor = [UIColor colorWithHex:@"666666"];
    [self.view addSubview:_roomInfoL4];

    
    
    _roomIdView = [[UIView alloc] initWithFrame:CGRectMake(16, SCREEN_HEIGHT*0.5-22, SCREEN_WIDTH-32, 44)];
    _roomIdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_roomIdView];
    UILabel *roomIdL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 80, _roomIdView.size.height)];
    roomIdL.text = @"课堂id：";
    roomIdL.font = [UIFont systemFontOfSize:13];
    roomIdL.textColor = [UIColor colorWithHex:@"666666"];
    [_roomIdView addSubview:roomIdL];
    _roomIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, _roomIdView.frame.size.width-80, _roomIdView.height)];
    _roomIdTextField.placeholder = @"请输入课堂id";
    [_roomIdView addSubview:_roomIdTextField];

    
    _roomNameView = [[UIView alloc] initWithFrame:CGRectMake(16, _roomIdView.bottom+8, SCREEN_WIDTH-32, 44)];
    _roomNameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_roomNameView];
    UILabel *roomNameL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 80, _roomIdView.size.height)];
    roomNameL.text = @"昵称：";
    roomNameL.font = [UIFont systemFontOfSize:13];
    roomNameL.textColor = [UIColor colorWithHex:@"666666"];
    [_roomNameView addSubview:roomNameL];
    _roomNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, _roomNameView.frame.size.width-80, _roomNameView.height)];
    _roomNameTextField.placeholder = @"请输入您的昵称";
    [_roomNameView addSubview:_roomNameTextField];
    
    
    _roomKeyView = [[UIView alloc] initWithFrame:CGRectMake(16, _roomNameView.bottom+8, SCREEN_WIDTH-32, 44)];
    _roomKeyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_roomKeyView];
    UILabel *roomKeyL = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 80, _roomKeyView.size.height)];
    roomKeyL.text = @"课堂口令：";
    roomKeyL.font = [UIFont systemFontOfSize:13];
    roomKeyL.textColor = [UIColor colorWithHex:@"666666"];
    [_roomKeyView addSubview:roomKeyL];
    _roomKeyTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, _roomKeyView.frame.size.width-80, _roomKeyView.height)];
    _roomKeyTextField.placeholder = @"请输入课堂口令";
    [_roomKeyView addSubview:_roomKeyTextField];

    
    _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _enterButton.backgroundColor = [UIColor colorWithHex:@"ff4c4b"];
    [_enterButton setTitle:@"进入" forState:UIControlStateNormal];
    [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _enterButton.layer.cornerRadius = 4;
    [_enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_enterButton];
    
    
    //显示上次登录的账号
    [self textFiled:_roomIdTextField showLastWithKey:@"VH_LastUserRoomId"];
    [self textFiled:_roomNameTextField showLastWithKey:@"VH_LastUserName"];
    [self textFiled:_roomKeyTextField showLastWithKey:@"VH_LastUserKeyValue"];
}

- (void)textFiled:(UITextField *)textFiled showLastWithKey:(NSString *)key {
    NSString *lastString = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (lastString && [lastString length]) {
        textFiled.text = lastString;
    }
}

- (void)enterButtonClick:(UIButton *)enter
{
    if (!_roomIdTextField.text || _roomIdTextField.text.length <= 0) {
        [VHCTool showAlertWithMessage:@"请输入课堂id"];
        return;
    }
    
    if (_enter == NO) {
        // 获取课堂基础信息
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[VHClassSDK sharedSDK] classBaseInfoWithRoomId:_roomIdTextField.text sucessed:^(VHClassBaseInfo * _Nonnull result) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];

            [self getBaseInfo:result];
            
        } failed:^(VHCError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [VHCTool showAlertWithMessage:error.errorDescription];
        }];
        return;
    }
    
    // 登录(进入课堂)
    if (!_roomNameTextField.text || _roomNameTextField.text.length<=0) {
        [VHCTool showAlertWithMessage:@"请输入您的昵称！"];
        return;
    }
    if (!_roomKeyTextField.text || _roomKeyTextField.text.length<=0) {
        [VHCTool showAlertWithMessage:@"请输入课堂口令！"];
        return;
    }
    
    //进入微吼课堂
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[VHClassSDK sharedSDK] joinClassWithNickName:_roomNameTextField.text roomId:_roomIdTextField.text key:_roomKeyTextField.text sucessed:^(NSString *joinId,VHClassBaseInfo *bseeInfo) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];

        [self joinVHClassSucessWithJoinId:joinId baseInfo:bseeInfo];
        [VHCTool showAlertWithMessage:@"您已进入课堂"];
        
    } failed:^(VHCError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [VHCTool showAlertWithMessage:[NSString stringWithFormat:@"进入课堂失败%@",error.errorDescription]];
    }];
}

- (void)getBaseInfo:(VHClassBaseInfo *)data {
    _roomInfoL1.text = [NSString stringWithFormat:@"房间名称：%@",data.roomName];
    NSArray *statusDis = @[@" ",@"上课中",@"预告",@"回放",@"转播",@"已下课",@" ",@" "];
    _roomInfoL2.text = [NSString stringWithFormat:@"房间状态：%@",statusDis[data.state]];
    NSArray *layoutDis = @[@" ",@"文档布局",@" ",@"视频布局"];
    _roomInfoL3.text = [NSString stringWithFormat:@"房间布局：%@",layoutDis[data.layout]];
    NSArray *classDis = @[@"公开课",@"小课堂"];
    _roomInfoL4.text = [NSString stringWithFormat:@"房间类型：%@",classDis[data.type]];
    
    _enter = YES;
}

- (void)joinVHClassSucessWithJoinId:(NSString *)joinId baseInfo:(VHClassBaseInfo *)baseInfo
{
    switch (baseInfo.state) {
        case VHClassStateUnkown:
            break;
        case VHClassStateClassOn://上课中
            
            break;
        case VHClassStatusTrailer://预告
            
            break;
        case VHClassStatusVod://回放
            
            break;
        case VHClassStatusBroadcast://转播
            
            break;
        case VHClassStatusClassOver://已下课
            
            break;
    }
    
    //当前用户的参会id
    [User defaultUser].joinId = joinId;
    
    if (self.LoginSucess) {
        self.LoginSucess();
    }
    
    //记录测试上次登录账号
    [[NSUserDefaults standardUserDefaults] setObject:self->_roomIdTextField.text forKey:@"VH_LastUserRoomId"];
    [[NSUserDefaults standardUserDefaults] setObject:self->_roomNameTextField.text forKey:@"VH_LastUserName"];
    [[NSUserDefaults standardUserDefaults] setObject:self->_roomKeyTextField.text forKey:@"VH_LastUserKeyValue"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 5)
    {   //个人测试账号!
        _roomIdTextField.text = @"edu_e2b98daa";
        _roomNameTextField.text = @"vhall_iOS";
        _roomKeyTextField.text = @"817157";
    }
    else {
        [self.view endEditing:YES];
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
