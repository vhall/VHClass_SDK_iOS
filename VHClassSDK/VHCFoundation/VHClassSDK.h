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

//微吼课堂用户主要事件枚举
typedef NS_ENUM(NSInteger,VHCUserEvent) {
    /** 进入课堂*/
    VHCUserEventEnter,
    /** 离开课堂*/
    VHCUserEventLeave,
    /** 开始观看（直播/回放）*/
    VHCUserEventLiveStart,
    /** 结束观看（直播/回放）*/
    VHCUserEventLiveEnd,
    /** 开始互动*/
    VHCUserEventInteractiveStart,
    /** 结束互动*/
    VHCUserEventInteractiveEnd,
    /** 被主播踢出课堂*/
    VHClassMainEventKickout,
};

@class VHClassSDK;

NS_ASSUME_NONNULL_BEGIN

///课堂管理类协议，该类定义了课堂状态的回调以及课堂当前需要进行的行为回调等
@protocol VHClassSDKDelegate <NSObject>

@optional
/**
 @brief 课堂状态变化回调
 @param curState 改变后的课堂状态，即当前课堂状态
 @discussion 用户可根据此状态进行其他业务操作，比如当课堂状态为正在上课，则可以进行观看直播。
 */
- (void)vhclass:(VHClassSDK *)sdk classStateDidChanged:(VHClassState)curState;

/**
 @brief 主要事件回调
 @param curEvent 改变后的事件
 */
- (void)vhclass:(VHClassSDK *)sdk userEventChanged:(VHCUserEvent)curEvent;

@end


///课堂管理类，通过此类获取课堂基本信息、进入课堂等操作。
@interface VHClassSDK : NSObject

@property (nonatomic, weak) id <VHClassSDKDelegate> delegate;

/**
 @brief 返回课堂单例对象
 */
+ (VHClassSDK *)sharedSDK;
/**
 @brief 获取sdk版本号
 */
+ (NSString *)getSDKVersion;

/**
 @brief 初始化微吼课堂SDK
 @param appKey 即用户在微吼平台上注册的AppKey
 @param secretKey 即用户在微吼平台上注册生成的AppSecretKey
 @param isProduction 是否生产环境. 如果为开发状态,设置为NO; 如果为生产状态,应改为YES，默认为NO
 @warning 使用SDK其他类时，务必确保SDK先初始化。
 */
- (void)initWithAppKey:(NSString *)appKey
          appSecretKey:(NSString *)secretKey
      apsForProduction:(BOOL)isProduction;
/**
 @brief 获取课堂基本信息，异步函数
 @param roomId   课堂id
 @param sucess   成功，返回课堂基本信息  @see VHClassSDKBaseInfo
 @param failed    获取出错，返回错误信息
 */
- (void)classBaseInfoWithRoomId:(nonnull NSString *)roomId
                       sucessed:(void(^)(VHClassBaseInfo *result))sucess
                         failed:(void(^)(VHCError *error))failed;
/**
 @brief          进入课堂房间，异步函数
 @param roomId   要进入的房间id
 @param keyValue 要进入的房间口令，即进入房间的密码
 @param nickName 用户昵称
 @param sucess   进入成功，返回“参会id”，参会id即用户再此课堂中的用户id
 @param failed   进入失败，返回失败原因
 */
- (void)joinClassWithNickName:(nonnull NSString *)nickName
                       roomId:(nonnull NSString *)roomId
                          key:(nonnull NSString *)keyValue
                     sucessed:(void(^)(NSString *joinId,VHClassBaseInfo *result))sucess
                       failed:(void(^)(VHCError *error))failed;
/**
 @brief 退出课堂
 @discussion 退出课堂将关闭与课堂相关的系统消息
 @warning 离开课堂时请务必调用此方法
 */
- (void)leaveRoom;

NS_ASSUME_NONNULL_END

@end

