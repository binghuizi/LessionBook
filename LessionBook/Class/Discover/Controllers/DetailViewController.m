//
//  DetailViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DetailViewController.h"
#import "TableViewCell.h"
#import "DetailHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFHTTPSessionManager.h>
#import "detailModel.h"
#import <ShareSDK/ShareSDK.h>
#import <QuartzCore/QuartzCore.h>


@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dateArray;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showBackButton:@"ic_arrow_general2"];
   
    self.title = self.titleString;
   
    [self loadAction];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self loadHeadView];
}
#pragma mark --- 头部
-(void)loadHeadView{
    //[[[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:nil options:nil] lastObject];DetailHeadView
    DetailHeadView *tableViewHead = [[[NSBundle mainBundle] loadNibNamed:@"DetailHeadView" owner:nil options:nil] lastObject];
    [tableViewHead.imageView sd_setImageWithURL:[NSURL URLWithString:self.pictchString] placeholderImage:nil];
    tableViewHead.anchorNameLabel.text = self.zhuboString;
    tableViewHead.authorNameLabel.text = self.zuozheString;
    tableViewHead.describeLabel.text   = self.miaoshuString;
    [tableViewHead.shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHead.collectionBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = tableViewHead;
}
#pragma mark -- 头部分享按钮
-(void)shareAction{
  //  NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"DIDI2" ofType:@"jpg"];
   // NSData *date = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pictchString]];
   // NSLog(@"%@",imagePath);
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
   // [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
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
-(void)collectionAction{
    
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
        
        for (NSDictionary *dic in dataArray) {
            detailModel *model = [[detailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dateArray addObject:model];
        }
       
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



#pragma mark ---------DownLoad


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
