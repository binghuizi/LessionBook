//
//  MessageViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "MessageViewController.h"
#import "LinkManViewController.h"
#import <EaseMobSDKFull/EaseMob.h>

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    [self.view addSubview:self.tableView];
    [self showLinkMan];
    
    
}

#pragma mark -----CustomMethod

- (void)showLinkMan{
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"联系人" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnAction)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)rightBarBtnAction{
    LinkManViewController *linkVC = [[LinkManViewController alloc] init];
    [self.navigationController pushViewController:linkVC animated:YES];
    
}


#pragma mark --------------UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark --------------UITableViewDelegate

#pragma mark --------------Lazyloading

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
