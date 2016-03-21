//
//  SearchModel.m
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.catid = dic[@"catid"];
        self.catname = dic[@"catname"];
        self.cid = dic[@"cid"];
        self.cname = dic[@"cname"];
        self.dimensionid = dic[@"dimensionid"];
        self.dimensionname = dic[@"dimensionname"];
        self.name = dic[@"name"];
        self.parentid = dic[@"parentid"];
        self.parenttype = dic[@"parenttype"];
        self.pid = dic[@"pid"];
        self.rank = dic[@"rank"];
        self.score = dic[@"score"];
        self.subtype = dic[@"subtype"];
        self.type = dic[@"type"];
        self.cover = dic[@"cover"];
        self.miaoshu = dic[@"description"];
    }
    return self;
}

@end
