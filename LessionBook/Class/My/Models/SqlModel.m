//
//  SqlModel.m
//  LessionBook
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "SqlModel.h"
#import "BookInformation.h"
#import <sqlite3.h>
@implementation SqlModel
//创建一个静态 单利对象  初始值为空
static SqlModel *dbManger = nil;

+(SqlModel *)sharedInstance{
    if (dbManger == nil) {
        dbManger = [[SqlModel alloc]init];
    }
    return dbManger;
}
//创建一个静态的数据库  dataBase数据库对象的地址
static sqlite3 *dataBase = nil;
//创建 引入数据库表的头文件
-(void)createDataBase{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    dataBasePath = [documentPath stringByAppendingPathComponent:@"DSN.sqlite"];
    //dataBasePath 是数据库文件的路径，UTF8String编码格式
    //创建一个静态的数据库  database 数据库对象的地址
    //数据库存在打开操作 不存在重新创建
    
}

//打开数据库
-(void)openDataBase:(NSString *)userId{
    if (dataBase != nil) {
        return;
    }else{
        [self createDataBase];//为空创建数据库
    }
//dataBasePath 是数据库文件的路径，UTF8String编码格式  静态的数据库  dataBase数据库对象的地址
    sqlite3_open([dataBasePath UTF8String], &dataBase);
    NSLog(@"%@",dataBasePath);
    int result = sqlite3_open([dataBasePath UTF8String], &dataBase);
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功");
        
        [self createDataBaseTable:userId];//打开数据库成功 然后创建表
    }else{
        NSLog(@"打开数据库失败");
    }
}
//创建表
-(void)createDataBaseTable:(NSString *)tableName{
    
    NSString *sql = [NSString stringWithFormat:@"%@%@%@",@"create table DSN",tableName,@"(userId text not null,bookId integer primary key autoincrement,bookName text not null,bookIntroduct text not null,imageString text not null)"];
    NSLog(@"%@",sql);
    char *error = nil;
    //执行SQL语句 1.database数据库 2.SQL语句UTF8编码格式 3.函数回调 当这条语句执行完 会调用你提供的函数，可以是null 4.是你提供的指针变量 会最终传到你回调函数中去5.是错误信息 是指针类型 接收执行sqlite3错误信息 也可以null
    sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &error);
    
}

//关闭
-(void)closeDataBase{
    if (sqlite3_close(dataBase) == SQLITE_OK) {
        NSLog(@"关闭数据库成功");
        dataBase = nil;
    }else{
        NSLog(@"关闭数据库失败");
    }
}

#pragma mark -- 数据库常用操作
//添加
-(BOOL)insertIntoBookSql:(BookInformation *)bookInfor tableName:(NSString *)userId{
    NSLog(@"%@",userId);
    //1打开数据库
    [self openDataBase:userId];
    //sqlite3——stmt SQL语句
    sqlite3_stmt *stmt = nil;
    //执行sql语句
    
    NSString *sql = [NSString stringWithFormat:@"insert into DSN%@ values('%@','%@','%@','%@','%@')",userId,bookInfor.userId,bookInfor.bookId,bookInfor.bookName,bookInfor.bookIntroduction,bookInfor.imageString];
    //验证SQL语句
    int  result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据库成功");
//验证SQL语句 1.数据库 2.SQL语句 3. 4.指针
        sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
        
        
        return YES;
    }else{
        NSLog(@"添加数据库失败");
    }
    
    //删除释放
    sqlite3_finalize(stmt);
    return NO;
}

//删
-(BOOL)delegateInfoBookSql:(NSString *)tableName bookId:(NSString *)bookId{
    [self openDataBase:tableName];
    NSString *sql = [NSString stringWithFormat:@"delete from DSN%@ where bookId = '%@'",tableName,bookId];
    if (sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
        NSLog(@"根据书Id删除成功");
        return 1;
    }else{
        NSLog(@"根据书ID删除失败");
        
        return 0;
    }
}

//查

-(NSMutableArray *)seleatAllBookInfor:(NSString *)tableName{
    [self openDataBase:tableName];
    NSString *sql = [NSString stringWithFormat:@"select *from DSN%@",tableName];
    sqlite3_stmt *stmt = nil;
    NSMutableArray *bookArray = [NSMutableArray array];
    if (sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        NSLog(@"查询所有人成功");
        //遍历数据库所有数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //每一列数据
            const unsigned char *userId      = sqlite3_column_text(stmt,0);
            const unsigned char *bookId      = sqlite3_column_text(stmt,1);
            const unsigned char *bookName    = sqlite3_column_text(stmt,2);
            const unsigned char *bookIntro   = sqlite3_column_text(stmt,3);
            const unsigned char *imageString = sqlite3_column_text(stmt,4);
            //将每一列数据进行转换
            NSString *bookUserId      = [NSString stringWithUTF8String:(const char *)userId];
            NSString *bookBookId      = [NSString stringWithUTF8String:(const char *)bookId];
            NSString *bookBookName    = [NSString stringWithUTF8String:(const char *)bookName];
            NSString *bookBookIntro   = [NSString stringWithUTF8String:(const char *)bookIntro];
            NSString *bookImageString = [NSString stringWithUTF8String:(const char *)imageString];
            
            //给对象赋值，将对象放到数据库里
            BookInformation *book = [[BookInformation alloc]init];
            book.userId = bookUserId;
            book.bookId = bookBookId;
            book.bookName = bookBookName;
            book.bookIntroduction = bookBookIntro;
            book.imageString = bookImageString;
            [bookArray addObject:book];
            
            
            
            
        }
    }else{
        NSLog(@"查询所有人失败");
    }
    
    sqlite3_finalize(stmt);
    return bookArray;
    
}
































@end
