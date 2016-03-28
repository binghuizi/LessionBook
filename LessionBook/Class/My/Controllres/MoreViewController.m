//
//  MoreViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"更多设置";
    [self.view addSubview:self.tableView];
    self.listArray = [NSMutableArray arrayWithObjects:@"意见反馈",@"给我评分",@"清空缓存",@"账号登录", nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存（%.02fM）",(float)cacheSize / 1024 / 1024];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.listArray replaceObjectAtIndex:2 withObject:cacheStr];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark ----UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = self.listArray[0];
            cell.imageView.image = [UIImage imageNamed:@"mail"];
        }
            break;
        case 1:
        {
            cell.textLabel.text = self.listArray[1];
            cell.imageView.image = [UIImage imageNamed:@"chat"];
        }
            break;
        case 2:
        {
            cell.textLabel.text = self.listArray[2];
            cell.imageView.image = [UIImage imageNamed:@"trash"];
        }
            break;
        case 3:
        {
            cell.textLabel.text = self.listArray[3];
            cell.imageView.image = [UIImage imageNamed:@"man"];
        }
            break;
    }
    return cell;
}

#pragma mark ----UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //意见反馈
            [self sendEmail];
         }
            break;
        case 1:
        {
          //给我评分
            NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 2:
        {
            //清空缓存
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache cleanDisk];
            [self.listArray replaceObjectAtIndex:2 withObject:@"清除缓存"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case 3:
        {
            //账号登录
            UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
            LoginViewController *loginVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
            [self.navigationController pushViewController:loginVC animated:YES];
         }
            break;
    }
}

#pragma mark ----CustomMethod

- (void)sendEmail{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            //设置主题
            [picker setSubject:@"用户信息反馈"];
            //设置收件人
            NSArray *toRecipients = [NSArray arrayWithObjects:@"1535607759@qq.com", nil];
            
            [picker setToRecipients:toRecipients];
            //设置发送内容
            NSString *text  = @"请留下您宝贵的意见";
            [picker setMessageBody:text isHTML:NO];
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"未配置邮箱账号");
        }
    }else{
        NSLog(@"当前设备不能发送");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark ----Lazylaoding

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
