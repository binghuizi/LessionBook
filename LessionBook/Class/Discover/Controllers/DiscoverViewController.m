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
#import "DetailViewController.h"
#import "detailModel.h"
#import "TypeViewController.h"

@interface DiscoverViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, imageviewDelegate>
{
   
}
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
@property(nonatomic,strong) NSTimer *timer;//定时器用于图片滚动
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) NSMutableArray *detallArray;
@property(nonatomic,strong) NSMutableArray *pichArray;
@property(nonatomic,strong) NSMutableArray *descArray;
@property(nonatomic,strong) NSMutableArray *biaotiArray;
@property(nonatomic,strong) NSMutableArray *idArray;
@property(nonatomic,strong) NSMutableArray *typeIdArray;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"马里亚纳听书";
    //导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    
    
    [self startTimer];
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
            [self.typeIdArray addObject:model.id];
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
            
            detailModel *model = [[detailModel alloc]init];
            [model setValuesForKeysWithDictionary:itemDic[@"detall"]];
           
            NSDictionary *detadic = itemDic[@"detail"];
            [self.pichArray   addObject:detadic[@"parentcover"]];
            [self.descArray   addObject:detadic[@"parentoutline"]];
            [self.biaotiArray addObject:detadic[@"parentname"]];
            [self.idArray     addObject:detadic[@"parentid"]];
            
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
        //DSNLog(@"%@",responseObject);
        
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
#pragma mark --collectionView点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TypeViewController *typeVc = [[TypeViewController alloc]init];
    
    typeVc.idString = self.typeIdArray[indexPath.row];
    typeVc.navigationItemTitle = self.titleArray[indexPath.row];
    
    [self.navigationController pushViewController:typeVc animated:YES];
}
#pragma mark -- 自定义tableView头部
-(void)headTableView{
    UIView *tableHeaderView = [[UIView alloc]init];
    
    tableHeaderView.frame = CGRectMake(0, 0, kWideth, 220);
    [tableHeaderView addSubview:self.scrollView];
  //圆点个数
    self.pageControl.numberOfPages = self.pictureArray.count;
    [tableHeaderView addSubview:self.pageControl];
    
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
-(void)pictuAction:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            DetailViewController *detailVc = [[DetailViewController alloc]init];
            detailVc.pictchString = self.pichArray[btn.tag];
            detailVc.miaoshuString = self.descArray[btn.tag];
            detailVc.titleString = self.biaotiArray[btn.tag];
            detailVc.idString = self.idArray[btn.tag];
            
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case 1:
        {
            DetailViewController *detailVc = [[DetailViewController alloc]init];
            detailVc.pictchString = self.pichArray[btn.tag];
            detailVc.miaoshuString = self.descArray[btn.tag];
            detailVc.titleString = self.biaotiArray[btn.tag];
            detailVc.idString = self.idArray[btn.tag];
            
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case 2:
        {
            DetailViewController *detailVc = [[DetailViewController alloc]init];
            detailVc.pictchString = self.pichArray[btn.tag];
            detailVc.miaoshuString = self.descArray[btn.tag];
            detailVc.titleString = self.biaotiArray[btn.tag];
            detailVc.idString = self.idArray[btn.tag];
            
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case 3:
        {
            DetailViewController *detailVc = [[DetailViewController alloc]init];
            detailVc.pictchString = self.pichArray[btn.tag];
            detailVc.miaoshuString = self.descArray[btn.tag];
            detailVc.titleString = self.biaotiArray[btn.tag];
            detailVc.idString = self.idArray[btn.tag];
            
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case 4:
        {
            DetailViewController *detailVc = [[DetailViewController alloc]init];
            detailVc.pictchString = self.pichArray[btn.tag];
            detailVc.miaoshuString = self.descArray[btn.tag];
            detailVc.titleString = self.biaotiArray[btn.tag];
            detailVc.idString = self.idArray[btn.tag];
            
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        default:
            break;
    }
}
//首页轮番
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //scrollView的宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //偏移量
    CGPoint offSet = self.scrollView.contentOffset;
    //偏移量除以宽度就是圆点个数
    NSInteger pageNumber = offSet.x/pageWidth;
    self.pageControl.currentPage = pageNumber;
    
    
}
#pragma mark --- 圆点动视图也动
-(void)touchActionPage:(UIPageControl *)pageConrol{
    //当前圆点个数
    NSInteger pageNumber = pageConrol.currentPage;
    //洒出rollView的宽度
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //scrollView的偏移量
    self.scrollView.contentOffset = CGPointMake(pageNumber *pageWidth, 0);
    
    
}
//开始定时轮番
-(void)startTimer{
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    
     [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)updateTimer{
    if (self.pictureArray.count > 0) {
    //当前页数+1
        NSInteger page = self.pageControl.currentPage + 1;
        //获取圆点个数
        CGFloat offSex = page % self.pictureArray.count;
        self.pageControl.currentPage = offSex;
        [self touchActionPage:self.pageControl];
    }
}
//挡手动滑动scrollView的时候定时器依然在计算事件可能我们刚刚滑动到那  定时器有高好书法导致当前也停留的事件补不够两秒
//解决方案 scroll开始移动时 结束定时器在scroll在移动完毕时候  在启动定时器
//将要开始拖拽  定时器取消
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;//定时器停止
}
//拖拽完毕
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self startTimer];
}
#pragma mark --- tableView代理方法
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView" forIndexPath:indexPath];
    
    cell.delgate = self;
    cell.model = self.itemsArray[indexPath.row];
    
    
    return cell;
    
}
//分区

