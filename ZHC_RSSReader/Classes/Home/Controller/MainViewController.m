//
//  ViewController.m
//  4DAGEVR_demo
//
//  Created by 4DAGE_HUA on 16/5/5.
//  Copyright © 2016年 4DAGE. All rights reserved.
//

#import "MainViewController.h"
#import "XmlModel.h"
#import "FeedStore.h"
#import "RssDetailViewController.h"
#import "ONOXMLDocument.h"
#import "FeedDB.h"
#import "FeedManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FeedCell.h"
#import "ReadFeedViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

// 列表
@property (nonatomic, strong) UITableView *rssTableView;

// 存储模型的数组
@property (nonatomic, strong) NSMutableArray <XmlModel *> *dataArray;

// 抓取feed计数
@property (nonatomic) NSUInteger fetchingCount;

@end

@implementation MainViewController
#pragma mark - 初始化
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.translucent = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Main";
    //设置右上角添加任务
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self setUpData];
    [self setUpTableView];
}

- (void)setUpData{
    
    // 本地查询,数据库
    /*
     * 1. 遍历数据库，把数据库的所有model组成数组，赋值给数据源
     * 2. 如果返回空，则调用Manager加入默认数组并赋值到数据源
     */
    // 绑定对象的某个属性，只要信号发送，信号内容就赋值给属性(map:把原信号的值arrResult映射成一个新的值 feedmodels)
    RAC(self,dataArray) = [[[FeedDB shareDB] getAllFeeds] map:^id(NSArray *feedmodels) {
        
        if (feedmodels.count <= 0) {
            feedmodels = [FeedStore defaultModelsArray];
        }
        return feedmodels;
    }];
    
    //网络获取，更新
    /*
     * 1. 用KVO观察数据源
     * 2. 由于数据源被上面赋值（一次性），发生变化
     * 3. 根据数据源的Feed名字与链接爬获最新的rss资源
     */
    @weakify(self);
    [RACObserve(self, dataArray) subscribeNext:^(id x) {
        @strongify(self);
        // 开一条线程去更新rss，先显示原有rss数据
        [self fetchAllFeeds];
    }];
}

// 更新数据源的Feed内容，从数据源数组取出第x个feed更新
- (void)fetchAllFeeds{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.fetchingCount = 0;
    
    @weakify(self); // 抓取feed的内容后 ，把第i个feed的i发送过来（FeedManager数组的序号）
    [[[[[[FeedManager defaultManager] fetchAllFeedsModel:self.dataArray] map:^id(id value) {
       
        @strongify(self);
        NSInteger index = [value integerValue];
        self.dataArray[index] = [FeedManager defaultManager].feedmodels[index];// 从manager里面取出
        return self.dataArray[index];// map内的返回值是要作为信号内容发送出去的
        
    }] doCompleted:^{ //信号发送sendCompleted完毕之前调用
      
        @strongify(self);
        // 当数据源被映射过来的模型替换，更新之后
        // 做UI的更新
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.fetchingCount = 0;
        
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(XmlModel *xmlmodel) { // 接收发送的内容，传递切换到制定线程中
        
        @strongify(self);
        // 显示正在更新：进度XX%
        NSLog(@"%@",[NSString stringWithFormat:@"正在获取%@...(%lu/%lu)",xmlmodel.title,(unsigned long)self.fetchingCount,(unsigned long)self.dataArray.count]);
        self.fetchingCount += 1;
        // reload数据
        [self.rssTableView reloadData];
        NSLog(@"更新主UI");
    }];
}


- (void)setUpTableView{
    
    [self.view setBackgroundColor:ZHColor(51, 52, 53)];
    [self.view addSubview:({
        
        self.rssTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZHAppWidth, ZHAppHeight - 6) style:UITableViewStyleGrouped];
        self.rssTableView.delegate = self;
        self.rssTableView.dataSource = self;//.dadaSource;
        self.rssTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rssTableView.backgroundColor = ZHColor(220, 220, 220);
        self.rssTableView;
    })];
}

- (void)loadAllFeeds:(NSNotification *)notification{
    
    NSArray *arr =  (NSArray *)notification.object;
    for (XmlModel *model in arr) {
        
        [self.dataArray  addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_rssTableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAllFeeds:) name:@"com.ZHC_RSSReader.fetchAllFeedsModel" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)rightItemAction{
 
    NSLog(@"%@",ZHdocumentPath);
}


#pragma mark - UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    XmlModel *model = [self.dataArray objectAtIndex:section];
    return model.modelArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ZHAppWidth, 35)];
    XmlModel *model = [self.dataArray objectAtIndex:section];
    lab.text = model.title;
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
    // 计算高度
    FeedCell *cell = [FeedCell cellWithTableView:tableView];
    if(!cell){
        return 180;
    }
    return cell.cellHeight;
}

// 加载cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XmlModel *model = [self.dataArray objectAtIndex:indexPath.section];
    FeedModel *cellModel = [model.modelArray objectAtIndex:indexPath.row];
    FeedCell *cell = [FeedCell cellWithTableView:tableView];
    [cell config:cellModel];
    return cell;
}

// 选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   XmlModel *model = [self.dataArray objectAtIndex:indexPath.section];
   FeedModel *cellModel = [model.modelArray objectAtIndex:indexPath.row];
    
   //RssDetailViewController *rssVC = [[RssDetailViewController alloc]initWithModel:cellModel];
   ReadFeedViewController  *rssVC = [[ReadFeedViewController alloc]initWithModel:cellModel];
    
   [self.navigationController pushViewController:rssVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
