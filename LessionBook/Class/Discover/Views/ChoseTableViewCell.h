//
//  ChoseTableViewCell.h
//  LessionBook
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseModel.h"
@interface ChoseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *manyBtn;
@property (weak, nonatomic) IBOutlet UIButton *onebtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;


@property (nonatomic,strong) ChoseModel *model;
@property(nonatomic,strong) NSArray *dataArray;
@end