//自定义tableView高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
#pragma mark --- tableView点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark -- 详情代理
//代理方法
-(void)showImage:(NSString *)imageUrl anchor:(NSString *)anchor author:(NSString *)author describe:(NSString *)describe titleName:(NSString *)titleName
        idString:(NSString *)idString{

    DetailViewController *detailVc = [[DetailViewController alloc]init];
  
    detailVc.pictchString = imageUrl;
    detailVc.zhuboString = anchor;
    detailVc.zuozheString = author;
    detailVc.miaoshuString = describe;
    detailVc.titleString = titleName;
    detailVc.idString = idString;
    
    [self.navigationController pushViewController:detailVc animated:YES];


}
-(void)typeIdString:(NSString *)typeId{
    TypeViewController *typeVc = [[TypeViewController alloc]init];
    typeVc.idString = typeId;
    [self.navigationController pushViewController:typeVc animated:YES];
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
//pageControl
-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(80, 186 - 30, kWideth, 30)];
        //当前选中的颜色
        self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        //点击圆点触发事件
        [self.pageControl addTarget:self action:@selector(touchActionPage:) forControlEvents:UIControlEventValueChanged];
        //分页初始化页数
        self.pageControl.currentPage = 0;
    }
    return _pageControl;
}
//轮番图片数组详情数组
-(NSMutableArray *)detallArray{
    if (_detallArray == nil) {
        self.detallArray = [NSMutableArray new];
    }
    return _detallArray;
}
//轮番图片详情
-(NSMutableArray *)pichArray{
    if (_pichArray == nil) {
        self.pichArray = [NSMutableArray new];
    }
    return _pichArray;
}
-(NSMutableArray *)descArray{
    if (_descArray == nil) {
        self.descArray = [NSMutableArray new];
    }
    return _descArray;
}
-(NSMutableArray *)biaotiArray{
    if (_biaotiArray == nil) {
        self.biaotiArray = [NSMutableArray new];
    }
    return _biaotiArray;
}
-(NSMutableArray *)idArray{
    if (_idArray == nil) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;
}
//分类id数组
-(NSMutableArray *)typeIdArray{
    if (_typeIdArray == nil) {
        self.typeIdArray = [NSMutableArray new];
    }
    return _typeIdArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
