//
//  TableViewCell.h
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"

@protocol downloadDelegate <NSObject>

- (void)downloadModel:(detailModel *)model;

@end


@interface TableViewCell : UITableViewCell
@property(nonatomic,strong) detailModel *model;
@property (nonatomic, assign) id<downloadDelegate>delegate;

@end
