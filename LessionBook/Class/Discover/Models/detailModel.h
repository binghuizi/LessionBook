//
//  detailModel.h
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailModel : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *duration;

@property(nonatomic,strong) NSString *parentname;//标题
@property(nonatomic,strong) NSString *parentcover;//图片
@property(nonatomic,strong) NSString *parentoutline;//描述
@property(nonatomic,strong) NSString *parentid;//获取详情id
@property(nonatomic, strong) NSDictionary *mediainfo; //获取下载路径


@end
