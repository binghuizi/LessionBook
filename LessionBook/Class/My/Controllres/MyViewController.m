//
//  MyViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "MyViewController.h"

#import "FavoriteViewController.h"

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *myArray;
@property (nonatomic, retain) NSArray *detailArray;
@property (nonatomic, retain) UIView *headView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    self.myArray = [NSArray arrayWithObjects:@"我的收藏", @"最近收听", @"定时关闭", @"更多设置", nil];
    self.detailArray = [NSArray arrayWithObjects:@"暂无收藏", @"暂无收听记录", @"", @"",nil];
    [self confineHeadView];
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.myArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = self.detailArray[indexPath.row];
     cell.textLabel.text = self.myArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"userinfo_collection"];
    }else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"userinfo_history"];
    }else if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"userinfo_timer"];
    }else if (indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"userinfo_setting"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            FavoriteViewController *favoriteVC = [[FavoriteViewController alloc] init];
            [self.navigationController pushViewController:favoriteVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)confineHeadView{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 200)];
    self.tableView.tableHeaderView = self.headView;
    self.headView.backgroundColor = [UIColor greenColor];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 70, 100, 100);
    [loginBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 50;
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 100, 250, 30)];
    welcomeLabel.text = @"欢迎来到马里亚纳听书";
    welcomeLabel.textColor = [UIColor whiteColor];
    
    [self.headView addSubview:loginBtn];
    [self.headView addSubview:welcomeLabel];
}
- (void)loginAction{
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 80;
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
