//
//  ChatModel.m
//  ChatUIDemo
//
//  Created by vhall on 2018/5/8.
//  Copyright © 2018年 Morris. All rights reserved.
//

#import "ChatModel.h"

#define kDistance 8               //边距
#define kHeaderImgViewHeight   40 //头像的宽高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation ChatModel

- (void)setAttributesWithData:(VHCMsg *)msg {

    self.nickName = msg.nickName;
    self.text = msg.text;
    self.avatar = msg.avatar;
    self.joinId = msg.joinId;
    
    if ([self.joinId isEqualToString:[VCCourseData shareInstance].joinId]) {
        self.msgTypeBy = MSGTypeByOwn;
    } else {
        self.msgTypeBy = MSGTypeByOther;
    }
    
    CGRect msgRect = [self rectWithText:self.text];
    
    ChatFrameModel *frameModel = [[ChatFrameModel alloc] init];
    if (self.msgTypeBy == MSGTypeByOwn) {
        
        frameModel.headerImgViewFrame = CGRectMake(kScreenWidth-kDistance-kHeaderImgViewHeight, kDistance, kHeaderImgViewHeight, kHeaderImgViewHeight);
        
        frameModel.nickNameLableFrame = CGRectMake(frameModel.headerImgViewFrame.origin.x, frameModel.headerImgViewFrame.origin.y + frameModel.headerImgViewFrame.size.height + kDistance, frameModel.headerImgViewFrame.size.width, 20);
        
        frameModel.contentBtnFrame = CGRectMake(kScreenWidth- kDistance -kHeaderImgViewHeight - kDistance - msgRect.size.width - 20*2, kDistance, msgRect.size.width+20*2, msgRect.size.height+20*2);
        //Cell里面设置了contentBtn的文字的titleEdgeInsets边距都为20,所以,宽和高需要+20*2,x需要-20x2)
    }
    else {
        
        frameModel.headerImgViewFrame = CGRectMake(kDistance, kDistance, kHeaderImgViewHeight, kHeaderImgViewHeight);
        
        frameModel.nickNameLableFrame = CGRectMake(CGRectGetMinX(frameModel.headerImgViewFrame), frameModel.headerImgViewFrame.origin.y + frameModel.headerImgViewFrame.size.height + kDistance, frameModel.headerImgViewFrame.size.width, 20);
        
        frameModel.contentBtnFrame = CGRectMake(CGRectGetMaxX(frameModel.headerImgViewFrame)+kDistance, kDistance, msgRect.size.width+20*2, msgRect.size.height+20*2);
    }
    
    //cell的高
    self.cellHeight = MAX(CGRectGetMaxY(frameModel.contentBtnFrame), CGRectGetMaxY(frameModel.nickNameLableFrame));
    
    self.frameModel = frameModel;
}


- (CGRect)rectWithText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(kScreenWidth * 0.6, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                              context:nil];
}

@end




@implementation ChatFrameModel



@end



