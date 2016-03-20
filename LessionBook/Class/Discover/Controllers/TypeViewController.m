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
@interface TypeViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
@property(nonatomic,strong)VOSegmentedControl *segment1;
@property(nonatomic,strong) PullingRefreshTableView *tableView;

@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view addSubview:self.segment1];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
//自定义高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kHeight * 105/kHeight, kWideth, kHeight - kHeight * 150/kHeight) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

-(VOSegmentedControl *)segment1{
    if (_segment1 == nil) {
        self.segment1 = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"推荐"},
                                                                      @{VOSegmentText:@"最热"},
                                                                      @{VOSegmentText:@"最新"}]];
       self.segment1.frame             = CGRectMake(0,60,kWideth, 44);
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
//点击方法
-(void)segmentAction:(VOSegmentedControl *)segment{
    
}




















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
