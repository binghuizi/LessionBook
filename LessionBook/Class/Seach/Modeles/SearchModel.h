//
//  SearchModel.h
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property (nonatomic, copy) NSString *broadcaster;
//类型id
@property (nonatomic, copy) NSString *catid;
//类型名称
@property (nonatomic, copy) NSString *catname;
//小说ID
@property (nonatomic, copy) NSString *cid;
//小说名称
@property (nonatomic, copy) NSString *cname;
//分类ID
@property (nonatomic, copy) NSString *dimensionid;
//分类名称
@property (nonatomic, copy) NSString *dimensionname;
//id
@property (nonatomic, copy) NSString *ID;
//集数名
@property (nonatomic, copy) NSString *name;
//集数id
@property (nonatomic, copy) NSString *parentid;
//类型
@property (nonatomic, copy) NSString *parenttype;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *subtype;
@property (nonatomic, copy) NSString *totalscore;
//类型
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *cover;
-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
