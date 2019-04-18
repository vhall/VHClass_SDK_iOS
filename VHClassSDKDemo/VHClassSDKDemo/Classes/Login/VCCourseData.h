//
//  VCCourseData.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/1/17.
//  Copyright © 2019年 class. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHClassSDK.h"
NS_ASSUME_NONNULL_BEGIN

@interface VCCourseData : NSObject
+ (VCCourseData *)shareInstance;

@property (nonatomic,copy)NSString* courseId;
@property (nonatomic,copy)NSString* password;
@property (nonatomic,copy)NSString* courseName;
@property (nonatomic,copy)NSString* nickName;
@property (nonatomic,copy)NSString* joinId;
@property (nonatomic,strong)VHClassBaseInfo *courseInfo;

@property (nonatomic,assign)BOOL banChat;
@property (nonatomic,assign)BOOL allBanChat;

//Class SDK api token
@property (nonatomic,copy)NSString *accessToken_class;

//PaaS SDK
@property (nonatomic,copy)NSString* app_id;
@property (nonatomic,copy)NSString* access_token;


/**
 @brief 初始化微吼课堂SDK
 @param appKey 即用户在微吼平台上注册的AppKey
 @param secretKey 即用户在微吼平台上注册生成的AppSecretKey
 @warning 使用SDK其他类时，务必确保SDK先初始化。
 */
+ (void)initWithAppKey:(NSString *)appKey
          appSecretKey:(NSString *)secretKey;
/**
 @brief 获取课堂基本信息，异步函数
 @param roomId   课堂id
 @param sucess   成功，返回课堂基本信息  @see VHClassSDKBaseInfo
 @param failed   获取出错，返回错误信息
 */
+ (void)getClassInfoWithRoomId:(nonnull NSString *)roomId
                      sucessed:(void(^)(void))sucess
                        failed:(void(^)(VHCError *error))failed;

/**
 @brief          登录，异步函数
 @param keyValue 口令
 @param nickName 用户昵称
 @param sucess   登录成功，返回用户参会id
 @param failed   登录失败，返回失败原因
 */
+ (void)joinWithName:(NSString *)nickName
                   key:(NSString *)keyValue
              sucessed:(void(^)(void))sucess
                failed:(void(^)(VHCError *error))failed;

/**
 @brief          离开课堂
 */
+ (void)leaveRoom;

/**
 @brief 读取分析粘贴板数据
 */
+ (void)readPasteboard:(void(^)(NSString *courseId,NSString *password))block;


@end

NS_ASSUME_NONNULL_END
