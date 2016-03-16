//
//  TableViewCell.m
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timesLabel;

@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
