//
//  AccountViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "AccountViewController.h"
#import <BmobSDK/BmobUser.h>
#import <EaseMob.h>
#import "AppDelegate.h"

@interface AccountViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *myAppDelegate;
}
@property (nonatomic, strong)UITableView *tableView;


@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号设置";
    [self.view addSubview:self.tableView];
    
    //头视图
    [self configheaderView];
}

#pragma mark ------------CustomMethod

//添加头视图
- (void)configheaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 80)/ 2, 10, 80, 80)];
    userImageView.image = [UIImage imageNamed:@"a040144d464bf201a150a57abf8f8292"];
    userImageView.layer.cornerRadius = 40;
    userImageView.clipsToBounds = YES;
    UIButton *selectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectImageBtn.frame = CGRectMake((kScreenWidth - 80)/ 2, 10, 80, 80);
    selectImageBtn.backgroundColor = [UIColor clearColor];
    selectImageBtn.layer.cornerRadius = 40;
    selectImageBtn.clipsToBounds = YES;
    [headerView addSubview:userImageView];
    [headerView addSubview:selectImageBtn];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}


#pragma mark ------------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    switch (indexPath.row) {
        case 0:
        {
            BmobUser *user = [BmobUser getCurrentUser];
            if (user != nil) {
            cell.textLabel.text = [NSString stringWithFormat:@"用户名：%@", user.username];
            }else{
            cell.textLabel.text = @"用户名";
            }
        }
            break;
        case 1:
        {
           cell.textLabel.text = @"开通会员";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"地区";
        }
            break;
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

#pragma mark ------------UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        BmobUser *currntUser = [BmobUser getCurrentUser];
        if (currntUser != nil) {
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                if (!error) {
                    [BmobUser logout];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前用户已退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    myAppDelegate.isLogin = 0;
                    [alert show];
                    [self.tableView reloadData];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    [alert show];
                }
            } onQueue:nil];
        }
    }
}

#pragma mark ----------Lazylaoding

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
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
