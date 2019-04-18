//
//  VHActionSheet.h
//  VHiPad
//
//  Created by vhall on 2018/5/21.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VHActionSheet;


@protocol VHActionSheetDelegate <NSObject>

- (void)actionSheet:(VHActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index;

@end


///邀请上麦弹窗
@interface VHActionSheet : UIView

@property (nonatomic, weak) id <VHActionSheetDelegate> delegate;

- (VHActionSheet *)initWithTitle:(NSString *)title
                        delegate:(id)delegate
                             tag:(NSUInteger)tag
                    buttonTitles:(NSArray *)buttonTitles;

- (void)show;

@end
