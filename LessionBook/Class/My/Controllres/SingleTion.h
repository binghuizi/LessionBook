//
//  SingleTion.h
//  LessionBook
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTion : NSObject

@property(nonatomic, retain) NSTimer *timer;

+(SingleTion *)shareInstance;
@end
