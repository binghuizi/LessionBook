//
//  GroupViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "GroupViewController.h"
#import <EaseMob.h>
#import "SingleViewController.h"
#import "NewGroupViewController.h"

@interface GroupViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//群组列表
@property (nonatomic, strong) NSArray *groupListArray;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    //创建群组按钮
    [self showRightBarButton:@"新建"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    EMError *error = nil;
    self.groupListArray = [[EaseMob sharedInstance].chatManager fetchAllPublicGroupsWithError:&error];
    if (!error) {
        NSLog(@"%lu", self.groupListArray.count);
    }
    [self.tableView reloadData];
}

#pragma mark -----UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (self.groupListArray.count > 0) {
        EMGroup *group = self.groupListArray[indexPath.row];
        cell.textLabel.text = group.groupId;
        cell.detailTextLabel.text = group.groupDescription;
        cell.imageView.image = [UIImage imageNamed:@"renren"];
    }
    return cell;
}

#pragma mark -----UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.groupListArray.count > 0) {
        EMGroup *group = self.groupListArray[indexPath.row];
        NSString *usrename = [[EaseMob sharedInstance].chatManager apnsNickname];
        if ([group.owner isEqualToString:usrename]) {
            
        }else{
        [[EaseMob sharedInstance].chatManager asyncJoinPublicGroup:group.groupId completion:^(EMGroup *group, EMError *error) {
            if (!error) {
                NSLog(@"入群成功");
            }
        } onQueue:nil];
        }
        SingleViewController *singleVC = [[SingleViewController alloc] initWithConversationChatter:group.groupId conversationType:eConversationTypeGroupChat];
        [self.navigationController pushViewController:singleVC animated:YES];
    }
}

#pragma mark -----Lazyloading

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark -----CustomMethod

-(void)leftTitleAction:(UIButton *)btn{
    UIStoryboard *groupSB = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    NewGroupViewController *newgroupVC = [groupSB instantiateInitialViewController];
    [self.navigationController pushViewController:newgroupVC animated:YES];
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
