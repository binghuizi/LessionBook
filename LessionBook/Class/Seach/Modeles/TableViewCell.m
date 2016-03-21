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
