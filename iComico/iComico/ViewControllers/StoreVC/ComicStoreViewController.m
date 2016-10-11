//
//  ComicStoreViewController.m
//  iComico
//
//  Created by ane_it_ios on 16/8/18.
//  Copyright © 2016年 ane_it_ssk. All rights reserved.
//

#import "ComicStoreViewController.h"
#import "ShowWaitView.h"

#import "ComicStoreTool.h"

#import "ContentListView.h"
#import "ComicStoreHeaderView.h"
#import "ComicStoreContentListCollectionView.h"
#import "NewStoreTitleModel.h"
#import "ListContentModel.h"


@interface ComicStoreViewController ()

@property (nonatomic, weak) ShowWaitView *showWaitView; //加载等待画面

@property (nonatomic, strong) NSMutableArray *headerModelArray;
//图书列表模型数据数组
@property (nonatomic, strong) NSMutableArray *listModelArray;
//图书列表页内容模型数据数组
@property (nonatomic, strong) NSMutableArray *listRowContentModelArray;

@property (nonatomic, weak) ContentListView *contentListView;

@property (nonatomic, weak) ComicStoreContentListCollectionView *comicStoreContentListCollectionView;


@end

@implementation ComicStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingBackGround];
    [self initWithContentView];
    [self insertShowWaitView];
    
}

#pragma mark - 初始化控件
- (void)initWithContentView{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.y = 20;
    rect.size.height -= 20;
    ContentListView *contentListView = [[ContentListView alloc]initWithFrame:rect];
    self.contentListView = contentListView;
    [self.view insertSubview:contentListView atIndex:0];
    
}

#pragma mark 加载等待控件
- (void)insertShowWaitView{
    __unsafe_unretained typeof(self) p = self;
    
    ShowWaitView *showWaitView = [[ShowWaitView alloc]initWithOperation:^{
        [p loadModelData];

    }];
    [self.view insertSubview:showWaitView aboveSubview:self.view];
    self.showWaitView = showWaitView;
    
    
    
    [self.showWaitView showWait];
    
}

- (void)loadModelData{
    __unsafe_unretained typeof(self) p = self;
    [[ComicStoreTool sharedRequestTool]requestComicStoreNewModelCompletion:^(NSMutableArray *blockHeaderArray, NSMutableArray*blockListArray) {
        [p.showWaitView removeFromSuperview];
        p.headerModelArray = blockHeaderArray;
        p.listModelArray = blockListArray;
    } failure:^(NSError *error) {
        [p.showWaitView performSelector:@selector(showError) withObject:nil afterDelay:1.5];
    }];
}

- (void)settingBackGround{
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.layer.masksToBounds = YES;
    
    CALayer *backLayer = [CALayer layer];
    backLayer.frame = CGRectMake(0, 0, kScreenWidth, 20);
    backLayer.backgroundColor = UIColorFromRGB(0xFFBF00).CGColor;
//    backLayer.zPosition = 10;
    [self.view.layer addSublayer:backLayer];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; //设置电池栏文字颜色白色
}

#pragma mark - set and get
- (void)setHeaderModelArray:(NSMutableArray *)headerModelArray{
    self.comicStoreContentListCollectionView.headerModelArray = headerModelArray;
    _headerModelArray = headerModelArray;
}

- (void)setListModelArray:(NSMutableArray *)listModelArray{
    _listModelArray = listModelArray;
    self.listRowContentModelArray = listModelArray;
    for (NewStoreTitleModel *listModel in  listModelArray) {
        [self requestDataForContentListWithModel:listModel];
    }
}

- (void)setListRowContentModelArray:(NSMutableArray *)listRowContentModelArray{
    _listRowContentModelArray = listRowContentModelArray;
    self.contentListView.listRowContentModelArray = listRowContentModelArray;
}

- (ComicStoreContentListCollectionView *)comicStoreContentListCollectionView{
    return self.contentListView.comicStoreContentListCollectionView;
}

- (void)requestDataForContentListWithModel:(NewStoreTitleModel *)model{
    NSString *urlString = @"http://api.kuaikanmanhua.com/v1/topics";
    NSDictionary *parameter = @{@"limit": @(model.contentCount),
                                @"offset": @0,
                                @"tag": model.title};
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *array = [ListContentModel modelArrayForDataArray:responseObject[@"data"][@"topics"]];
//        NSLog(@"%@",array);
        model.contentArray = array;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

@end
