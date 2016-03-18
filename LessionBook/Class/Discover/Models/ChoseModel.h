//
//  ChoseModel.h
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoseModel : NSObject
@property(nonatomic,strong) NSString *catName;//分类标题
@property(nonatomic,strong) NSString *bigthumb;//图片
@property(nonatomic,strong) NSString *name;    //书名
@property(nonatomic,strong) NSArray *items;
@end
