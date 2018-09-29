//
//  User.m
//  VHClassSDKDemo
//
//  Created by vhall on 2018/9/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)defaultUser {
    static User *_user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[self alloc] init];
    });
    return _user;
}

@end
