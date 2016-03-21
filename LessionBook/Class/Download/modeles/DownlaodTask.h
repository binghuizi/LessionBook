//
//  DownlaodTask.h
//  LessionBook
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "detailModel.h"


@interface DownlaodTask : NSObject

+ (instancetype)shareInstance;

- (void)addDownLoadModel:(detailModel *)model;
- (NSMutableArray *)getdownLoadModel;

- (void)deleteModel:(detailModel *)model;

@end
