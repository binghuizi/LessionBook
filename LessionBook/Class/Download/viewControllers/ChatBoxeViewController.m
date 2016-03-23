//
//  ChatBoxeViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "ChatBoxeViewController.h"
#import <EaseMobSDKFull/EaseMob.h>

@interface ChatBoxeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//聊天室列表
@property (nonatomic, strong) NSArray *listArray;


@end

@implementation ChatBoxeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊天室";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    [self.view addSubview:self.tableView];
    [self showBackButton:@"ic_arrow_general2"];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [[EaseMob sharedInstance].chatManager asyncFetchChatroomsFromServerWithCursor:nil pageSize:-1 andCompletion:^(EMCursorResult *result, EMError *error) {
        if (!error) {
            self.listArray = result.list;
            NSLog(@"%lu", self.listArray.count);
            [self.tableView reloadData];
        }
    }];
}



#pragma mark ----------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (self.listArray.count > 0) {
        EMChatroom *chatroom = self.listArray[indexPath.row];
        cell.textLabel.text = chatroom.chatroomId;
        cell.imageView.image = [UIImage imageNamed:@"exp_watch"];
    }
    return cell;
}

#pragma mark ----------UITableViewDelegate
#pragma mark ----------懒加载

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 50;
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
