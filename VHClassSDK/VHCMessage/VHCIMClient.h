//
//  VHCIMClient.h
//  VHClassSDK
//
//  Created by vhall on 2018/8/28.
//  Copyright © 2018年 Morris. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "VHCMsg.h"
#import "VHCError.h"

@class VHCIMClient;

///VHCIMClientDelegate协议定义了消息的回调方法，聊天服务器连接的回调，通过此协议用户接收微吼聊天服务中其他人的聊天消息。
@protocol VHCIMClientDelegate <NSObject>

@optional
/**
 @brief 收到聊天消息
 */
- (void)imClient:(VHCIMClient *)client event:(NSString *)event message:(VHCMsg *)message;
/**
 @brief 错误回调，包括连接错误、发言错误等
 */
- (void)imClient:(VHCIMClient *)client error:(VHCError *)error;

/**
 @brief 主播端禁止某用户发言回调
 @param isBan       YES：被禁言，NO：被取消禁言
 @param joinId      被禁言用户的参会id，全体禁言此id为空
 @warning    讲师端对某禁言/取消禁言，会回调此方法，首次进入聊天也会回调该状态。
 */
- (void)imClient:(VHCIMClient *)client banToChat:(BOOL)isBan withJoinId:(NSString *)joinId;

/**
 @brief 全体禁止发言状态改变回调
 @param isSilence   是否全体禁言,YES：主播开启了全体禁言，NO：主播取消了全体禁言
 @discussion 主播端开启/关闭全体禁言会回调此方法。首次进入聊天也会回调该状态。
 */
- (void)imClient:(VHCIMClient *)client wholeUserIsBan:(BOOL)isSilence;

@end


///微吼聊天服务类。该类定义了微吼聊天消息对象的获取、连接聊天服务等Api，并通过代理的方式转发收到的聊天消息。
@interface VHCIMClient : NSObject

/** 是否全体禁止发言，YES：讲师开启了全体禁言*/
@property (nonatomic, assign, readonly) BOOL isSilence;

/** 自己是否被讲师禁止发言,YES：自己被讲师禁止发言*/
@property (nonatomic, assign, readonly) BOOL isBan;

#pragma mark - about life circel
/**
 @brief 获取聊天服务单例对象
 @discussion 可通过此方法获取聊天服务单例对象，可通过添加代理的形式将消息广发至每个类。如果不再使用聊天服务，可通过- destoryIMClient方法释放内存占用。
 */
+ (VHCIMClient *)sharedIMClient;

/**
 @brief 连接聊天服务
 @warning 用户不用担心连接断开问题，SDK内部已做重连处理。需先进入课堂后才能使用。
 */
- (void)connect;

/**
 @brief 获取最新n条的聊天数据，异步函数
 @discussion 异步函数，结果通过block回调
 @param number 获取条数
 @param msgArray 获取成功回调
 @param failed 失败回调
 */
- (void)getLatestMsgWithNum:(NSUInteger)number
                 completion:(void(^)(NSArray <VHCMsg*> *result))msgArray
                     failed:(void(^)(VHCError *error))failed;

/**
 @brief 释放该单例对象
 @warning 如果不在使用IM，可以调用此方法，断开IM连接，并释放该单例对象。
 */
- (void)destoryIMClient;

#pragma mark - about delegate

/**
 @brief 添加代理
 @warning 添加的代理，需手动要移除
 */
- (void)addDelegate:(id<VHCIMClientDelegate>)delegate;
/**
 移除代理
 @warning 切记要手动移除代理指针
 */
- (void)removeDelegate:(id<VHCIMClientDelegate>)delegate;


#pragma mark - send message
/**
 @brief 发送消息
 @warning 最长200字
 */
- (void)sendMsg:(NSString *)msg
        success:(void(^)(void))success
        failure:(void(^)(VHCError *error))failure;

@end
