//
//  VCLoginViewController.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/1/17.
//  Copyright © 2019年 class. All rights reserved.
//

#import "VCLoginViewController.h"
#import "VHClassViewController.h"
#import "VCNavigationController.h"


@interface VCLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *courseIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseStateLabel;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *joinCourseBtn;
@end

@implementation VCLoginViewController

- (instancetype)init
{
    if (self = VCInitWithNib(self)) {
        
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _courseIdLabel.text = [VCCourseData shareInstance].courseInfo.roomId;
    _courseNameLabel.text =[VCCourseData shareInstance].courseInfo.roomName;
    
    switch ([VCCourseData shareInstance].courseInfo.type) {
        case VHClassTypeRecordRoom://录播课2
            _courseStateLabel.text = [NSString stringWithFormat:@"  %@  ",VCClassStateStrList[VHClassStatusClassOver+1]];
            _courseStateLabel.textColor = VCClassStateColorList[VHClassStatusClassOver+1];
            _courseStateLabel.layer.borderColor = ((UIColor*)VCClassStateColorList[VHClassStatusClassOver+1]).CGColor;
            break;
        case VHClassTypeSeriesRoom://系列课3
            
            break;
        case VHClassTypeSmallRoom://小课堂1
        case VHClassTypePublicRoom://公开课0
        default:
            _courseStateLabel.text = [NSString stringWithFormat:@"  %@  ",VCClassStateStrList[[VCCourseData shareInstance].courseInfo.state]];
            _courseStateLabel.textColor = VCClassStateColorList[[VCCourseData shareInstance].courseInfo.state];
            _courseStateLabel.layer.borderColor = ((UIColor*)VCClassStateColorList[[VCCourseData shareInstance].courseInfo.state]).CGColor;
            break;
    }
    
    _nickNameTextfield.text = [VCCourseData shareInstance].nickName;
    _passwordTextfield.text = _password.length>0?_password:[VCCourseData shareInstance].password;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //使用一根手指双击时，才触发点按手势识别器
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:recognizer];
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)enterCourseBtnClicked:(id)sender {

    [self.view endEditing:YES];
    
    if(![VHCTool predicateCheck:_nickNameTextfield.text regex:PredicateCheckStr_Nick])
    {
        [self showTextView:self.view message:@"请填写合法的用户名"];
        return;
    }

    if(_nickNameTextfield.text.length == 0 || _passwordTextfield.text.length == 0)
    {
        [self showTextView:self.view message:@"请填写用户名和口令"];
        return;
    }
    
    _joinCourseBtn.enabled = NO;
    
    [self showProgressDialog:self.view];
    
    __weak typeof(self) wf = self;
    [VCCourseData joinWithName:_nickNameTextfield.text key:_passwordTextfield.text phone:nil sucessed:^() {
        [wf nextPage];
    } failed:^(VHCError * _Nonnull error) {
        [wf hideProgressDialog:wf.view];
        wf.joinCourseBtn.enabled = YES;
        [wf showTextView:wf.view message:error.errorDescription];
    }];
}

- (void)nextPage
{
    [self hideProgressDialog:self.view];
    _joinCourseBtn.enabled = YES;
    [VCCourseData shareInstance].nickName = _nickNameTextfield.text;
    [VCCourseData shareInstance].password = _passwordTextfield.text;

    VHClassViewController *vc = [[VHClassViewController alloc] init];
    VCNavigationController *nav = [[VCNavigationController alloc] initWithRootViewController:vc];
    nav.orientation = UIInterfaceOrientationPortrait;
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - textField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField == self.nickNameTextfield) {
//    }
//    else if (textField == self.passwordTextfield) {
//    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField == self.nickNameTextfield) {
//    }
//    else if (textField == self.passwordTextfield) {
//    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.nickNameTextfield) {
        
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
//        else if(![VHCTool predicateCheck:string regex:PredicateCheckStr_Nick])
//        {
//            return NO;
//        }
        //so easy
        else if (self.nickNameTextfield.text.length >= 10) {
            self.nickNameTextfield.text = [textField.text substringToIndex:10];
            return NO;
        }
    }
    else if (textField == self.passwordTextfield)
    {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.passwordTextfield.text.length >= 6) {
            self.passwordTextfield.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [self enterCourseBtnClicked:_joinCourseBtn];
    return YES;
}

@end
