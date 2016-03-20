//
//  TableViewCell.h
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
@interface TableViewCell : UITableViewCell
@property(nonatomic,strong) detailModel *model;
@end
