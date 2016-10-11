//
//  ShowWaitView.m
//  iComico
//
//  Created by ane_it_ios on 16/8/19.
//  Copyright © 2016年 ane_it_ssk. All rights reserved.
//

#import "ShowWaitView.h"
#import "MONActivityIndicatorView.h"
#import "Reachability.h"

typedef enum : NSUInteger {
    waitStatic = 0,
    errorStatic

} ShowStatic;

@interface ShowWaitView () <MONActivityIndicatorViewDelegate>

@property (nonatomic, copy) void(^operation)();

@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation ShowWaitView

- (instancetype)initWithOperation:(void(^)())operation{
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self = [super initWithFrame:rect];
    if (self) {
        
        UIImage *image = [UIImage imageNamed:@"back_day.png"];
        self.layer.contents = (id)image.CGImage;
        
        [self addSubview:self.indicatorView];
        [self addSubview:self.label];
        [self addNotificationServer];
        self.operation = operation;
    }
    
    return self;
}

- (void)setOperation:(void (^)())operation{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showWait)];
    [self addGestureRecognizer:gesture];
    _operation = operation;
}

#pragma mark -showWait方法
- (void)showWait {
    [self.indicatorView startAnimating];  //彩色等待刷新 动画开启
    self.label.transform = CGAffineTransformIdentity;
    self.label.text = @"正在拼命加载数据\n请稍候!";
    
    self.imageErrorView.hidden = YES;
    self.userInteractionEnabled = NO;
    self.operation();
    
    CGFloat y = self.indicatorView.frame.origin.y + self.indicatorView.frame.size.height;
    CGPoint labelPosition = CGPointMake(kScreenWidth/2, y);
    self.label.layer.position = labelPosition;
}


#pragma mark - showError方法
- (void)showError {
    [self.indicatorView stopAnimating];
    self.label.text = @"点击重试";
    self.imageErrorView.hidden = NO;
    self.indicatorView.hidden = YES;
    self.userInteractionEnabled = YES;
    
    CGFloat y = self.indicatorView.frame.origin.y + self.imageErrorView.bounds.size.height/2;
    CGPoint labelPosition = CGPointMake(kScreenWidth/2, y);
    self.label.layer.position = labelPosition;
    self.imageErrorView.center = labelPosition;
    
    
}


//五彩 下拉刷新等待动画的懒加载
-(MONActivityIndicatorView *)indicatorView{
    if(!_indicatorView){
        _indicatorView = [[MONActivityIndicatorView alloc]init];
        _indicatorView.delegate = self;
        _indicatorView.numberOfCircles = 6;  //显示几个圆圈
        _indicatorView.radius =9;
        _indicatorView.internalSpacing =5;  //几个彩色之间的距离
        _indicatorView.center =self.center;
    }
    return _indicatorView;
}

#pragma mark - MONActivityIndicatorViewDelegate的代理方法
- (UIColor*)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index{
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//label的懒加载
- (UILabel *)label{
    if (_label == nil) {
        CGFloat y = self.indicatorView.frame.origin.y + self.indicatorView.frame.size.height;
        CGRect rect = CGRectMake(0, 0, 200, 50);
        _label = [[UILabel alloc]initWithFrame:rect];
        _label.layer.position = CGPointMake(kScreenWidth/2, y);
        _label.layer.anchorPoint = CGPointMake(0.5, 0);
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor lightGrayColor];
        _label.numberOfLines = 0;
        [_label setTextAlignment:NSTextAlignmentCenter];
    }
    return _label;
}

//imageErrorView的懒加载
- (UIImageView *)imageErrorView{
    if (_imageErrorView == nil) {
        UIImage *image = [UIImage imageNamed:@"data_loading_error"];
        _imageErrorView = [[UIImageView alloc]initWithImage:image];
        _imageErrorView.layer.position = self.label.layer.position;
        _imageErrorView.layer.anchorPoint = CGPointMake(0.5, 1);
        _imageErrorView.hidden = YES;
        [self insertSubview:_imageErrorView atIndex:0];
    }
    return _imageErrorView;
}

//网络监测
- (void)addNotificationServer{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWait) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.internetReachability startNotifier];
}

#pragma mark-移除网路监测的通知
- (void)dealloc {
    NSLog(@"ShowWaitView被销毁");
    //移除网路监测的通知
    [self.internetReachability stopNotifier];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
