//
//  SingleTion.m
//  LessionBook
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "SingleTion.h"

@implementation SingleTion

static SingleTion *mango = nil;

+(SingleTion *)shareInstance{
    if (mango == nil) {
        mango = [[SingleTion alloc] init];
        
    }
    return mango;
}



@end
