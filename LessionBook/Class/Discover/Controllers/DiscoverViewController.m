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
@interface DiscoverViewController ()
@property(nonatomic,retain) VOSegmentedControl *segment1;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.segment1];
}
//懒加载
-(VOSegmentedControl *)segment1{
    if (_segment1 == nil) {
        self.segment1 = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"分类"},
                                                                      @{VOSegmentText:@"精选"}]];
       
        self.segment1.frame             = CGRectMake(0,60,kWideth, 44);
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

-(void)segmentAction:(VOSegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        [self loadTypeData];
    }else{
        [self chosen];
    }
    
}
#pragma mark -- 分类解析
//分类
-(void)loadTypeData{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:typeBook parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        DSNLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DSNLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DSNLog(@"%@",error);
    }];
}
#pragma mark --- 精选解析
//精选
-(void)chosen{
    
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
