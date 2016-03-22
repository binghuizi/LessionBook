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
#import <ShareSDKUI/ShareSDK+SSUI.h>
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
    
    self.tableView.tableHeaderView = tableViewHead;
}
#pragma mark -- 头部分享按钮
-(void)shareAction{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"DIDI2.jpg"]];
      if (imageArray) {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
  //2、分享（可以弹出我们的分享菜单和编辑界面）
    //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"分享成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVc addAction:action];
                [self presentViewController:alertVc animated:YES completion:nil];
                
            
            
            break;
            }
                
             case SSDKResponseStateFail:
            {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVc addAction:action];
                [self presentViewController:alertVc animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }];
    
    
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
