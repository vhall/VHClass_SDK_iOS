//
//  VCHomeViewController.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/1/15.
//  Copyright © 2019年 class. All rights reserved.
//

#import "VCHomeViewController.h"

#import <objc/message.h>

#import "VCLoginViewController.h"

@interface VCHomeViewController ()
@property (strong, nonatomic) NSString* password;//口令

@property (weak, nonatomic) IBOutlet UIImageView *imageView;//test


@property (weak, nonatomic) IBOutlet UIView *courseIdView;
@property (weak, nonatomic) IBOutlet UITextField *courseIdTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation VCHomeViewController

+ (void)setTestServerUrl:(BOOL)isTest {
    ((BOOL(*)(id,SEL,BOOL))objc_msgSend)([VHClassSDK class],@selector(setTestServerUrl:),isTest);
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithAppKey:(NSString *)appKey appSecretKey:(NSString *)secretKey
{
    if (self = VCInitWithNib(self)) {
        [VCCourseData initWithAppKey:appKey appSecretKey:secretKey];
    }
    return self;
}

- (void)viewDidLoad {    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _courseIdTextfield.text = [VCCourseData shareInstance].courseId;
    _nextBtn.backgroundColor = _courseIdTextfield.text.length>0?AppBaseColor:AppBaseColorGray;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //使用一根手指双击时，才触发点按手势识别器
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:recognizer];
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //进入App监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appDidBecomeActive
{
    __weak typeof(self) wf = self;
    [VCCourseData readPasteboard:^(NSString * _Nonnull courseId, NSString * _Nonnull password) {
        if(courseId.length>0)
        {
            [wf.view endEditing:YES];
            wf.courseIdTextfield.text = courseId;
            wf.password = password;
            wf.nextBtn.backgroundColor = wf.courseIdTextfield.text.length>0?AppBaseColor:AppBaseColorGray;
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnClicked:(id)sender {
//    _imageView.image = UIImage(@"嘉宾");
    
    [self.view endEditing:YES];
    
    if(_courseIdTextfield.text.length<=0)
    {
        [self errorUIUpdate:YES msg:@"请输入正确的课堂ID"];
        return;
    }
    
    _nextBtn.enabled = NO;
    
    [self showProgressDialog:VHKWindow];
    __weak typeof(self) wf = self;
    [VCCourseData getClassInfoWithRoomId:_courseIdTextfield.text sucessed:^() {
        [wf hideProgressDialog:VHKWindow];
        [wf nextPage];
    } failed:^(VHCError * _Nonnull error) {
        [wf hideProgressDialog:VHKWindow];
        [wf errorUIUpdate:YES msg:error.errorDescription];
    }];
}

#pragma mark -
- (void)nextPage
{
    _nextBtn.enabled = YES;
    VCLoginViewController *vc = [[VCLoginViewController alloc]init];
    vc.password = self.password;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)errorUIUpdate:(BOOL)isError msg:(NSString*)msg
{
    _nextBtn.enabled = YES;
    _courseIdView.layer.borderColor = isError?AppErrorColor.CGColor:AppBaseColorGray1.CGColor;
    _courseIdTextfield.textColor = isError?AppErrorColor:AppBaseColorFont;
    _courseIdTextfield.text = isError?msg:@"";
    _courseIdTextfield.tag  = isError?1:0;
    _nextBtn.backgroundColor = (isError || _courseIdTextfield.text.length == 0)?AppBaseColorGray:AppBaseColor;
}


#pragma mark - textField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _password = nil;
    if(textField.tag == 1)//当前显示错误信息
        [self errorUIUpdate:NO msg:nil];
    
    if(textField.text.length<=4)
        textField.text = @"edu_";
    
    _nextBtn.backgroundColor = textField.text.length>0?AppBaseColor:AppBaseColorGray;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length<=4)
    {
        textField.text = nil;
        _nextBtn.backgroundColor = textField.text.length>0?AppBaseColor:AppBaseColorGray;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.courseIdTextfield) {
        
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if(![VHCTool predicateCheck:string regex:PredicateCheckStr_ID])
        {
            return NO;
        }
        //so easy
        else if (self.courseIdTextfield.text.length >= 12) {
            self.courseIdTextfield.text = [textField.text substringToIndex:12];
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [self btnClicked:_nextBtn];
    return YES;
}


@end
