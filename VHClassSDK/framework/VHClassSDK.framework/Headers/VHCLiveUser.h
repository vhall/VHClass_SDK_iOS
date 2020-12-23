//
//  VHCLiveUser.h
//  VHCFoundation
//
//  Created by vhall on 2019/2/20.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//用户角色 1:老师 2:学员 3:助教 4:嘉宾 5:监课，如果不关注角色请设为0
typedef NS_ENUM(NSUInteger, VHCLiveUserRole) {
    VHCLiveUserRoleUser,     //普通用户
    VHCLiveUserRoleHost,     //讲师(主持人)
    VHCLiveUserRoleStudent,  //学员
    VHCLiveUserRoleHelper,
    VHCLiveUserRoleGuest,
    VHCLiveUserRoleSupervise,
};

@interface VHCLiveUser : NSObject

/** 用户参会id*/
@property (nonatomic, copy) NSString *joinId;
/** 用户昵称*/
@property (nonatomic, copy) NSString *nickName;
/** 用户角色*/
@property (nonatomic, assign) VHCLiveUserRole userRole;
/** 麦克风状态*/
@property (nonatomic, assign) BOOL micphoneClose;//YES:关闭状态
/** 摄像头状态*/
@property (nonatomic, assign) BOOL cameraClose;//YES:关闭状态
/** 奖励数*/
@property (nonatomic, assign) int rewardNum;//奖励数

/**
 @brief          获取joinId对应的用户的基础信息，异步函数
 @param joinId   用户参会id
 @param sucess   登录成功，返回用户信息
 @param failed   登录失败，返回失败原因
 */
+ (void)getLiveUserInfoWithJoinId:(NSString *)joinId
                         sucessed:(void(^)(VHCLiveUser *user))sucess
                           failed:(void(^)(VHCError *error))failed;

@end

NS_ASSUME_NONNULL_END
