//
//  VHClassSDK.h
//  VHCFoundation
//
//  Created by vhall on 2018/8/31.
//  Copyright © 2018年 Morris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHCError.h"
#import "VHClassBaseInfo.h"

NS_ASSUME_NONNULL_BEGIN

//日志等级
typedef NS_ENUM(NSInteger, VHCLogLevel) {
    VHCLogLevelNone    = 0,    //NONE
    VHCLogLevelError   = 1,    //Error
    VHCLogLevelWarning = 2,    //Warning
    VHCLogLevelInfo    = 3,    //Info
    VHCLogLevelDebug   = 4,    //Debug
};

@interface VHClassSDK : NSObject

/**
 @brief 获取sdk版本号
 */
+ (NSString *)getSDKVersion;

/**
 *  设置日志等级
 *  @param level  日志等级
 */
+ (void)setLogLevel:(VHCLogLevel)level;

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
                      sucessed:(void(^)(VHClassBaseInfo *result))sucess
                        failed:(void(^)(VHCError *error))failed;

/**
 @brief 获取系列课堂基本信息，异步函数
 @param roomId   课堂id
 @param nickName 用户昵称
 @param keyValue 口令
 @param sucess   成功，返回课堂基本信息  @see VHClassSDKBaseInfo
 @param failed   获取出错，返回错误信息
 */
+ (void)getSeriesClassInfoWithRoomId:(nonnull NSString *)roomId
                                name:(NSString *)nickName
                                 key:(nullable NSString *)keyValue
                               phone:(nullable NSString *)phone
                            sucessed:(void(^)(VHClassBaseInfo *result))sucess
                              failed:(void(^)(VHCError *error))failed;

/**
  @brief          登录，异步函数
  @param roomId   房间id
  @param nickName 用户昵称
  @param keyValue 口令
  @param sucess   登录成功，返回用户参会id
  @param failed   登录失败，返回失败原因
 */
+ (void)joinWithRoomId:(NSString *)roomId
                  name:(NSString *)nickName
                   key:(nullable NSString *)keyValue
              sucessed:(void(^)(NSString *joinId,NSString *accessToken,VHClassBaseInfo *result))sucess
                failed:(void(^)(VHCError *error))failed;

/**
  @brief          登录，异步函数
  @param roomId   房间id
  @param nickName 用户昵称
  @param keyValue 口令
  @param sucess   登录成功，返回用户参会id
  @param failed   登录失败，返回失败原因
 */
+ (void)joinWithRoomId:(NSString *)roomId
                  name:(NSString *)nickName
                   key:(nullable NSString *)keyValue
                 phone:(nullable NSString *)phone
              sucessed:(void(^)(NSString *joinId,NSString *accessToken,VHClassBaseInfo *result))sucess
                failed:(void(^)(VHCError *error))failed;

/**
 @brief          登录，异步函数
 @param roomId   房间id
 @param nickName 用户昵称
 @param keyValue 口令
 @param resourceType 系列课资源类型 系列课中信息 1、系列课资源类型回放 2、系列课资源类型音视频 3、系列课资源类型课程
 @param resourceId   系列课资源ID
 @param sucess   登录成功，返回用户参会id
 @param failed   登录失败，返回失败原因
 */
+ (void)joinWithRoomId:(NSString *)roomId
                  name:(NSString *)nickName
                   key:(nullable NSString *)keyValue
                 phone:(nullable NSString *)phone
          resourceType:(int)resourceType
            resourceId:(nullable NSString *)resourceId
              sucessed:(void(^)(NSString *joinId,NSString *accessToken,VHClassBaseInfo *result))sucess
                failed:(void(^)(VHCError *error))failed;

/**
 @brief         系列课登录，异步函数
 @param roomId   房间id
 @param nickName 用户昵称
 @param keyValue 口令
 @param resourceType 系列课资源类型 系列课中信息 1、系列课资源类型回放 2、系列课资源类型音视频 3、系列课资源类型课程
 @param resourceId   系列课资源ID
 @param seriesToken   系列课token
 @param sucess   登录成功，返回用户参会id
 @param failed   登录失败，返回失败原因
 */
+ (void)joinWithRoomId:(NSString *)roomId
                  name:(NSString *)nickName
                   key:(nullable NSString *)keyValue
                 phone:(nullable NSString *)phone
          resourceType:(int)resourceType
            resourceId:(nullable NSString *)resourceId
           seriesToken:(nullable NSString *)seriesToken
              sucessed:(void(^)(NSString *joinId,NSString *accessToken,VHClassBaseInfo *result))sucess
                failed:(void(^)(VHCError *error))failed;

/**
 @brief          微吼网校登录，异步函数
 @param roomId   房间id
 @param userId   网校用户id
 @param nickName 用户昵称
 @param resourceType 系列课资源类型 系列课中信息 1、系列课资源类型回放 2、系列课资源类型音视频 3、系列课资源类型课程
 @param resourceId   系列课资源ID
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
              sucessed:(void(^)(NSString *joinId,NSString *accessToken,VHClassBaseInfo *result))sucess
                failed:(void(^)(VHCError *error))failed;


/**
 @brief          离开课堂
 */
+ (void)leaveRoom;

NS_ASSUME_NONNULL_END

@end

