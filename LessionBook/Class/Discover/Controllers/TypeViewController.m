//
//  TypeViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "TypeViewController.h"
#import "VOSegmentedControl.h"
#import "TypeTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFHTTPSessionManager.h>
#import "TypeModel.h"
#import "typeDetailModel.h"
#import "ProgressHUD.h"
@interface TypeViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    NSInteger _pageCount;//定义请求页码
}
@property(nonatomic,strong)VOSegmentedControl *segment1;
@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property(nonatomic,strong) PullingRefreshTableView *tableView1;
@property(nonatomic,strong) PullingRefreshTableView *tableView2;
@property(nonatomic,strong) UIView *recommendView;
@property(nonatomic,strong) UIView *hotView;
@property(nonatomic,strong) UIView *latestView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *dataArray1;
@property(nonatomic,strong) NSMutableArray *dataArray2;
@property(nonatomic,assign) BOOL refreshing;
@property(nonatomic,strong) NSMutableArray *nameArray;
@property(nonatomic,strong) NSMutableArray *nameArray1;
@property(nonatomic,strong) NSMutableArray *nameArray2;
@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButton:@"ic_arrow_general2"];
    [self.view addSubview:self.recommendView];
    [self.view addSubview:self.hotView];
    [self.view addSubview:self.latestView];
    self.hotView.hidden = YES;
    self.latestView.hidden = YES;
    
    [self.view addSubview:self.segment1];
    [self.recommendView addSubview:self.tableView];
    [self.hotView addSubview:self.tableView1];
    [self.latestView addSubview:self.tableView2];
//
    [self.tableView registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
   
    
    [self loadData];
    [self loadData1];
    [self loadData2];
}
#pragma mark --- PullingRefreshTableView下拉刷新
//下拉刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    if ([tableView isEqual:self.tableView]) {
        _pageCount = 1;
        self.refreshing = YES;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    }else if ([tableView isEqual:self.tableView1]){
        _pageCount = 1;
        self.refreshing = YES;
        [self performSelector:@selector(loadData1) withObject:nil afterDelay:1.0];

    }else{
        _pageCount = 1;
        self.refreshing = YES;
        [self performSelector:@selector(loadData2) withObject:nil afterDelay:1.0];

    }
   
    
}
//上拉
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    if ([tableView isEqual:self.tableView]) {
        _pageCount += 1;
        self.refreshing = NO;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
    }else if ([self.tableView isEqual:self.tableView1]){
        _pageCount += 1;
        self.refreshing = NO;
        [self performSelector:@selector(loadData1) withObject:nil afterDelay:1.f];
    }else{
        _pageCount += 1;
        self.refreshing = NO;
        [self performSelector:@selector(loadData2) withObject:nil afterDelay:1.f];
    }
   
    
}

