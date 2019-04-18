//
//  QuestionViewCell.m
//  VHClassSDKDemo
//
//  Created by vhall on 2019/2/15.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "QuestionViewCell.h"

@interface QuestionViewCell ()

@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation QuestionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.selectedButton.frame = CGRectMake(self.frame.size.width-40-16, self.frame.size.height*0.5-20, 40, 40);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectedButton setImage:[UIImage imageNamed:@"balanceBtnNormal"] forState:UIControlStateNormal];
        [self.selectedButton setImage:[UIImage imageNamed:@"balanceBtnSelected"] forState:UIControlStateSelected];
        [self.selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectedButton];
    }
    return self;
}

- (void)selectedButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

@end
