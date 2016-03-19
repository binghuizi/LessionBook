//
//  NSString+Common.m
//  LessionBook
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

//判断字符串是否是中文

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

@end
