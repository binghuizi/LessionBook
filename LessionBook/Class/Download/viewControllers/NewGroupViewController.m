//
//  NewGroupViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "NewGroupViewController.h"
#import <EaseMob.h>

@interface NewGroupViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *groupName;
@property (strong, nonatomic) IBOutlet UITextField *groupCount;
@property (strong, nonatomic) IBOutlet UITextField *groupDescription;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//好友数组
@property (nonatomic, strong) NSArray *friendArray;
//组员数组
@property (nonatomic, strong) NSMutableArray *groupsArray;

@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.friendArray = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:nil];
}
#pragma mark ----------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (self.friendArray.count > 0) {
        EMBuddy *buddy = self.friendArray[indexPath.row];
        cell.textLabel.text = buddy.username;
        cell.imageView.image = [UIImage imageNamed:@"surprise_24"];
    }
    return cell;
}

#pragma mark ----------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMBuddy *buddy = self.friendArray[indexPath.row];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"群组邀请" message:@"好友已添加至邀请列表" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.groupsArray addObject:buddy];
    }];
    [alertC addAction:action];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}

#pragma mark ----------Lazylaoding

- (NSMutableArray *)groupsArray{
    if (_groupsArray == nil) {
        self.groupsArray = [NSMutableArray new];
    }
    return _groupsArray;
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
