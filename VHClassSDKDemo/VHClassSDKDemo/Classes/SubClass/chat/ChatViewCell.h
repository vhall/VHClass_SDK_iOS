//
//  ChatViewCell.h
//  ChatUIDemo
//
//  Created by vhall on 2018/5/8.
//  Copyright © 2018年 Morris. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatModel;

@interface ChatViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nickNameLable;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UIButton *contentBtn;

- (void)setMsg:(ChatModel *)model;

@end
