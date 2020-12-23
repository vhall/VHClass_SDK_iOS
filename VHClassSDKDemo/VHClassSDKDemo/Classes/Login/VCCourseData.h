//
//  VCCourseData.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/1/17.
//  Copyright © 2019年 class. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHClassSDK/VHClassSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCCourseData : NSObject
+ (VCCourseData *)shareInstance;

@property (nonatomic,copy)NSString* courseId;
@property (nonatomic,copy)NSString* password;
@property (nonatomic,copy)NSString* courseName;
@property (nonatomic,copy)NSString* nickName;
@property (nonatomic,copy)NSString* phoneNum;
@property (nonatomic,copy)NSString* joinId;
@property (nonatomic,assign)VHClassType rcourseType;
@property (nonatomic,assign)VHLoginType loginType;
@property (nonatomic,strong)VHClassBaseInfo *courseInfo;

@property (nonatomic,copy)NSString* resourceId;
@property (nonatomic,assign)int resourceType;

@property (nonatomic,assign)BOOL banChat;
@property (nonatomic,assign)BOOL allBanChat;

@property (nonatomic,assign)BOOL isShowPrivateChatRed;//是否显示私聊红点
@property (nonatomic,copy)NSString* curPrivateChatJoinId;//当前私聊目标id
@property (nonatomic,copy)NSString* curPrivateChatName;//当前私聊目标id name
@property (nonatomic,assign)NSInteger roleType;

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
 @brief 获取系列课堂基本信息，异步函数
 @param nickName 用户昵称
 @param keyValue 口令
 @param sucess   成功，返回课堂基本信息  @see VHClassSDKBaseInfo
 @param failed   获取出错，返回错误信息
 */
+ (void)getSeriesClassInfoWithName:(NSString *)nickName
                               key:(nullable NSString *)keyValue
                             phone:(nullable NSString *)phone
                            sucessed:(void(^)(void))sucess
                              failed:(void(^)(VHCError *error))failed;

/**
 @brief          登录，异步函数
 @param keyValue 口令
 @param nickName 用户昵称
 @param sucess   登录成功，返回用户参会id
 @param failed   登录失败，返回失败原因
 */
+ (void)joinWithName:(nullable NSString *)nickName
                 key:(nullable NSString *)keyValue
               phone:(nullable NSString *)phone
            sucessed:(void(^)(void))sucess
              failed:(void(^)(VHCError *error))failed;

/**
 @brief          微吼网校登录，异步函数
 @param roomId   房间id
 @param userId   网校用户id
 @param nickName 用户昵称
 @param access   登录渠道
 @param sucess   登录成功，返回用户参会id
 @param failed   登录失败，返回失败原因
 */
+ (void)joinWithRoomId:(NSString *)roomId
                userId:(NSString *)userId
                  name:(NSString *)nickName
          resourceType:(int)resourceType
            resourceId:(NSString *)resourceId
                access:(nullable NSString *)access
              sucessed:(void(^)(void))sucess
                failed:(void(^)(VHCError *error))failed;

/**
 @brief        系列课资源登录，异步函数
 @param seriesToken   系列课token
 @param sucess   登录成功，返回用户参会id
 @param failed   登录失败，返回失败原因
 */
+ (void)joinWithResourceType:(int)resourceType
                  resourceId:(NSString *)resourceId
                 seriesToken:(nullable NSString *)seriesToken
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


/**
 读取字符串中的课堂id和口令
 */
+ (void)readInfoFromString:(NSString *)string complete:(void(^)(NSString *courseId,NSString *password))block;

/**
 @brief 设置日志
 */
+ (void)setLogLevel:(int)level;
+ (void)setTestServerUrl:(BOOL)isTest;
@end

NS_ASSUME_NONNULL_END
