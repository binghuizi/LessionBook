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

@interface LinkManViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.array = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:nil];
    NSLog(@"%lu", self.array.count);
    [self.tableView reloadData];
}

#pragma mark -----UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"申请与通知";
            break;
        case 1:
            cell.textLabel.text = @"群组";
            break;
        case 2:
            cell.textLabel.text = @"聊天室列表";
            break;
        case 3:
            if (self.array.count > 0) {
                EMBuddy *buddy = self.array[0];
                cell.textLabel.text = buddy.username;
            }
            break;
        case 4:
            if (self.array.count == 3) {
                EMBuddy *buddy = self.array[1];
                cell.textLabel.text = buddy.username;
            }
            break;
    }
    
    return cell;
}

#pragma mark -----UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            RequestViewController *requestVC = [[RequestViewController alloc] init];
            [self.navigationController pushViewController:requestVC animated:YES];
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
        {
            EMBuddy *buddy = self.array[0];
            SingleViewController *singleVC = [[SingleViewController alloc] initWithConversationChatter:buddy.username conversationType:eConversationTypeChat];
            [self.navigationController pushViewController:singleVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -----CustomMethod
- (void)showExitBtn{
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashBtnAction)];
    self.navigationItem.rightBarButtonItem = barBtn;
}

- (void)trashBtnAction{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        NSLog(@"%@", info);
    } onQueue:nil];
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
