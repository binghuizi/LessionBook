//
//  DownlaodTask.m
//  LessionBook
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DownlaodTask.h"



@implementation DownlaodTask

static NSMutableArray *_listArray;

static DownlaodTask *task;
+ (instancetype)shareInstance{
    if (task == nil) {
        task = [[DownlaodTask alloc] init];
        _listArray = [NSMutableArray new];
        
    }
    return task;
}

//添加下载队列

- (void)addDownLoadModel:(detailModel *)model{
    [_listArray addObject:model];
}

//获取下载队列
- (NSMutableArray *)getdownLoadModel{
    NSMutableArray *array = _listArray;
    return array;
}


//删除下载队列


- (void)deleteModel:(detailModel *)model{
    [_listArray removeObject:model];
}


@end
