//
//  DownloadDidTableViewCell.m
//  LessionBook
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DownloadDidTableViewCell.h"

@interface DownloadDidTableViewCell ()

@property (nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) UILabel *fileNameLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation DownloadDidTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;
}


#pragma mark -----CustomMethod

- (void)configView{
    self.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.0];
    [self addSubview:self.bookNameLabel];
    [self addSubview:self.fileNameLabel];
    [self addSubview:self.sizeLabel];
    [self addSubview:self.timeLabel];
}

#pragma mark -----Lazyloading

- (UILabel *)bookNameLabel{
    if (_bookNameLabel == nil) {
        self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
        self.bookNameLabel.font = [UIFont systemFontOfSize:16.0];
        self.bookNameLabel.text = @"熊猫";
    }
    return _bookNameLabel;
}

- (UILabel *)fileNameLabel{
    if (_fileNameLabel == nil) {
        self.fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bookNameLabel.bottom, kScreenWidth / 3, 20)];
        self.fileNameLabel.font = [UIFont systemFontOfSize:14];
        self.fileNameLabel.textColor = [UIColor lightGrayColor];
        self.fileNameLabel.text = @"熊猫";
    }
    return _fileNameLabel;
}

- (UILabel *)sizeLabel{
    if (_sizeLabel == nil) {
        self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.fileNameLabel.right, self.bookNameLabel.bottom, kScreenWidth / 3, 20)];
        self.sizeLabel.font = [UIFont systemFontOfSize:14];
        self.sizeLabel.textColor = [UIColor lightGrayColor];
        self.sizeLabel.text = @"熊猫";
    }
    return _sizeLabel;
}


- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sizeLabel.right, self.bookNameLabel.bottom, kScreenWidth / 3, 20)];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.text = @"熊猫";
    }
    return _timeLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
