//
//  VCCourseData.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/1/17.
//  Copyright © 2019年 class. All rights reserved.
//

#import "VCCourseData.h"
#import <objc/message.h>
#import "VHCIMClient.h"

typedef void(^SucessBlock)(NSDictionary *result);
typedef void(^FailedBlock)(NSError *error);

@implementation VCCourseData

+ (void)initWithAppKey:(NSString *)appKey
          appSecretKey:(NSString *)secretKey
{
    [VHClassSDK initWithAppKey:appKey appSecretKey:secretKey];
}

+ (void)getClassInfoWithRoomId:(nonnull NSString *)roomId
                      sucessed:(void(^)(void))sucess
                        failed:(void(^)(VHCError *error))failed
{
    [VHClassSDK getClassInfoWithRoomId:roomId sucessed:^(VHClassBaseInfo * _Nonnull result) {
        [VCCourseData shareInstance].courseId   =  result.roomId;
        [VCCourseData shareInstance].courseInfo = result;
        if(sucess)
            sucess();
    } failed:^(VHCError * _Nonnull error) {
        if (failed) {
            failed(error);
        }
    }];
}

+ (void)joinWithName:(NSString *)nickName
                    key:(NSString *)keyValue
               sucessed:(void(^)(void))sucess
                 failed:(void(^)(VHCError *error))failed {
    [VHClassSDK joinWithRoomId:[VCCourseData shareInstance].courseId name:nickName key:keyValue sucessed:^(NSString * _Nonnull joinId, NSString * _Nonnull accessToken, VHClassBaseInfo * _Nonnull result) {
        [VCCourseData shareInstance].joinId     = joinId;
        [VCCourseData shareInstance].courseId   = result.roomId;
        [VCCourseData shareInstance].courseInfo = result;
        [VCCourseData shareInstance].accessToken_class = accessToken;

        [[VHCIMClient sharedIMClient] connectWithComplete:^(VHCError *error) {

        }];
        if(sucess)
            sucess();
    } failed:^(VHCError * _Nonnull error) {
        
    }];
}

+ (void)leaveRoom
{
    [[VHCIMClient sharedIMClient] destoryIMClient];
    [VHClassSDK leaveRoom];
}

/*
 您关注的课堂即将开讲了，请准时参加！
 课堂名称：543245
 开始时间：2019-01-21 21:15:44
 学员口令：354391
 加入链接：https://class.vhall.com/#/entry/edu_15666270
 */
+ (void)readPasteboard:(void(^)(NSString *courseId,NSString *password))block
{
    NSString *courseId = nil;
    NSString *password = nil;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSRange r = [pasteboard.string rangeOfString:@"edu_"];
    if (r.location != NSNotFound)
    {
        courseId = [pasteboard.string substringWithRange:NSMakeRange(r.location, 12)];
        if(courseId.length>0)
        {
            [VCCourseData shareInstance].courseId = courseId;
//            [VCCourseData getClassInfoWithRoomId:courseId sucessed:sucess failed:failed];
            r = [pasteboard.string rangeOfString:@"学员口令"];
            if (r.location != NSNotFound)
            {
                password =  [pasteboard.string substringWithRange:NSMakeRange(r.location+5, 6)];
            }
        }
        pasteboard.string = @"";
    }
    
    if(block)
    {
        block(courseId,password);
    }
    return ;
}

+ (void)getPaasParams:(NSString *)joinId sucess:(SucessBlock)sucess failed:(FailedBlock)failed
{
    ((BOOL(*)(id,SEL,NSString*,SucessBlock,FailedBlock))objc_msgSend)([VHCIMClient class],@selector(getPaasParams:sucessed:failed:),joinId,sucess,failed);
}

+ (VCCourseData *)shareInstance
{
    static VCCourseData *shareDataInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataInstance = [[super allocWithZone:NULL] init];
    });
    return shareDataInstance;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [VCCourseData shareInstance] ;
}

- (id) copyWithZone:(struct _NSZone *)zone
{
    return [VCCourseData shareInstance] ;
}

#pragma mark -
- (instancetype)init
{
    if(self = [super init])
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _courseId = [userDefaults objectForKey:@"VCcourseId"];
        _password = [userDefaults objectForKey:@"VCpassword"];
        _nickName = [userDefaults objectForKey:@"VCnickName"];
        
        [VCCourseData getPaasParams:@"getAppID" sucess:^(NSDictionary *result) {
            if([result[@"code"] intValue] == 200)
            {
                [VCCourseData shareInstance].app_id       = result[@"data"][@"app_id"];
                [VCCourseData shareInstance].access_token = result[@"data"][@"token"];
            }
        } failed:^(NSError *error) {
            
        }];
    }
    return self;
}
#pragma mark - 记住  id 口令 昵称
- (void)setCourseId:(NSString *)courseId
{
    if(![_courseId isEqualToString:courseId])
        self.password = @"";
    
    _courseId = courseId;
    if(_courseId.length == 0)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCcourseId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_courseId forKey:@"VCcourseId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString *)password
{
    _password = password;
    if(_password.length == 0)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCpassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"VCpassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    if(_nickName.length == 0)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCnickName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_nickName forKey:@"VCnickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)setJoinId:(NSString *)joinId
//{
//    _joinId = joinId;
//    if(_joinId.length>0)
//    {
//        [VHLiveBase setThirdPartyUserId:_joinId];
//        [VCCourseData getPaasParams:_joinId sucess:^(NSDictionary *result) {
//            if([result[@"code"] intValue] == 200)
//            {
//                [VCCourseData shareInstance].access_token = result[@"data"][@"token"];
//            }
//        } failed:^(NSError *error) {
//
//        }];
//    }
//}

//- (void)setApp_id:(NSString *)app_id
//{
//    if(!_app_id)
//    {
//        _app_id = app_id;
////        [VHLiveBase registerApp:_app_id completeBlock:^(NSError *error) {
////
////        }];
//        NSLog(@"******* app_id %@",_app_id);
//        [VHLiveBase registerApp:_app_id host:@"api.vhallyun.com" completeBlock:^(NSError *error) {
//
//        }];
//    }
//}

@end
