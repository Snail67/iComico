//
//  ViewController.m
//  iComico
//
//  Created by ane_it_ios on 16/8/17.
//  Copyright © 2016年 ane_it_ssk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITabBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
//    NSArray *array = self.tabBar.items;
//    for (int i = 0; i < array.count; i++) {
//        UITabBarItem *item = array[i];
//        NSString *string = [NSString stringWithFormat:@"tab%d_sel.png", i+1];
//        [item setSelectedImage:[UIImage imageNamed:string]];
//    }
    self.tabBar.tintColor = [UIColor orangeColor];
    [self setSelectedIndex:1];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}



@end
