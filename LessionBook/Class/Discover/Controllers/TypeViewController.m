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
@interface TypeViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
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
@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view addSubview:self.recommendView];
    [self.view addSubview:self.hotView];
    [self.view addSubview:self.latestView];
    self.hotView.hidden = YES;
    self.latestView.hidden = YES;
    
    [self.view addSubview:self.segment1];
    [self.recommendView addSubview:self.tableView];
    [self.hotView addSubview:self.tableView1];
    [self.latestView addSubview:self.tableView2];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    //recommend
    self.weight = @"hot";
    [self loadData];
    [self loadData1];
    [self loadData2];
}
#pragma mark --- 解析数据
-(void)loadData{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [sessionManager GET:[NSString stringWithFormat:@"%@%@%@%@%@",TypeSuggestion,self.idString,@"/channels/order/",@"recommend",@"/curpage/1/pagesize/10"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       // DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DSNLog(@"%@",responseObject);
        
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
            TypeModel *model = [[TypeModel alloc]init];
            [model setValuesForKeysWithDictionary:itemDic];
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
    [sessionManager GET:[NSString stringWithFormat:@"%@%@%@%@%@",TypeSuggestion,self.idString,@"/channels/order/",@"hot",@"/curpage/1/pagesize/10"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DSNLog(@"%@",responseObject);
        
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
            TypeModel *model = [[TypeModel alloc]init];
            [model setValuesForKeysWithDictionary:itemDic];
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
        DSNLog(@"%@",responseObject);
        
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
            TypeModel *model = [[TypeModel alloc]init];
            [model setValuesForKeysWithDictionary:itemDic];
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
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else{
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        return cell;
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
        self.tableView2 = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kHeight * 100/kHeight, kWideth, kHeight - kHeight * 150/kHeight) pullingDelegate:self];
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













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
