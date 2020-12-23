//
//  VCInteractiveModel.m
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/20.
//  Copyright © 2019 class. All rights reserved.
//

#import "VCInteractiveModel.h"
#import <VHClassSDK/VHRenderView.h>

@implementation VCInteractiveModel

- (void)getAttendMaskViewWithUserId:(NSString *)userId
                             sucess:(void(^)(VCInteractiveMaskView *maskView))sucess
                             failed:(void(^)(VHCError *error,VCInteractiveMaskView *maskView))failed
{
    [VHCLiveUser getLiveUserInfoWithJoinId:userId sucessed:^(VHCLiveUser * _Nonnull user) {
        
        VCInteractor *tor = [[VCInteractor alloc] init];
        tor.nickName = user.nickName;
        tor.micphoneClose = user.micphoneClose;
        tor.cameraClose = user.cameraClose;
        tor.userRole = user.userRole;
        tor.joinId = userId;

        VCInteractiveMaskView *maskView = [[VCInteractiveMaskView alloc] initWithFrame:CGRectZero];
        maskView.actor = tor;
        maskView.tag = VCInteractiveVideoMaskViewTag;

        if (sucess) {
            sucess(maskView);
        }
    } failed:^(VHCError * _Nonnull error) {
        
        VCInteractor *tor = [[VCInteractor alloc] init];
        tor.nickName = @"";
        tor.micphoneClose = NO;
        tor.cameraClose = NO;
        tor.userRole = VHCLiveUserRoleStudent;
        tor.joinId = userId;

        VCInteractiveMaskView *maskView = [[VCInteractiveMaskView alloc] initWithFrame:CGRectZero];
        maskView.tag = VCInteractiveVideoMaskViewTag;
        maskView.actor = tor;
        
        if (failed) {
            failed(error,maskView);
        }
    }];
}

- (void)getMyAttendMaskViewWithCameraView:(VHRenderView *)cameraView
                                   sucess:(void(^)(VCInteractiveMaskView *maskView))sucess
{
    VCInteractor *tor = [[VCInteractor alloc] init];
    tor.nickName = [VCCourseData shareInstance].nickName;
    tor.micphoneClose = NO;
    tor.cameraClose = NO;
    tor.userRole = VHCLiveUserRoleStudent;
    tor.joinId = [VCCourseData shareInstance].joinId;
    
    VCInteractiveMaskView *maskView = [[VCInteractiveMaskView alloc] initWithFrame:CGRectZero];
    maskView.actor = tor;
    maskView.tag = VCInteractiveVideoMaskViewTag;
    
    if (sucess) {
        sucess(maskView);
    }
}


- (NSString *)audioAlertMsgWithMicrophoneClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId
{
    NSString *msg = nil;
    if (!toUserId) {
        msg = isClose ? @"开启全体静音" : @"解除全体静音";
    }
    else
    {
        if ([toUserId isEqualToString:VH_userId])
        {
            msg = (isClose ? @"您已被静音" : @"您已被解除静音");
        }
    }
    return msg;
}
- (NSString *)videoAlertMsgWithMicrophoneClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId
{
    if ([toUserId isEqualToString:VH_userId])
    {
        NSString *msg = (isClose ? @"您已被禁止画面" : @"您已被解除禁止画面");
        return msg;
    }
    return nil;
}


- (VHRenderView *)isHaveAttender:(VHRenderView *)view {
    for (VHRenderView * v in self.attenderViews) {
        if (v.streamType == view.streamType && [v.userId isEqualToString:view.userId]) {
            return v;
            break;
        }
    }
    return nil;
}
- (void)saveAttenderView:(VHRenderView *)view {
    [self.attenderViews addObject:view];
}
- (void)removeAttenderView:(VHRenderView *)view {
    if ([self.attenderViews containsObject:view]) {
        [self.attenderViews removeObject:view];
    }
}


- (NSMutableArray *)attenderViews {
    if (!_attenderViews) {
        _attenderViews = [[NSMutableArray alloc] init];
    }
    return _attenderViews;
}

@end
