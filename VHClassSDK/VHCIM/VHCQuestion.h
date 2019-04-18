//
//  VHCQuestion.h
//  VHCIM
//
//  Created by vhall on 2019/2/15.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCMsg.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VHCQuestionState) {
    VHCQuestionStatePublish,    //发布问卷
    VHCQuestionStateAnswers,    //公布答案
    VHCQuestionStateStop,       //结束答题
};
typedef NS_ENUM(NSInteger,VHCQuestionItemIsRight) {
    VHCQuestionItemIsRight_Unknow,    //未知
    VHCQuestionItemIsRight_Yes,       //正确
    VHCQuestionItemIsRight_NO,        //错误
};


@interface VHCQuestionItem : NSObject

@property (nonatomic, copy) NSString *itmeId;//选项id
@property (nonatomic, copy) NSString *itmeText;//选项题目
@property (nonatomic, assign) VHCQuestionItemIsRight isRight;

@end


@interface VHCQuestion : VHCMsg

@property (nonatomic, copy) NSString *questionId;//问题id
@property (nonatomic, copy) NSString *questionText;//问题内容subject
@property (nonatomic, assign) VHCQuestionState state;//当前答题进程
@property (nonatomic, copy) NSArray<__kindof VHCQuestionItem *> *itmeArr;//选项

@end

NS_ASSUME_NONNULL_END
