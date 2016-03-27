//
//  SqlModel.h
//  LessionBook
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookInformation.h"
@interface SqlModel : NSObject
{
    NSString *dataBasePath;

}
//用单利创建数据管理对象
+(SqlModel *)sharedInstance;
#pragma mark ---数据库基本操作
-(void)createDataBase;//创建
-(void)openDataBase:(NSString *)userId;//打开数据库
-(void)createDataBaseTable:(NSString *)tableName;//创建表
-(void)closeDataBase;//关闭

#pragma mark --- 增 删  查
- (BOOL) insertIntoBookSql:(BookInformation *)bookInfor tableName:(NSString *)userId;
- (BOOL) delegateInfoBookSql:(NSString *)tableName bookId:(NSString *)bookId;
- (NSMutableArray *)seleatAllBookInfor:(NSString *)tableName;




@end
