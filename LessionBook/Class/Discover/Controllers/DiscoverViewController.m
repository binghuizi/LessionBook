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
@interface DiscoverViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,retain) VOSegmentedControl *segment1;
@property(nonatomic,retain) UICollectionView *collectionView;
@property(nonatomic,retain) UICollectionView *collectionView2;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UIView *typeView;
@property(nonatomic,strong) UIView *choseView;
@property(nonatomic,retain) UISwipeGestureRecognizer *typeSwipeLeft;
@property(nonatomic,retain) UISwipeGestureRecognizer *choseSwipeRight;


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
    [self loadChosen]; //加载精选解析
    [self.titleView addSubview:self.segment1];
    [self.typeView addSubview:self.collectionView];
    [self.choseView addSubview:self.collectionView2];
//精选CollectionView2  Nib
    [self.collectionView2 registerNib:[UINib nibWithNibName:@"ChoseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collection2"];
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
        DSNLog(@"%@",downloadProgress);
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
        NSLog(@"图片%ld",self.imageArray.count);
        NSLog(@"标题%ld",self.titleArray.count);
        
        
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
        DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DSNLog(@"%@",responseObject);
        
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
     
        //[self chosen];
    }
    
}




#pragma mark --- collectionView代理方法
//行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.collectionView]) {
        return self.titleArray.count;
    }else{
        return 3;
    }
    
}
//分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}
//collectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    if ([collectionView isEqual:self.collectionView]) {
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
    }else{
        
        ChoseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection2" forIndexPath:indexPath];
        return cell;
    }
    
    
    //return nil;
    
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
#pragma mark --- 精选中的collectionView2
-(UICollectionView *)collectionView2{
    if (_collectionView2 == nil) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
        //垂直方向
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        //大小
        layOut.itemSize = CGSizeMake(100, 100);
        
        //每一行间距
        layOut.minimumLineSpacing = 5;
        //item间距
        layOut.minimumInteritemSpacing = 1;
        
        //边距
        layOut.sectionInset = UIEdgeInsetsMake(5, 5, 6, 5);
        
        //  区头区尾大小
        
        self.collectionView2 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWideth, kHeight-155) collectionViewLayout:layOut];
        
        self.collectionView2.backgroundColor = [UIColor whiteColor];
        self.collectionView2.delegate = self;
        self.collectionView2.dataSource = self;
        //注册Item
        [self.collectionView2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    }
    return _collectionView2;
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
//添加清扫手势
//-(UISwipeGestureRecognizer *)typeSwipeLeft{
//    if (_typeSwipeLeft == nil) {
//        self.typeSwipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(typeSwipeAction:)];
//        [self.typeSwipeLeft setDirection:UISwipeGestureRecognizerDirectionRight];
//        [[self typeView ]addGestureRecognizer:self.typeSwipeLeft];
//    }
//    return _typeSwipeLeft;
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
