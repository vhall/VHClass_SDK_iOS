//
//  VHCMsg.h
//  VHCMessage
//
//  Created by vhall on 2018/9/14.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHCMsg : NSObject

/** 发消息用户id*/
@property (nonatomic, copy) NSString *joinId;
/** 消息id*/
@property (nonatomic, copy) NSString *msgId;
/** 发消息用户的参会昵称*/
@property (nonatomic, copy) NSString *nickName;
/** 发消息用户角色（主持人、嘉宾、助手、观众（学员））*/
@property (nonatomic, assign) NSInteger role;
/** 发消息用户的头像地址,无头像地址时候为空字符串*/
@property (nullable ,nonatomic, copy) NSString *avatar;
/** 发消息时候所在的房间id*/
@property (nonatomic, copy) NSString *roomId;
/** 发消息时时间*/
@property (nonatomic, copy) NSString *time;
/** 消息内容*/
@property (nonatomic, copy) NSString *text;
/** 消息event*/
@property (nonatomic, copy) NSString *event;
/** 是否私聊*/
@property (nonatomic, assign) BOOL isPrivateChat;
/** 私聊接收用户id*/
@property (nonatomic, copy) NSString *toId;
/** 图片数组*/
@property(nonatomic, strong) NSArray * img_list;
@end

@interface VHCGroupMsg : NSObject

/** 组 id*/
@property (nonatomic, copy) NSString *groupId;
/** 组名*/
@property (nonatomic, copy) NSString *groupName;
/** 未读数*/
@property (nonatomic, assign) NSInteger noReadNum;
/** 角色*/
@property (nonatomic, assign) NSInteger roleType;

@property (nonatomic, strong) NSArray *lastChat;

@end

NS_ASSUME_NONNULL_END
