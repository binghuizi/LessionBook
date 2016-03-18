//
//  ChoseTableViewCell.m
//  LessionBook
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "ChoseTableViewCell.h"
#import <UIButton+WebCache.h>
@implementation ChoseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ChoseModel *)model{
    if (model.items.count == 4) {
        NSDictionary *itemDic = model.items[0];
        [self.typeBtn setTitle:model.name forState:UIControlStateNormal];
        [self.onebtn sd_setImageWithURL:[NSURL URLWithString:itemDic[@"bigthumb"]] forState:UIControlStateNormal];
        [self.onebtn setTitle:itemDic[@"name"] forState:UIControlStateNormal];
        
        
        NSDictionary *itemDic1 = model.items[1];
        [self.twoBtn sd_setImageWithURL:[NSURL URLWithString:itemDic1[@"bigthumb"]] forState:UIControlStateNormal];
        [self.twoBtn setTitle:itemDic1[@"name"] forState:UIControlStateNormal];
        
        NSDictionary *itemDic2 = model.items[2];
        [self.threeBtn sd_setImageWithURL:[NSURL URLWithString:itemDic2[@"bigthumb"]] forState:UIControlStateNormal];
        [self.threeBtn setTitle:itemDic2[@"name"] forState:UIControlStateNormal];
        
        
        
    }else{
        
    }
    
    
   
    
}



@end
