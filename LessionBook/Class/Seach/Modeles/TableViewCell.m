//
//  TableViewCell.m
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "TableViewCell.h"
#import "DownlaodTask.h"


@interface TableViewCell ()<NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timesLabel;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;

@property (strong, nonatomic) detailModel *twoModel;


@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.downloadBtn addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    //注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnTitle:) name:@"title" object:nil];
}

//通知的方法

- (void)changeBtnTitle:(NSNotification *)notification{
    detailModel *model = notification.userInfo[@"model"];
    NSString *progress = notification.userInfo[@"progress"];
    if ([self.twoModel.parentname isEqualToString:model.parentname]) {
        if ([progress isEqualToString:@"1.00"]) {
            [self.downloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
        }else{
            [self.downloadBtn setTitle:[NSString stringWithFormat:@"%.f%%", [progress doubleValue] * 100] forState:UIControlStateNormal];
        }
    }
}

-(void)setModel:(detailModel *)model{
    self.twoModel = model;
    self.bookNameLabel.text = model.name;
    NSInteger num = [HWTools number:model.duration];
    NSInteger n1 = num/60;
    NSInteger n2 = num%60;
    self.timesLabel.text = [NSString stringWithFormat:@"时长：%ld分%ld秒",n1,n2];
    
}


- (void)downloadAction{
    DownlaodTask *task = [DownlaodTask shareInstance];
    [task addDownLoadModel:self.twoModel];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载提示" message:@"已添加到下载队列" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
