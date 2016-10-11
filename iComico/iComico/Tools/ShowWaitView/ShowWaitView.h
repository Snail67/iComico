//
//  ShowWaitView.h
//  iComico
//
//  Created by ane_it_ios on 16/8/19.
//  Copyright © 2016年 ane_it_ssk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MONActivityIndicatorView;

@interface ShowWaitView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageErrorView;

@property (nonatomic, strong) MONActivityIndicatorView *indicatorView;


- (void)showWait;
- (void)showError;

- (instancetype)initWithOperation:(void(^)())operation;

@end
