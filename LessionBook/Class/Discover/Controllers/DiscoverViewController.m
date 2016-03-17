//
//  DiscoverViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DiscoverViewController.h"
#import "VOSegmentedControl.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "TypeModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChoseModel.h"
#import "ChoseCollectionViewCell.h"
#import "ChoseTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DiscoverViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,retain) VOSegmentedControl *segment1;
@property(nonatomic,retain) UICollectionView *collectionView;

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UIView *typeView;
@property(nonatomic,strong) UIView *choseView;
@property(nonatomic,retain) UISwipeGestureRecognizer *typeSwipeLeft;//清扫手势
@property(nonatomic,retain) UISwipeGestureRecognizer *choseSwipeRight;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *pictureArray;
@property(nonatomic,strong) NSMutableArray *itemsArray;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) NSMutableArray *nameArray;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.typeView];
    [self.view addSubview:self.choseView];
    self.choseView.hidden = YES;//隐藏精选视图
    [self loadTypeData];//加载分类解析
    [self loadpicture];//轮番图加载
    [self loadChosen]; //加载精选解析
    [self.titleView addSubview:self.segment1];
    [self.typeView addSubview:self.collectionView];
    [self.choseView addSubview:self.tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"ChoseTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableView"];
//添加清扫手势
    
    self.typeSwipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(oneFingerSwipeUp:)];
    self.choseSwipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(twoFingerSwipeUp:)];
    
    [self.typeSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.choseSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self typeView ]addGestureRecognizer:self.typeSwipeLeft];
    [[self choseView ]addGestureRecognizer:self.choseSwipeRight];
    
}
#pragma mark --- 清扫手势
//向右清扫
- (void)oneFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.2 animations:^{
        self.typeView.hidden = YES;
        self.choseView.hidden = NO;
        //下划线显示哪个
        self.segment1.selectedSegmentIndex = 1;
    }];
    
}
//向左清扫
- (void)twoFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.2 animations:^{
        self.choseView.hidden = YES;//隐藏精选
        self.typeView.hidden = NO;//显示分类
        //下划线显示哪个
        self.segment1.selectedSegmentIndex = 0;
    }];
    
}
#pragma mark -- 分类解析
//分类
-(void)loadTypeData{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [sessionManager GET:typeBook parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       // DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

       // DSNLog(@"%@",responseObject);

        
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
            TypeModel *model = [[TypeModel alloc] init];
            [model setValuesForKeysWithDictionary:itemDic];
            [self.imageArray addObject:model.thumb];
            [self.titleArray addObject:model.name];
        }
        [self.collectionView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DSNLog(@"%@",error);
    }];
}
#pragma mark ---轮番图解析
-(void)loadpicture{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [sessionManager GET:movePicture parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //DSNLog(@"%@",downloadProgress);
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // DSNLog(@"%@",responseObject);
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
            [self.pictureArray addObject:itemDic[@"bigthumb"]];
            [self.nameArray addObject:itemDic[@"name"]];
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DSNLog(@"%@",error);
    }];



}
#pragma mark --- 精选解析
//精选
-(void)loadChosen{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
     sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
     
     [sessionManager GET:chose parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
      //  DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // DSNLog(@"%@",responseObject);
        
        NSDictionary *rootDic = responseObject;
        
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *itemDic in dataArray) {
           
            ChoseModel *mol = [[ChoseModel alloc]init];
           
            [mol setValuesForKeysWithDictionary:itemDic];
            [self.itemsArray addObject:mol];
        }
        
        [self.tableView reloadData];
        [self headTableView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DSNLog(@"%@",error);
    }];
}

#pragma mark --- 懒加载
//懒加载VOSegmentedControl
-(VOSegmentedControl *)segment1{
    if (_segment1 == nil) {
        self.segment1 = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"分类"},
                                                                      @{VOSegmentText:@"精选"}]];
        
        self.segment1.frame             = CGRectMake(0,0,kWideth, 44);
        self.segment1.textColor         = [UIColor blackColor];//字体颜色
        self.segment1.selectedTextColor = [UIColor orangeColor];//选中时字体颜色
        self.segment1.contentStyle      = VOContentStyleImageLeft;//风格
        
        //VOSegCtrlIndicatorStyleTopLine, 顶部横线 VOSegCtrlIndicatorStyleBottomLine, 底部横线
        
        self.segment1.indicatorStyle         = VOSegCtrlIndicatorStyleBottomLine;//下划线
        self.segment1.selectedIndicatorColor = [UIColor orangeColor];//选中时下划线的颜色
        self.segment1.allowNoSelection       = NO;
        self.segment1.indicatorThickness     = 2;//下划线粗细
       
        //点击方法
        [self.segment1 addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segment1;
}
#pragma mark -- 点击  VOSegmentedControl 触发事件
//点击  VOSegmentedControl 触发事件
-(void)segmentAction:(VOSegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        self.choseView.hidden = YES;//隐藏精选
        self.typeView.hidden = NO;//显示分类
      
    }else{
        self.typeView.hidden = YES;//隐藏分类
        self.choseView.hidden = NO;//显示精选
     
        
    }
    
}




