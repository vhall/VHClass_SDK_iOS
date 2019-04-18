//
//  VCInteractiveMaskView.h
//  VHClassSDK_bu
//
//  Created by vhall on 2019/2/19.
//  Copyright © 2019 class. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCInteractor.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCInteractiveMaskView : UIView

@property (nonatomic, strong) VCInteractor *actor;

- (void)updateUI;

@end

NS_ASSUME_NONNULL_END
