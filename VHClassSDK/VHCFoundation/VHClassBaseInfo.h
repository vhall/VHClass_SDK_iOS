//
//  VHClassBaseInfo.h
//  VHCFoundation
//
//  Created by vhall on 2018/8/31.
//  Copyright © 2018年 Morris. All rights reserved.
//

#import <Foundation/Foundation.h>

//课程状态 1:上课中 2:预告 3:回放 4：转播 5:已下课
typedef NS_ENUM(NSUInteger,VHClassState) {
    VHClassStateUnkown,
    VHClassStateClassOn,   //上课了
    VHClassStatusTrailer, //预告
    VHClassStatusVod,//回放
    VHClassStatusBroadcast,//转播
    VHClassStatusClassOver //下课了
};

//课堂类型
typedef NS_ENUM(NSInteger,VHClassType) {
    VHClassTypePublicRoom = 0,       //公开课0
    VHClassTypeSmallRoom  = 1,       //小课堂1
    VHClassTypeRecordRoom = 2,       //录播课2
    VHClassTypeSeriesRoom = 3        //系列课3
};

//课程布局
typedef NS_ENUM(NSUInteger,VHClassLayout) {
    VHClassLayoutVideo =1,         //视频布局
    VHClassLayoutDocument =3       //文档布局
};

//登录方式
typedef NS_ENUM(NSInteger,VHLoginType) {
    VHLoginTypeDefault = 0,   //口令登录
    VHLoginTypeOpen,          //无限制登录，只输入昵称即可登录
    VHLoginTypePhoneNum,      //手机号登录
};
/**
 *  活动类型
 */
typedef NS_ENUM(NSInteger,VHCActivityType) {
    VHCActivityType_Flash = 0,    //Flash推流活动
    VHCActivityType_H5    = 1     //H5推流活动
};

//答题信息，用于进入课堂时答题的加载
@interface VHClassAnswerInfo : NSObject
/** 答题id，非空即表示当前正在答题*/
@property (nonatomic, copy) NSString *answing_question_id;
/** question : 答题，answercard : 答题器 */
@property (nonatomic, copy) NSString *bu;
/** 答题h5 url */
@property (nonatomic, copy) NSString *questionnaire_answer;

+ (instancetype)answerInfoWithData:(NSDictionary *)dictionary;
@end

///考试信息，用于进入课堂时考试的加载
@interface VHClassExamInfo : NSObject
/** 是否正在考试  yes 正在考试  no 未在考试 */
@property (nonatomic, assign) BOOL examing;
/** 试卷id  */
@property (nonatomic, copy) NSString *naire_id;
/** 试卷推送状态, 0准备推送, 1 正在推送中,2推送结束,3公布答案 */
@property (nonatomic, assign) NSInteger naire_status;
/** 用户答卷状态, 0 未答题,1主动交接,2 被动交卷, */
@property (nonatomic, assign) NSInteger user_status;
/** 考试发起人id */
@property (nonatomic, copy) NSString *push_user;
/** 考试推送时间 */
@property (nonatomic, copy) NSString *push_time;
/** 考试h5 url */
@property (nonatomic, copy) NSString *questionnaire;

+ (instancetype)examInfoWithData:(NSDictionary *)dictionary;
@end

//插播信息，用于进入课堂时插播视频的加载
@interface VHClassInsertVideoInfo : NSObject
/** 当前是否正在插播 */
@property (nonatomic, assign) BOOL interstitial;
/** 目前正在插播的ID , 当插播未开启时为空字符串 */
@property (nonatomic, copy) NSString *record_id;
/** 目前正在插播资源ID播放到多少秒 ,当插播未开启时为空字符串 */
@property (nonatomic, assign) CGFloat progress_rate;
/** 目前正在插播资源ID是否为暂停状态:1 暂停 0 播放状态 ,当插播未开启时为空字符串 */
@property (nonatomic, assign) BOOL is_pause;

+ (instancetype)insertVideoWithData:(NSDictionary *)dictionary;
@end

//pass信息 access_token等等
@interface VHPassRoomInitInfo : NSObject
/** access_token     */
@property (nonatomic, copy) NSString *access_token;
/** pass房间id     */
@property (nonatomic, copy) NSString *pass_room_id;
/** pass频道id     */
@property (nonatomic, copy) NSString *pass_channel_id;
/** pass互动房间id         */
@property (nonatomic, copy) NSString *pass_inav_id;

+ (instancetype)insertPassWithData:(NSDictionary *)data;
@end


@interface VHClassBroadcastInfo : NSObject

@property(nonatomic, copy) NSString *pass_channel_id;

+ (instancetype)insertBroadcastInfoWithData:(NSDictionary *)data;
@end

///课堂基本信息类
@interface VHClassBaseInfo : NSObject

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, assign) VHCActivityType play_type;
@property (nonatomic, assign) VHCActivityType user_type;
@property (nonatomic, assign) VHClassState state;
@property (nonatomic, assign) VHClassType type;
@property (nonatomic, assign) VHClassLayout layout;
@property (nonatomic, copy)   NSArray  *resourceList;//系列课资源列表
@property (nonatomic, copy)   NSString *seriesToken;
@property (nonatomic, assign) VHLoginType loginType;

@property (nonatomic, copy) NSString *joinId;
@property (nonatomic, copy) NSArray * joinList;//已进入课堂的人员信息

/** 转播信息 */
@property (nonatomic, strong) VHClassBroadcastInfo * broadcast_source;
@property(nonatomic, copy) NSArray *broadcsting_member;
@property (nonatomic, assign) NSInteger broadcast_duration;
@property(nonatomic, assign) NSInteger is_broadcast_now;
@property(nonatomic, assign) NSInteger sync_mode;// 是否转播文档或白板 0:不转播 1：转播

/** 考试信息 */
@property (nonatomic, strong) VHClassExamInfo *examInfo;
/** 正在答题的信息 */
@property (nonatomic, strong) VHClassAnswerInfo *answerInfo;
/** 插播信息 */
@property (nonatomic, strong) VHClassInsertVideoInfo *insertVideoInfo;
/** pass信息 */
@property(nonatomic, strong) VHPassRoomInitInfo *passInfo;
@end