#pragma mark --- collectionView代理方法
//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
        return self.titleArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
        self.imageView = [[UIImageView alloc]init];
        self.imageView.frame = CGRectMake(10, 0, 70, 70);
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 35;
        self.imageView.backgroundColor = [UIColor lightGrayColor];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:nil];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 100, 30)];
        self.titleLabel.text = self.titleArray[indexPath.row];
        self.titleLabel.textAlignment = UIAlertActionStyleCancel;
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        [cell.contentView addSubview:self.imageView];
        [cell.contentView addSubview:self.titleLabel];
        return cell;
   
    
   
    
}
#pragma mark -- 自定义tableView头部
-(void)headTableView{
    UIView *tableHeaderView = [[UIView alloc]init];
    
    tableHeaderView.frame = CGRectMake(0, 0, kWideth, 220);
    [tableHeaderView addSubview:self.scrollView];
  
#pragma mark --给ScrollViewT添加图片
    for (int i = 0; i < self.pictureArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWideth * i, 0, kWideth, 180)];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWideth * i, imageView.bottom, kWideth, 30)];
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        nameLabel.userInteractionEnabled = YES;
        //打开用户交互
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.pictureArray[i]] placeholderImage:nil];
        nameLabel.text = self.nameArray[i];
        [self.scrollView addSubview:imageView];
        [self.scrollView addSubview:nameLabel];
        
        UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        touchButton.frame = imageView.frame;
        touchButton.tag = i;
        [touchButton addTarget:self action:@selector(pictuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:touchButton];
    }
    
    //区头添加
    self.tableView.tableHeaderView = tableHeaderView;//添加区头；

}

#pragma mark --- tableView代理方法
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView" forIndexPath:indexPath];

    
    cell.model = self.itemsArray[indexPath.row];
    
    return cell;
    
}
//分区

//自定义tableView高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


//懒加载collectionView
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //布局方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;//垂直方向
    //大小
        layout.itemSize = CGSizeMake(100, 100);
    //每一行间距
        layout.minimumLineSpacing = 5;
    //item间距
        layout.minimumInteritemSpacing = 1;
        
    //边距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 6, 5);
        
    //  区头区尾大小
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWideth, kHeight-155) collectionViewLayout:layout];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //注册Item
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"item"];
        
    }
    return _collectionView;
}
#pragma mark -- 轮番图ScrollView
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWideth, kHeight *220/kHeight)];
        self.scrollView.delegate = self;
        //添加图片的个数
        self.scrollView.contentSize = CGSizeMake(self.pictureArray.count *kWideth, 220);
        //整屏滑动
        self.scrollView.pagingEnabled = YES;
        //垂直方向滚动条no不显示
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollView;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWideth, kHeight-155) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        
    }
    return _tableView;
}
//标题视图
-(UIView *)titleView{
    if (_titleView == nil) {
        self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0,60,kWideth, 44)];
        self.titleView.backgroundColor = [UIColor magentaColor];
    }
    return _titleView;
}
//分类视图
-(UIView *)typeView{
    if (_typeView == nil) {
        self.typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, kWideth, kHeight-155)];
    }
    return _typeView;
}
//精选视图
-(UIView *)choseView{
    if (_choseView == nil) {
        self.choseView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, kWideth, kHeight-155)];
        self.choseView.backgroundColor = [UIColor purpleColor];
    }
    return _choseView;
}

-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        self.imageArray = [NSMutableArray new];
    }
    return _imageArray;
}
-(NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
}
//精选tableView cell传数据
-(NSMutableArray *)itemsArray{
    if (_itemsArray == nil) {
        self.itemsArray = [NSMutableArray new];
    }
    return _itemsArray;
}

//轮番图片
-(NSMutableArray *)pictureArray{
    if (_pictureArray == nil) {
        self.pictureArray = [NSMutableArray new];
        
    }
    return _pictureArray;
}
//轮番图标题
-(NSMutableArray *)nameArray{
    if (_nameArray == nil) {
        self.nameArray = [NSMutableArray new];
        
    }
    return _nameArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
