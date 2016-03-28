//
//  DetailViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DetailViewController.h"
#import "DownloadListViewController.h"
#import "TableViewCell.h"
#import "DetailHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFHTTPSessionManager.h>
#import "detailModel.h"
#import <ShareSDK/ShareSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BookInformation.h"
#import "SqlModel.h"
#import <BmobSDK/BmobUser.h>
#import "PlayViewController.h"
#import "ZYMusic.h"
#import "ZYMusicTool.h"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
     DetailHeadView *_tableViewHead;
    BOOL isCollection;
    AppDelegate *_myAppdelegate;
    
}
@property(nonatomic,strong) PlayViewController *playVc;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dateArray;
@property(nonatomic,strong) NSMutableArray *urlArray;
@property (nonatomic, assign) NSInteger currentIndex;//当前歌曲
@end

@implementation DetailViewController
-(PlayViewController *)playVc{
    if (_playVc == nil) {
        self.playVc = [[PlayViewController alloc]init];
        self.playVc.arrayAll = self.dateArray;
        _playVc.delegate = self;
    }
    return _playVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    [self showBackButton:@"ic_arrow_general2"];
    
    self.title = self.titleString;
    _myAppdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //是否收藏
    isCollection = 1 ;
    [self loadAction];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self loadHeadView];
}
//将要显示
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.tabBarController.tabBar.hidden = NO;
    
    //显示是否收藏状态
    //    if (_myAppdelegate.isCollection == 0) {
    //
    //        [_tableViewHead.collectionBtn setImage:[UIImage imageNamed:@"umeng_socialize_action_unlike"] forState:UIControlStateNormal];
    //
    //    }else{
    //
    //        [_tableViewHead.collectionBtn setImage:[UIImage imageNamed:@"btn_play_fav"] forState:UIControlStateNormal];
    
    // }

}
#pragma mark --- 头部
-(void)loadHeadView{
    //[[[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:nil options:nil] lastObject];DetailHeadView
    _tableViewHead = [[[NSBundle mainBundle] loadNibNamed:@"DetailHeadView" owner:nil options:nil] lastObject];
    [_tableViewHead.imageView sd_setImageWithURL:[NSURL URLWithString:self.pictchString] placeholderImage:nil];
    _tableViewHead.anchorNameLabel.text = self.zhuboString;
    _tableViewHead.authorNameLabel.text = self.zuozheString;
    _tableViewHead.describeLabel.text   = self.miaoshuString;
    [_tableViewHead.shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [_tableViewHead.collectionBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    //下载列表
    [_tableViewHead.downloadBtn addTarget:self action:@selector(downloadBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = _tableViewHead;
}
#pragma mark -- 头部分享按钮
-(void)shareAction{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@",self.titleString,self.pictchString]
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:[NSString stringWithContentsOfURL:[NSURL URLWithString:self.pictchString] encoding:NSUTF8StringEncoding error:nil]]
                                                title:self.titleString
                                                  url:[NSString stringWithFormat:@"%@",self.pictchString]
                                          description:self.miaoshuString
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建iPad弹出菜单容器,详见第六步
    id<ISSContainer> container = [ShareSDK container];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
    
}
//收藏
-(void)collectionAction{
    //是否登陆状态 登陆状态才能收藏
    if (_myAppdelegate.isLogin) {
        //1.登录状态下 点击收藏 变红色❤️
        
        
        
        BookInformation *info = [BookInformation bookInformationWithUserId:_myAppdelegate.userId bookId:self.idString bookName:self.titleString bookIntroduction:self.miaoshuString imageString:self.pictchString];
        SqlModel *model = [[SqlModel alloc]init];
        
        BmobUser *user = [BmobUser getCurrentUser];
        
        if (user != NULL) {
            if ([model insertIntoBookSql:info tableName:user.username] == 1) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [_tableViewHead.collectionBtn setImage:[UIImage imageNamed:@"btn_play_fav"] forState:UIControlStateNormal];
                    isCollection = 0;
                    _myAppdelegate.isCollection = 1;
                    
                }];
                [alertVc addAction:action];
                [self presentViewController:alertVc animated:YES completion:nil];
            }else{
                //登录状态下 不想收藏了，再次点击  变成灰色❤️
                [_tableViewHead.collectionBtn setImage:[UIImage imageNamed:@"umeng_socialize_action_unlike"] forState:UIControlStateNormal];
                isCollection = 1;
                _myAppdelegate.isCollection = 0;
            }
            
        }
        
        
        
        
        
    }else{
        //登陆状态跳转登录页面
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
            
            LoginViewController *loginVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVc addAction:action2];
        [alertVc addAction:action];
        [self presentViewController:alertVc animated:YES completion:nil];
        
        
    }
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dateArray[indexPath.row];
    
    return cell;
}
//自定义高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
//PlayViewController代理方法
-(void)getNum:(NSInteger)cunrrentNum{
    self.currentIndex = cunrrentNum;
    NSLog(@"currentIndex%ld",self.currentIndex);
}
#pragma mark --- 点击cell触发事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [ZYMusicTool setPlayingMusic:self.dateArray[indexPath.row]];
    detailModel *preModel = self.dateArray[self.currentIndex];//当前歌曲
     self.playVc.currentplayingMusic = self.dateArray[self.currentIndex];//当前歌曲
    preModel.playing = NO;
    
    detailModel *model = self.dateArray[indexPath.row];
    
    NSLog(@"%@",model.download);
    model.playing = YES;
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForItem:self.currentIndex inSection:0],indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    self.currentIndex = (int)indexPath.row;
    
   
   NSInteger num = [HWTools number:model.duration];
   self.playVc.nameString = model.name;
   self. playVc.timeInt = num;
    self.playVc.num = indexPath.row;
    self.playVc.urlString = model.download;
    self.playVc.playingMusic = self.dateArray[indexPath.row];
    [self.playVc show];
    [self.navigationController pushViewController:self.playVc animated:YES];
    
    
    
    
}
#pragma mark -- 解析详情数据
-(void)loadAction{
    AFHTTPSessionManager *sessionManger = [[AFHTTPSessionManager alloc]init];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [sessionManger GET:[NSString stringWithFormat:@"%@%@%@",kDetails,self.idString,@"/programs/curpage/1/pagesize/100"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //DSNLog(@"%@",responseObject);
        
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        if (self.urlArray.count > 0) {
            [self.urlArray removeAllObjects];
        }
        for (NSDictionary *dic in dataArray) {
            detailModel *model = [[detailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            NSDictionary *medioDic = dic[@"mediainfo"];
            [model setValuesForKeysWithDictionary:medioDic];
            [self.dateArray addObject:model];
            [self.urlArray addObject:model.download];
        }
        

        [ZYMusicTool musics:self.dateArray];
       // sics = self.urlArray;
        

        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DSNLog(@"%@",error);
    }];
    
    
}

#pragma mark --- 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}
//
-(NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        self.dateArray = [NSMutableArray new];
    }
    return _dateArray;
}
-(NSMutableArray *)urlArray{
    if (_urlArray == nil) {
        self.urlArray = [NSMutableArray new];
    }
    return _urlArray;
}


#pragma mark ---------DownLoad
- (void)downloadBtn{
    DownloadListViewController *downloadlistVC = [[DownloadListViewController alloc] init];
    downloadlistVC.dataArray = self.dateArray;
    [self.navigationController pushViewController:downloadlistVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
