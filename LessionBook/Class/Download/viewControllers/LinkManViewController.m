//
//  LinkManViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "LinkManViewController.h"
#import <EaseMob.h>
#import "RequestViewController.h"
#import "SingleViewController.h"
#import "GroupViewController.h"

@interface LinkManViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//好友列表
@property (nonatomic, strong) NSArray *friendArray;

@end

@implementation LinkManViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"好友";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    [self showBackButton:@"ic_arrow_general2"];
    [self showAddFriendBtn];
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
    EMError *error = nil;
     self.friendArray = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:&error];
    if (!error) {
        NSLog(@"--------40-------获取好友成功");
    }
    [self.tableView reloadData];
}

#pragma mark -----UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendArray.count + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"申请与通知";
            cell.imageView.image = [UIImage imageNamed:@"category_reply_s"];
            break;
        case 1:
            cell.textLabel.text = @"群组";
            cell.imageView.image = [UIImage imageNamed:@"exp_watch"];
            break;
        default:{
            if (self.friendArray.count > 0) {
                EMBuddy *buddy = self.friendArray[indexPath.row - 3];
                cell.textLabel.text = buddy.username;
                cell.imageView.image = [UIImage imageNamed:@"exp_pig"];
            }
        }
            break;
    }
    return cell;
}

#pragma mark -----UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"暂无通知" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 1:
        {
            GroupViewController *groupVC = [[GroupViewController alloc] init];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
            break;
        default:
        {
            EMBuddy *buddy = self.friendArray[indexPath.row - 3];
            SingleViewController *singleVC = [[SingleViewController alloc] initWithConversationChatter:buddy.username conversationType:eConversationTypeChat];
            [self.navigationController pushViewController:singleVC animated:YES];
        }
            break;
    }
}

#pragma mark -----CustomMethod

- (void)showAddFriendBtn{
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 44, 44);
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)addFriendAction:(UIButton *)btn{
    RequestViewController *requestVC = [[RequestViewController alloc] init];
    [self.navigationController pushViewController:requestVC animated:YES];
}

//返回
- (void)backAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -----Lazyloading

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate  = self;
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
