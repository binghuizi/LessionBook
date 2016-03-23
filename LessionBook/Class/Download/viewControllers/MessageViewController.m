//
//  MessageViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "MessageViewController.h"
#import "LinkManViewController.h"
#import <EaseMobSDKFull/EaseMob.h>
#import "SingleViewController.h"

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate,EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

//会话列表数组
@property (nonatomic, strong) NSArray *conversionArray;

@end

@implementation MessageViewController

- (instancetype)init{
   self = [super init];
    if (self) {
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    //导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    [self showBackButton:@"ic_arrow_general2"];
    [self showRightBarButton:@"清空"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //tabBar显示
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
    //获取数据库中的所有会话列表以及是否更新内存中的会话
    self.conversionArray = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    [self.tableView reloadData];
}

#pragma mark -----CustomMethod

- (void)backAction:(UIButton *)btn{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

//移除所有会话记录
-(void)leftTitleAction:(UIButton *)btn{
    [[EaseMob sharedInstance].chatManager removeAllConversationsWithDeleteMessages:self append2Chat:YES];
    self.conversionArray = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    [self.tableView reloadData];
}


#pragma mark --------------UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conversionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (self.conversionArray.count > 0) {
        EMConversation *conversation = self.conversionArray[indexPath.row];
        cell.textLabel.text = conversation.chatter;
        EMMessage *message = conversation.latestMessage;
        id<IEMMessageBody> msBody = message.messageBodies.firstObject;
        switch (msBody.messageBodyType) {
            case eMessageBodyType_Text:{
                NSString *txt = ((EMTextMessageBody *)msBody).text;
                cell.detailTextLabel.text = txt;
                cell.imageView.layer.cornerRadius = 25;
                cell.imageView.clipsToBounds = YES;
                cell.imageView.image = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            }
                break;
            default:
                break;
        }
    }
       return cell;
}

#pragma mark --------------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMConversation *conversation = self.conversionArray[indexPath.row];
    SingleViewController *singleVC = [[SingleViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
    [self.navigationController pushViewController:singleVC animated:YES];
}

#pragma mark --------------Lazyloading

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 50;
    }
    return _tableView;
}

#pragma mark -------EMChatManagerDelegate

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    NSString *str = [NSString stringWithFormat:@"--------------%@请求加你为好友", username];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友邀请" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
    if (error == nil) {
        NSLog(@"----------同意加好友");
    }else{
     NSLog(@"----------失败");
    }
}

- (void)didAcceptedByBuddy:(NSString *)username{
    NSString *str = [NSString stringWithFormat:@"%@同意加你为好友", username];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友邀请" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
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
