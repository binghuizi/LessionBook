//
//  ChoseTableViewCell.m
//  LessionBook
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "ChoseTableViewCell.h"
#import <UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface ChoseTableViewCell()



@end


@implementation ChoseTableViewCell
//@property (weak, nonatomic) IBOutlet UIButton *onebtn;
//@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
//@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ChoseModel *)model{
    if (model.items.count == 4) {
       
        self.zhuboArray  = [NSMutableArray new];
        self.zuozheArray = [NSMutableArray new];
        self.idArray     = [NSMutableArray new];
        self.typeIdArray = [NSMutableArray new];
        [self.typeIdArray addObject:model.id];
        NSDictionary *itemDic  = model.items[0];
        NSDictionary *itemDic1 = model.items[1];
        NSDictionary *itemDic2 = model.items[2];
        
        NSDictionary *detall = itemDic[@"detail"];
        NSDictionary *detall1 = itemDic1[@"detail"];
        NSDictionary *detall2 = itemDic2[@"detail"];
        
        NSArray *broadArray = detall[@"broadcasters"];
        NSArray *broadArray1 = detall1[@"broadcasters"];
        NSArray *broadArray2 = detall2[@"broadcasters"];
        
        if (broadArray.count != 0) {
            NSDictionary *zhu  = broadArray[0];
            NSDictionary *zuo = broadArray[1];
            
            [self.zhuboArray addObject:zhu[@"name"]];
            [self.zuozheArray addObject:zuo[@"name"]];
            [self.idArray addObject:detall[@"id"]];
            
        }else if ( broadArray.count == 0){
            [self.zhuboArray addObject:@" "];
            [self.zuozheArray addObject:@" "];
            [self.idArray addObject:detall[@"parentid"]];
        }

        
        if (broadArray1.count != 0) {
            NSDictionary *zhu1  = broadArray1[0];
            NSDictionary *zuo1  = broadArray1[1];
            
            [self.zhuboArray addObject:zhu1[@"name"]];
            [self.zuozheArray addObject:zuo1[@"name"]];
            [self.idArray addObject:detall1[@"id"]];
            
        }else if ( broadArray1.count == 0){
            
            [self.zhuboArray  addObject:@" "];
            [self.zuozheArray addObject:@" "];
            [self.idArray addObject:detall1[@"parentid"]];
        }
        
        if (broadArray2.count != 0) {
            NSDictionary *zhu2  = broadArray2[0];
            NSDictionary *zuo2  = broadArray2[1];
            
            [self.zhuboArray addObject:zhu2[@"name"]];
            [self.zuozheArray addObject:zuo2[@"name"]];
            [self.idArray addObject:detall2[@"id"]];
        }else if ( broadArray2.count == 0){
            
            [self.zhuboArray  addObject:@" "];
            [self.zuozheArray addObject:@" "];
            [self.idArray addObject:detall2[@"parentid"]];
        }
        
        
        
//        [self.onebtn   sd_setImageWithURL:[NSURL URLWithString:itemDic[@"bigthumb"]] forState:UIControlStateNormal];
        [self.oneImage sd_setImageWithURL:[NSURL URLWithString:itemDic[@"bigthumb"]]];
        [self.twoImage sd_setImageWithURL:[NSURL URLWithString:itemDic1[@"bigthumb"]]];
        [self.threeImage sd_setImageWithURL:[NSURL URLWithString:itemDic2[@"bigthumb"]]];
        
        [self.typeBtn setTitle:model.name forState:UIControlStateNormal];
        
        [self.onebtn   setTitle:itemDic[@"name"] forState:UIControlStateNormal];
        [self.twoBtn   setTitle:itemDic1[@"name"] forState:UIControlStateNormal];
        [self.threeBtn setTitle:itemDic2[@"name"] forState:UIControlStateNormal];
        
        [self.onebtn   addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.twoBtn   addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.threeBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.onebtn.tag   = 0;
        self.twoBtn.tag   = 1;
        self.threeBtn.tag = 2;
        
      
        self.imageArray = [NSMutableArray arrayWithObjects:
                           itemDic[@"bigthumb"],
                           itemDic1[@"bigthumb"],
                           itemDic2[@"bigthumb"], nil];
        
        self.miaosuArray = [NSMutableArray arrayWithObjects:
                            itemDic[@"desc"],
                            itemDic1[@"desc"],
                            itemDic2[@"desc"], nil];
        self.titleArray = [NSMutableArray arrayWithObjects:
                           itemDic[@"name"],
                           itemDic1[@"name"],
                           itemDic2[@"name"], nil];
        
        
        [self.manyBtn addTarget:self action:@selector(manyAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
    }else{
        
    }
    
    

    
}

-(void)detailAction:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            [self.delgate showImage: self.imageArray[0] anchor:self.zhuboArray[0] author:self.zuozheArray[0] describe:self.miaosuArray[0] titleName:self.titleArray[0] idString:self.idArray[0]];
            
        }
            break;
        case 1:
        {
            [self.delgate showImage: self.imageArray[1] anchor:self.zhuboArray[1] author:self.zuozheArray[1] describe:self.miaosuArray[1] titleName:self.titleArray[1] idString:self.idArray[1]];
        }
            break;
        case 2:
        {
           [self.delgate showImage: self.imageArray[2] anchor:self.zhuboArray[2] author:self.zuozheArray[2] describe:self.miaosuArray[2] titleName:self.titleArray[2] idString:self.idArray[2]];
        }
            break;
            
        default:
            break;
    }
}

-(void)manyAction{
    [self.delgate typeIdString:self.typeIdArray[0]];
}




@end
