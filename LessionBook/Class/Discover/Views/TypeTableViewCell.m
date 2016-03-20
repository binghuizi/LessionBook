//
//  TypeTableViewCell.m
//  LessionBook
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "TypeTableViewCell.h"

@implementation TypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(TypeModel *)model{
    self.displaynameLabel.text = model.displayname;
    //self.countLabel.text = model.programsCnt;
    self.anchorLabel.text = [NSString stringWithFormat:@"主播：%@",model.name];
    
}
@end
