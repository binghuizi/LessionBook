//
//  TypeTableViewCell.h
//  LessionBook
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeModel.h"
@interface TypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *displaynameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *anchorLabel;
@property(nonatomic,strong) TypeModel *model;
@end
