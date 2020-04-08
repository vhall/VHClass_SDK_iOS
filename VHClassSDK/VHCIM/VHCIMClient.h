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
#import "VHCQuestion.h"
#import "VHCAnnouncement.h"

NS_ASSUME_NONNULL_BEGIN

@class VHCIMClient;

///VHCIMClientDelegate协议定义了消息的回调方法。使用讨论功能、答题功能、公告功能需要添加代理，监听回调事件。
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


/**
 @brief 问卷消息回调
 */
- (void)imClient:(VHCIMClient *)client questionMsg:(VHCQuestion *)question;

/**
 @brief 公告消息回调
 */
- (void)imClient:(VHCIMClient *)client announcementMsg:(VHCAnnouncement *)announcement;

@end


///微吼聊天服务类。该类定义了微吼聊天消息对象的获取、连接聊天服务等Api，并通过代理的方式转发收到的聊天消息。
@interface VHCIMClient : NSObject

@property (nonatomic, assign) BOOL isBan;//是否被讲师禁言

@property (nonatomic, assign) BOOL isTotalBan;//是否全体禁言

#pragma mark - about life circel
/**
 @brief 获取聊天服务单例对象
 @discussion 可通过此方法获取聊天服务单例对象，可通过添加代理的形式将消息广发至每个类。如果不再使用聊天服务，可通过- destoryIMClient方法释放内存占用。
 */
+ (VHCIMClient *)sharedIMClient;

/**
 @brief 连接聊天服务，异步函数
 @warning 重新连接后会移除之前的所有代理指针
 */
- (void)connectWithComplete:(void(^)(VHCError *error))failed;

/**
 @brief 获取number条聊天数据，异步函数
 @discussion 异步函数，结果通过block回调
 @param number 获取条数
 @param msgArray 获取成功回调
 @param failed 失败回调
 */
- (void)getLatestMsgWithNum:(NSUInteger)number
                 completion:(void(^)(NSArray <VHCMsg*> *result))msgArray
                     failed:(void(^)(VHCError *error))failed;

/**
 @brief 分页获取聊天数据，异步函数
 @param page 页数
 @param size 每页数据条数，每页最多可获取200条
 @param msgArray 获取成功回调
 @param failed 失败回调
 */
- (void)getChatMsgWithPageNum:(NSUInteger)page
                     pageSize:(NSUInteger)size
                   completion:(void(^)(NSArray <VHCMsg*> *result))msgArray
                       failed:(void(^)(VHCError *error))failed;
/**
@brief 分页获取私聊数据，异步函数
@param lastChatId 上次chatid
@param size 每页数据条数，每页最多可获取200条
@param toUserId 私聊对方ID
@param msgArray 获取成功回调
@param failed 失败回调
*/
- (void)getPrivateChatMsgWithChatId:(NSString*)lastChatId
                            pageSize:(NSUInteger)size
                            toUserId:(NSString*)toUserId
                          completion:(void(^)(NSArray <VHCMsg*> *result))msgArray
                              failed:(void(^)(VHCError *error))failed;


/**
@brief 获取聊天分组，异步函数
@param msgArray 获取成功回调
@param failed 失败回调
*/
- (void)getPrivateChatGroupCompletion:(void(^)(NSArray <VHCGroupMsg*> *result))msgArray
                              failed:(void(^)(VHCError *error))failed;

/**
@brief 设置为已读
@param toUserId 私聊对方ID
@param failed 失败回调
*/
- (void)setReadGroupWithUserId:(NSString*)toUserId
                    completion:(void(^)(VHCError *error))failed;

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
/**
@brief 发送私聊消息
@warning 最长200字
@param toUserId toUserId 私聊对方ID
*/
- (void)sendMsg:(NSString *)msg
       toUserId:(NSString*)toUserId
        success:(void(^)(void))success
        failure:(void(^)(VHCError *error))failure;

/**
@brief 设置为已读状态
@param toUserId toUserId 私聊对方ID
*/
- (void)resetMsg:(NSString*)toUserId
        success:(void(^)(void))success
        failure:(void(^)(VHCError *error))failure;

#pragma mark - commit answer

/**
 @brief 提交问卷答案，异步函数
 @param quId 问题id
 @param answers 答案id数组
 */
- (void)commitAnswerWithQuestionId:(NSString *)quId
                            answer:(NSArray<__kindof NSString *> *)answers
                           success:(void(^)(void))success
                           failure:(void(^)(VHCError *error))failure;


@end


NS_ASSUME_NONNULL_END
