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

-(void)setModel:(detailModel *)model{
    self.bookNameLabel.text = model.name;
    NSInteger num = [HWTools number:model.duration];
    NSInteger n1 = num/60;
    NSInteger n2 = num%60;
    self.timesLabel.text = [NSString stringWithFormat:@"时长：%ld分%ld秒",n1,n2];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
