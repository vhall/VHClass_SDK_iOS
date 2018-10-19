//
//  VHCError.h
//  VHClassSDK
//
//  Created by vhall on 2018/8/27.
//  Copyright © 2018年 Morris. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 错误类型枚举值
 */
typedef NS_ENUM(NSInteger,VHCErrorType) {
    /** 成功，无错误 */
    VHCErrorType_NoError = 200,
    
    /** 无效的AppKey，用户未开通SDK服务 */
    VHCErrorType_InvalidAppKey_NoService = 100001,
    /** 无效的AppKey，AppKey已失效，SDK服务已到期 */
    VHCErrorType_InvalidAppKey_UnService = 100002,
    /** 无效的AppSecreatKey */
    VHCErrorType_InvalidAppSecretKey = 100003,
    /** 用户账户余额不足，Api访问受限 */
    VHCErrorType_User_Account_Money_NotEnough = 100004,

    /** 用户使用时未注册SDK */
    VHCErrorType_InvalidRegisteer = 666666,
    /** 发送消息出错，长度超限 */
    VHCErrorType_MsgSendError = 666667,
    /** 无效的课堂id */
    VHCErrorType_InvalidRoomId = 200001,
    /** 参数错误 */
    VHCErrorType_InvalidParam = 400,
    
    /** 当前不在直播状态 */
    VHCErrorType_NoOpenHand = 99999,
    /** 未进入课堂 */
    VHCErrorType_NotEnterClass = 99998,
    /** 重复进入课堂 */
    VHCErrorType_EnterClassAgin = 99997,
    /** 禁止发言 */
    VHCErrorType_CahtBan = 99996,
    /** 当前不在直播状态 */
    VHCErrorType_NoLive = 99995,
    /** 互动直播间出错 */
    VHCErrorType_LiveRoomError = 99994,

    /** 当前不是回放状态 */
    VHCErrorType_NoVOD = 444444,
    /** 没有回放播放器view */
    VHCErrorType_NoVODPlayView = 444445,
    /** 没有播放调度地址 */
    VHCErrorType_NoDispatchUrl = 444446,

    
    /** 进入课堂错误，课堂口令错误等 */
    VHCErrorType_EnterClassError = 300000,
    /** 身份检验出错，SDK目前只支持学员身份进入 */
    VHCErrorType_UserRoleError = 300002,
    /** 被踢出课堂 */
    VHCErrorType_kickout = 300003,
    /** 进入课堂失败，当前该角色人数已达上限 */
    VHCErrorType_EnterInteractiveError_MaxNum = 300004,
    /** 进入课堂失败，设备异常 */
    VHCErrorType_EnterInteractiveError_Devices = 300005,
    /** 进入课堂失败，课堂已被关闭，无法进入 */
    VHCErrorType_EnterRoomError_Closed = 300006,
    /** 进入课堂失败，不支持更多路连麦 */
    VHCErrorType_EnterRoomError_MoreStream = 300007,
    /** 进入课堂失败，人数已达上限 */
    VHCErrorType_EnterRoomError_MaxNum = 300008,
    /** 参会id错误 */
    VHCErrorType_User_JoinIdError = 300009,
    /** 自己被下麦 */
    VHCErrorType_OutInteractive = 99992,
    /** 无效的token */
    VHCErrorType_InvalidToken = 99991,
    /** 进入互动直播间出错 */
    VHCErrorType_EnterInractiveRoomError = 99990,
    /** 推拉流出错 */
    VHCErrorType_PulishOrPullStramError = 99989,
};


///微吼错误类
@interface VHCError : NSObject

/**
 @brief 错误类型
 */
@property (nonatomic, readonly) VHCErrorType errorCode;

/**
 @brief 错误类型描述
 */
@property (nonatomic, copy) NSString *errorDescription;


/**
 @param errorCode 错误类型
 @param description 错误描述，可为空
 @return 错误
 */
+ (VHCError *)errorWithCode:(VHCErrorType)errorCode errorDescription:(NSString *)description;

/**
 @param error 错误
 @return 错误
 */
+ (VHCError *)errorWithNSError:(NSError *)error;

@end
