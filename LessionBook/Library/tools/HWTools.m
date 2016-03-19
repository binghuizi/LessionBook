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
@end
