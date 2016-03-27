//
//  BookInformation.h
//  LessionBook
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookInformation : NSObject
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *bookId;
@property(nonatomic,strong) NSString *bookName;
@property(nonatomic,strong) NSString *bookIntroduction;
@property(nonatomic,strong) NSString *imageString;

+(instancetype)bookInformationWithUserId:(NSString *)userId
                                  bookId:(NSString *)bookId
                                bookName:(NSString *)bookName
                        bookIntroduction:(NSString *)bookIntroduction
                             imageString:(NSString *)imageString;


-(id)initWithUserId:(NSString *)userId
             bookId:(NSString *)bookId
           bookName:(NSString *)bookName
   bookIntroduction:(NSString *)bookIntroduction
        imageString:(NSString *)imageString;

@end
