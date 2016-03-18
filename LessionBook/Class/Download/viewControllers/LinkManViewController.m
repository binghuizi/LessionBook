//
//  LinkManViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "LinkManViewController.h"

@interface LinkManViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LinkManViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"联系人列表";
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    [self showExitBtn];
}

#pragma mark -----UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark -----UITableViewDelegate


#pragma mark -----CustomMethod
- (void)showExitBtn{
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashBtnAction)];
    self.navigationItem.rightBarButtonItem = barBtn;
}

- (void)trashBtnAction{

}

#pragma mark -----Lazyloading

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate  = self;
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
