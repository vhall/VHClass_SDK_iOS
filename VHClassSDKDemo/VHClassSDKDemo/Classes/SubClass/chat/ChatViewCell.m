//
//  ChatViewCell.m
//  ChatUIDemo
//
//  Created by vhall on 2018/5/8.
//  Copyright © 2018年 Morris. All rights reserved.
//

#import "ChatViewCell.h"
#import "ChatModel.h"

@implementation ChatViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //添加昵称显示label
        self.nickNameLable = [[UILabel alloc] init];
        self.nickNameLable.font = [UIFont systemFontOfSize:10.0];
        self.nickNameLable.textAlignment = NSTextAlignmentCenter;
        self.nickNameLable.textColor = [UIColor purpleColor];
        [self.contentView addSubview:self.nickNameLable];
        
        //添加头像显示view
        self.headerImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerImgView];
        
        //添加显示文字的按钮
        self.contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.contentBtn.titleLabel.numberOfLines = 0;
        self.contentBtn.titleLabel.textColor = [UIColor redColor];
        self.contentBtn.titleEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        self.contentBtn.enabled = NO;
        [self.contentView addSubview:self.contentBtn];
    }
    return self;
}

- (void)setMsg:(ChatModel *)model {
    
    _nickNameLable.frame = model.frameModel.nickNameLableFrame;
    _headerImgView.frame = model.frameModel.headerImgViewFrame;
    _contentBtn.frame = model.frameModel.contentBtnFrame;
    
    _headerImgView.layer.cornerRadius = _headerImgView.frame.size.height*0.5;
    //自己的消息
    if (model.msgTypeBy == MSGTypeByOwn) {
        //拉伸图片的方法(固定图片的位置,其他部分被拉伸)
        UIImage *bgImg = [[UIImage imageNamed:@"chat_msg_send_me"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 32, 28, 32) resizingMode:UIImageResizingModeStretch];
        [_contentBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
        
        _headerImgView.backgroundColor = [UIColor colorWithHex:@"52cc90"];
    }
    //别人的消息
    else {
        UIImage *bgImg = [[UIImage imageNamed:@"chat_msg_send_other"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 32, 28, 32) resizingMode:UIImageResizingModeStretch];
        [_contentBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
        
        _headerImgView.backgroundColor = [UIColor lightGrayColor];
    }
    
    _nickNameLable.text = model.nickName;
    [_contentBtn setTitle:model.text forState:UIControlStateNormal];//设置内容
}

@end
