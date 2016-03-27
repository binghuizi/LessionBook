//
//  DownloadListViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DownloadListViewController.h"
#import "DownloadDidTableViewCell.h"
#import "DownlaodTask.h"
#import "detailModel.h"

@interface DownloadListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, assign) BOOL allselect;

@end

@implementation DownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下载列表";
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[DownloadDidTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.allselect = NO;
    [self showrightBtn];
    
    
}

#pragma mark ----------CustomMethod

- (void)showrightBtn{
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.selectBtn addTarget:self action:@selector(leftTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:self.selectBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
}
- (void)leftTitleAction:(UIButton *)btn{
    if (!self.allselect) {
        DownlaodTask *task = [DownlaodTask shareInstance];
        for (detailModel *model in self.dataArray) {
            [task addDownLoadModel:model];
        }
        [self.selectBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.allselect = YES;
    }else{
        DownlaodTask *task = [DownlaodTask shareInstance];
        for (detailModel *model in self.dataArray) {
            [task deleteModel:model];
        }
        [self.selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        self.allselect = NO;
    }
}

#pragma mark ----------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadDidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (self.dataArray.count > 0) {
            cell.model = self.dataArray[indexPath.row];
        }
    return cell;
}

#pragma mark ----------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    detailModel *model = self.dataArray[indexPath.row];
    DownlaodTask *task = [DownlaodTask shareInstance];
        [task addDownLoadModel:model];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已添加" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}

#pragma mark ----------Lazyloading

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 45;
    }
    return _tableView;
}

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
