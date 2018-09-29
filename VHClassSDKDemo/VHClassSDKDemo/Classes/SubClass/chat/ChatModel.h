//
//  ChatModel.h
//  ChatUIDemo
//
//  Created by vhall on 2018/5/8.
//  Copyright © 2018年 Morris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHCMsg.h"

@class ChatFrameModel;

typedef NS_ENUM(NSInteger,MSGTypeBy) {
    MSGTypeByOwn,
    MSGTypeByOther
};

///聊天数据模型
@interface ChatModel : NSObject

@property (nonatomic, copy) NSString *joinId;
@property (nonatomic, copy) NSString *nickName;
@property (nullable ,nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *text;


@property (nonatomic, assign) CGFloat cellHeight;//cell行高

@property (nonatomic, assign) MSGTypeBy msgTypeBy;//消息类型

@property (nonatomic, strong, nonnull) ChatFrameModel *frameModel;//坐标信息model

- (void)setAttributesWithData:(VHCMsg *)msg;

@end


///坐标数据模型
@interface ChatFrameModel : NSObject

@property (nonatomic, assign) CGRect nickNameLableFrame;
@property (nonatomic, assign) CGRect headerImgViewFrame;
@property (nonatomic, assign) CGRect contentBtnFrame;

@end
