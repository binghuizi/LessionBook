//
//  HWTools.m
//  LessionBook
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools
+(NSInteger)number:(NSString *)numString{
    NSString *stringName = numString;
  
  
    NSInteger num = [stringName integerValue];
   
    return num;
}
+ (NSDate *)getSystemNowDate{
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}
@end
