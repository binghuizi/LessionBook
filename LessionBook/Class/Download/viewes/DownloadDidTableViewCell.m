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

}

#pragma mark -----Lazyloading

- (UILabel *)bookNameLabel{
    if (_bookNameLabel == nil) {
        self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
        self.bookNameLabel.backgroundColor = [UIColor whiteColor];
        self.bookNameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _bookNameLabel;
}

- (UILabel *)fileNameLabel{
    if (_fileNameLabel == nil) {
        self.fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bookNameLabel.bottom, kScreenWidth / 3, 20)];
        self.fileNameLabel.font = [UIFont systemFontOfSize:14];
        self.fileNameLabel.textColor = [UIColor lightGrayColor];
    }
    return _fileNameLabel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
