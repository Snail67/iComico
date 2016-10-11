//
//  ComicSearchViewController.m
//  iComico
//
//  Created by ane_it_ios on 16/8/18.
//  Copyright © 2016年 ane_it_ssk. All rights reserved.
//

#import "ComicSearchViewController.h"
#import "DBSphereView.h"

@interface ComicSearchViewController () <UISearchBarDelegate>

@property (nonatomic, retain) DBSphereView *sphereView; //立体三维动画视图
@property (nonatomic, strong) NSArray *searchNameArray;

@property (strong, nonatomic) UISearchBar *searchBar;


@end

@implementation ComicSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self searchNameArrayDataInit];
    [self initSubViews];

    
}

- (void)initSubViews {
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_day.png"]];
    self.view.backgroundColor = color;
    
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; //设置电池栏文字颜色白色
    
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = NO;
    [self.searchBar setTranslucent:YES];
    self.searchBar.placeholder =@"请输入漫画名搜索";
    [self.view addSubview:self.searchBar];
    
    self.sphereView = [[DBSphereView alloc] init];
    self.sphereView.bounds =CGRectMake(0, 100, kScreenWidth, kScreenWidth);
    CGFloat x = CGRectGetMidX([UIScreen mainScreen].bounds);
    CGFloat y = CGRectGetMidY([UIScreen mainScreen].bounds);
    CGPoint point = CGPointMake(x, y+64+40);
    self.sphereView.center = point;
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSInteger i = 0; i < 50; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:_searchNameArray[i * 4 + arc4random()% 4] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];  //[self randomColor]
        btn.titleLabel.font = [UIFont systemFontOfSize:17.];
        
        btn.frame = CGRectMake(0, 0, 100, 34);
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [self.sphereView addSubview:btn];
    }
    [self.sphereView setCloudTags:array];
    [self.view addSubview:self.sphereView];
                             
    
    
}

#pragma mark-颜色随机方法
- (UIColor *)randomColor{
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)buttonPressed:(UIButton *)btn {
    [self.searchBar resignFirstResponder];
    
    
    [self.sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [self.sphereView timerStart];
        }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}


- (void)searchNameArrayDataInit{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SearchNamePlist" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *string = dict[@"online_params"][@"KeyWord"];
    self.searchNameArray = [string componentsSeparatedByString:@","];
//    NSLog(@"self.searchNameArray 数组%@",self.searchNameArray);
}


#pragma mark-UISearchBarDelegate代理方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"点击了搜索输入框 执行方法");
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"搜索文本框变化了 后 文字为=%@",searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索这里是点击搜索执行的方法-键盘serch按钮");
    
    NSLog(@"点击搜索时的文本框=%@",searchBar.text);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索取消按钮的响应"); //在这里暂时没用,被隐藏了
    
}


@end
