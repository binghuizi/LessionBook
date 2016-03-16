//
//  SearchViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "SearchViewController.h"


@interface SearchViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    [self showRightBtn];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.tableView];
}

#pragma mark -----CustomMethod
- (void)backbtnAction{
}

- (void)showRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 44);
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

}
- (void)rightBtnAction{

}

#pragma mark -----Lazyloading

- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 120, 44)];
        self.searchBar.searchBarStyle = UISearchBarStyleDefault;
        self.searchBar.barTintColor = [UIColor whiteColor];
        self.searchBar.placeholder = @"搜索书名，作者";
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 108)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 20;
    }
    return _tableView;
}


#pragma mark ------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    return cell;
}

#pragma mark ------UITableViewDelegate

#pragma mark ------UISearchBarDelegate

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
