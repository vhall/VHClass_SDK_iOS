//
//  User.h
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *joinId;//自己的参会id，进入课堂会由微吼SDK分配，再次登录需重置

+ (instancetype)defaultUser;

@end
