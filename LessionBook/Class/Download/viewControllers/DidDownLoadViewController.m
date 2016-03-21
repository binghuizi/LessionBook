//
//  DidDownLoadViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DidDownLoadViewController.h"
#import "DownloadDidTableViewCell.h"

@interface DidDownLoadViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation DidDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"已下载";
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[DownloadDidTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark --------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadDidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark --------UITableViewDelegate

#pragma mark --------Lazyloading

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 45;
    }
    return _tableView;
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

#pragma mark --------CustomMethod




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
