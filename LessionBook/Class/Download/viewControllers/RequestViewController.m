//
//  RequestViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "RequestViewController.h"
#import <EaseMob.h>

@interface RequestViewController ()<UITableViewDataSource, UITableViewDelegate>
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
    
}

#pragma mark -------------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}


#pragma mark -------------UITableViewDelegate

#pragma mark -------------Lazyloading

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 108) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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

- (void)seachFriend{
    [self.search resignFirstResponder];
    if(_search.text.length > 0)
    {
//#warning 由用户体系的用户，需要添加方法在已有的用户体系中查询符合填写内容的用户
//#warning 以下代码为测试代码，默认用户体系中有一个符合要求的同名用户
        NSString *loginUsername = [[EaseMob sharedInstance].chatManager apnsNickname];
        if ([_search.text isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NO" message:@"不能添加自己为好友" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"申请提示" message:@"你想说点什么" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(alertC) weakAlert = alertC;
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            NSString *str = [weakAlert.message stringByAppendingString:textField.text];
            weakAlert.message = str;
        }];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EMError *error = nil;
            [[EaseMob sharedInstance].chatManager addBuddy:_search.text message:@"我想加您为好友" error:&error];
            if (error == nil) {
                NSLog(@"发送成功");
            }
        }];
        [alertC addAction:action];
        [self.navigationController presentViewController:alertC animated:YES completion:nil];
    }
}


@end
