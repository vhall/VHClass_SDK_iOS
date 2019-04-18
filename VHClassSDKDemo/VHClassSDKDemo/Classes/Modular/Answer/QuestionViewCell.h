//
//  QuestionViewCell.h
//  VHClassSDKDemo
//
//  Created by vhall on 2019/2/15.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHCQuestion.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionViewCell : UITableViewCell

@property (nonatomic, strong) VHCQuestion *question;

@end

NS_ASSUME_NONNULL_END
