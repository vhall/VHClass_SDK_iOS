//
//  VCInteractiveModel.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/20.
//  Copyright © 2019 class. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHClassSDK/VHCLiveUser.h>
#import "VCInteractiveMaskView.h"
#import <VHClassSDK/VHRenderView.h>

@class VHRenderView;

NS_ASSUME_NONNULL_BEGIN

@interface VCInteractiveModel : NSObject


- (void)getAttendMaskViewWithUserId:(NSString *)userId
                             sucess:(void(^)(VCInteractiveMaskView *maskView))sucess
                             failed:(void(^)(VHCError *error,VCInteractiveMaskView *maskView))failed;

- (void)getMyAttendMaskViewWithCameraView:(VHRenderView *)cameraView
                                   sucess:(void(^)(VCInteractiveMaskView *maskView))sucess;



- (NSString *)audioAlertMsgWithMicrophoneClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId;
- (NSString *)videoAlertMsgWithMicrophoneClosed:(BOOL)isClose byUser:(NSString *)byUserId toUser:(NSString *)toUserId;



///去重复的流
@property (nonatomic, strong) NSMutableArray *attenderViews;
- (VHRenderView *)isHaveAttender:(VHRenderView *)view;
- (void)saveAttenderView:(VHRenderView *)view;
- (void)removeAttenderView:(VHRenderView *)view;


@end

NS_ASSUME_NONNULL_END
