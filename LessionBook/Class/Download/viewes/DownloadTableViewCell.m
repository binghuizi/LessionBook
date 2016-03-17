//
//  DownloadTableViewCell.m
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DownloadTableViewCell.h"

@interface DownloadTableViewCell ()

@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;

@property (strong, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;


@end

@implementation DownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.downloadBtn.layer.cornerRadius = 30;
    self.downloadBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.downloadBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
