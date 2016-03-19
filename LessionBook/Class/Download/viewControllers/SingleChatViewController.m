//
//  SingleChatViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "SingleChatViewController.h"

@interface SingleChatViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *messageList;


@end

@implementation SingleChatViewController



- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.messageList];
    
}
#pragma mark -------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    return cell;
}

#pragma mark -------UITableViewDelegate


@end
