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
    VHClassStatusTrailer,
    VHClassStatusVod,
    VHClassStatusBroadcast,
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

///课堂基本信息类
@interface VHClassBaseInfo : NSObject

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, assign) VHClassState state;
@property (nonatomic, assign) VHClassType type;
@property (nonatomic, assign) VHClassLayout layout;

@end

