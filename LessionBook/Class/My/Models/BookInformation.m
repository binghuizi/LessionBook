//
//  BookInformation.m
//  LessionBook
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "BookInformation.h"

@implementation BookInformation
-(instancetype)initWithUserId:(NSString *)userId bookId:(NSString *)bookId bookName:(NSString *)bookName bookIntroduction:(NSString *)bookIntroduction imageString:(NSString *)imageString{
    self = [super init];
    if (self) {
        _userId = userId;
        _bookId = bookId;
        _bookName = bookName;
        _bookIntroduction = bookIntroduction;
        _imageString = imageString;
        
    }
    return self;
}

+(instancetype)bookInformationWithUserId:(NSString *)userId bookId:(NSString *)bookId bookName:(NSString *)bookName bookIntroduction:(NSString *)bookIntroduction imageString:(NSString *)imageString{
    BookInformation *bookIntro = [[BookInformation alloc]initWithUserId:userId bookId:bookId bookName:bookName bookIntroduction:bookIntroduction imageString:imageString];
    return bookIntro;
}



@end
