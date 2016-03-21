//
//  HWTools.h
//  LessionBook
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTools : NSObject
//字符串转化成整型
+(NSInteger)number:(NSString *)numString;
//获取当前系统时间
+ (NSDate *)getSystemNowDate;

@end
