//
//  TypeModel.h
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeModel : NSObject
@property(nonatomic,strong) NSString *listorder;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *parentid;
@property(nonatomic,strong) NSString *Category;
@property(nonatomic,strong) NSString *thumb;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *displayname;//分类中-推荐-米名字
@property(nonatomic,assign) NSInteger programsCnt;//有多少集
@end
