//
//  VHCMsg.h
//  VHCMessage
//
//  Created by vhall on 2018/9/14.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHCMsg : NSObject

/** 发消息用户id*/
@property (nonatomic, copy) NSString *joinId;
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

@end
