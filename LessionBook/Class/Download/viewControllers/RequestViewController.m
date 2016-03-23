//
//  RequestViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "RequestViewController.h"
#import <EaseMob.h>
#import <BmobSDK/Bmob.h>

@interface RequestViewController ()<UITableViewDataSource, UITableViewDelegate, EMChatManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *search;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation RequestViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    self.navigationItem.titleView = self.search;
    [self showRightBtn];
    [self showBackButton:@"ic_arrow_general2"];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

}

#pragma mark -------------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    BmobUser *user = self.listArray[indexPath.row];
    cell.textLabel.text = user.username;
    cell.imageView.image = [UIImage imageNamed:@"surprise_24"];
    return cell;
}


#pragma mark -------------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobUser *user = self.listArray[indexPath.row];
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager apnsNickname];
    if ([user.username isEqualToString:loginUsername]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NO" message:@"不能添加自己为好友" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
        [alertView show];
        return;
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"好友邀请" message:@"好友验证信息" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertC) weakAlert = alertC;
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *str = [weakAlert.message stringByAppendingString:textField.text];
        weakAlert.message = str;
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
      bool isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:user.username message:@"我想加您为好友" error:&error];
        if (isSuccess) {
            NSLog(@"------发送成功");
        }else{
            NSLog(@"----%@",error);
        }
    }];
    [alertC addAction:action];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}


#pragma mark -------------Lazyloading

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 108) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}


- (UITextField *)search{
    if (_search == nil) {
        self.search = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        self.search.placeholder = @"好友名称";
        self.search.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _search;
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}


//右侧搜索按钮

- (void)showRightBtn{
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(seachFriend)];
    self.navigationItem.rightBarButtonItem = barBtn;
}



#pragma mark -------------CustomMethod

//搜索好友
- (void)seachFriend{
    [self.search resignFirstResponder];
    //查询用户表
    BmobQuery *bquery = [BmobUser query];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (self.listArray.count > 0) {
            [self.listArray removeAllObjects];
        }
        for (BmobUser *user in array) {
            if ([user.username containsString:self.search.text]) {
                [self.listArray addObject:user];
            }
        }
        [self.tableView reloadData];
    }];
}

@end