//手指开始 拖动方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.recommendView.hidden == NO) {
        [self.tableView tableViewDidScroll:scrollView];

    }else if (self.hotView.hidden == NO){
        [self.tableView1 tableViewDidScroll:scrollView];

    }else{
        [self.tableView2 tableViewDidScroll:scrollView];

    }
}
//上拉拖动手指
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.recommendView.hidden == NO) {
         [self.tableView tableViewDidEndDragging:scrollView];
    }else if(self.hotView.hidden == NO){
         [self.tableView1 tableViewDidEndDragging:scrollView];
    }else{
         [self.tableView2 tableViewDidEndDragging:scrollView];
    }
   
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    if (self.recommendView.hidden == NO) {
        return [HWTools getSystemNowDate];
    }else if (self.hotView.hidden == NO){
        return [HWTools getSystemNowDate];
    }else{
        return [HWTools getSystemNowDate];
    }
    
}
#pragma mark --- 解析数据
-(void)loadData{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"推荐加载中"];
    [sessionManager GET:[NSString stringWithFormat:@"%@%@%@%@%@",TypeSuggestion,self.idString,@"/channels/order/",@"recommend",@"/curpage/1/pagesize/10"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       // DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"推荐加载成功"];
       // DSNLog(@"%@",responseObject);
        if (self.refreshing) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
        }
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
            TypeModel *model = [[TypeModel alloc]init];
           
            [model setValuesForKeysWithDictionary:itemDic];
            
            NSArray *broadArray = itemDic[@"broadcasters"];
            [model setValuesForKeysWithDictionary:broadArray[0]];
          
            [self.dataArray addObject:model];
            
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DSNLog(@"%@",error);
    }];
}
-(void)loadData1{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [ProgressHUD show:@"最热加载中"];
    [sessionManager GET:[NSString stringWithFormat:@"%@%@%@%@%@",TypeSuggestion,self.idString,@"/channels/order/",@"hot",@"/curpage/1/pagesize/10"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //DSNLog(@"%@",responseObject);
        if (self.hotView.hidden == NO) {
            [ProgressHUD showSuccess:@"最热加载成功"];
        }
        
        if (self.refreshing) {
            if (self.dataArray1.count > 0) {
                [self.dataArray1 removeAllObjects];
                
            }
        }
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
            TypeModel *model = [[TypeModel alloc]init];
           
            [model setValuesForKeysWithDictionary:itemDic];
            
            
            NSArray *broadArray = itemDic[@"broadcasters"];
            if (broadArray.count != 0) {
                [model setValuesForKeysWithDictionary:broadArray[0]];
            }
           
            
            [self.dataArray1 addObject:model];
            
        
        
        }
        
        [self.tableView1 reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DSNLog(@"%@",error);
    }];
}
-(void)loadData2{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [sessionManager GET:[NSString stringWithFormat:@"%@%@%@%@%@",TypeSuggestion,self.idString,@"/channels/order/",@"latest",@"/curpage/1/pagesize/10"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //DSNLog(@"%@",responseObject);
        if (self.latestView.hidden == NO) {
            [ProgressHUD showSuccess:@"最新加载成功"];
        }
        if (self.dataArray2.count > 0) {
            [self.dataArray2 removeAllObjects];
        }
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
            TypeModel *model = [[TypeModel alloc]init];
            
            [model setValuesForKeysWithDictionary:itemDic];
            
            
            NSArray *broadArray = itemDic[@"broadcasters"];
            if (broadArray.count != 0) {
                 [model setValuesForKeysWithDictionary:broadArray[0]];
            }
           
            
            [self.dataArray2 addObject:model];

        }
        
        [self.tableView2 reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DSNLog(@"%@",error);
    }];
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView]) {
        return self.dataArray.count;
    }else if([ tableView isEqual:self.tableView1]){
        return self.dataArray1.count;
    }else{
        return self.dataArray2.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView]) {
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.row];

        
        return cell;
    }else if ([tableView isEqual:self.tableView1]){
        TypeTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        cell1.model = self.dataArray1[indexPath.row];
        
        return cell1;
    }else{
        TypeTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
       
        cell2.model = self.dataArray2[indexPath.row];
        return cell2;
    }
    
}
//自定义高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kHeight * 50/kHeight, kWideth, kHeight - kHeight * 50/kHeight) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}
-(PullingRefreshTableView *)tableView1{
    if (_tableView1 == nil) {
        self.tableView1 = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kHeight * 100/kHeight, kWideth, kHeight - kHeight * 150/kHeight) pullingDelegate:self];
        self.tableView1.dataSource = self;
        self.tableView1.delegate = self;
    }
    return _tableView1;
}
-(PullingRefreshTableView *)tableView2{
    if (_tableView2 == nil) {
        self.tableView2 = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kHeight * 100/kHeight, kWideth, kHeight - kHeight * 100/kHeight) pullingDelegate:self];
        self.tableView2.dataSource = self;
        self.tableView2.delegate = self;
    }
    return _tableView2;
}
-(VOSegmentedControl *)segment1{
    if (_segment1 == nil) {
        self.segment1 = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"推荐"},
                                                                      @{VOSegmentText:@"最热"},
                                                                      @{VOSegmentText:@"最新"}]];
       self.segment1.frame             = CGRectMake(0,kWideth * 60/kWideth,kWideth,kWideth * 44/kWideth);
       self.segment1.textColor         = [UIColor blackColor];//字体颜色
       self.segment1.selectedTextColor = [UIColor orangeColor];//选中时字体颜色
       self.segment1.contentStyle      = VOContentStyleImageLeft;//风格
       self.segment1.indicatorStyle     = VOSegCtrlIndicatorStyleBottomLine;//下划线
       self.segment1.selectedIndicatorColor = [UIColor orangeColor];//选中时下划线的颜色
       self.segment1.allowNoSelection       = NO;
       self.segment1.indicatorThickness     = 2;//下划线粗细
        //点击方法
        [self.segment1 addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    }
    return _segment1;
}
#pragma mark --- //VOSegmentedControl点击方法

-(void)segmentAction:(VOSegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        self.recommendView.hidden = NO;
        self.hotView.hidden       = YES;
        self.latestView.hidden    = YES;
        
      
    }else if (segment.selectedSegmentIndex == 1){
        self.recommendView.hidden = YES;
        self.hotView.hidden       = NO;
        self.latestView.hidden    = YES;
        
       
    }else{
        self.recommendView.hidden = YES;
        self.hotView.hidden       = YES;
        self.latestView.hidden    = NO;
        
       
    }
    
}

#pragma mark --- 懒加载
-(UIView *)recommendView{
    if (_recommendView == nil) {
        self.recommendView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWideth, kHeight)];
        
    }
    return _recommendView;
}
-(UIView *)hotView{
    if (_hotView == nil) {
        self.hotView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, kWideth, kHeight)];
       
        
    }
    return _hotView;
}
-(UIView *)latestView{
    if (_latestView == nil) {
        self.latestView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWideth, kHeight)];
       
    }
    return _latestView;
}
//解析数据
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSMutableArray *)dataArray1{
    if (_dataArray1 == nil) {
        self.dataArray1 = [NSMutableArray new];
    }
    return _dataArray1;
}

-(NSMutableArray *)dataArray2{
    if (_dataArray2 == nil) {
        self.dataArray2 = [NSMutableArray new];
    }
    return _dataArray2;
}
//主播名字数组
-(NSMutableArray *)nameArray{
    if (_nameArray == nil) {
        self.nameArray = [NSMutableArray new];
    }
    return _nameArray;
}
-(NSMutableArray *)nameArray1{
    if (_nameArray1 == nil) {
        self.nameArray1 = [NSMutableArray new];
    }
    return _nameArray1;
}
-(NSMutableArray *)nameArray2{
    if (_nameArray2 == nil) {
        self.nameArray2 = [NSMutableArray new];
    }
    return _nameArray2;
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
