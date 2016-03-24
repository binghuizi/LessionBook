//
//  FavoriteViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteTableViewCell.h"
#import "SqlModel.h"
#import <BmobSDK/BmobUser.h>
#import "DetailViewController.h"
@interface FavoriteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *allBookArray;
@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.title = @"我的收藏";
    [self addSqlAction];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FavoriteTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   
    
   
    
    
    
}
-(void)addSqlAction{
    
    SqlModel *model = [[SqlModel alloc]init];
    BmobUser *user = [BmobUser getCurrentUser];
    if (user != nil) {
    self.allBookArray = [model seleatAllBookInfor:user.username];
        
    }
  
    
    
}
//行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allBookArray.count;
}

//cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BookInformation *info = self.allBookArray[indexPath.row];
    cell.titleNameLabel.text = info.bookName;
    cell.introductionLabel.text = info.bookIntroduction;
    
    return cell;
}
//点击触发事件 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVc = [[DetailViewController alloc]init];
    BookInformation *info = self.allBookArray[indexPath.row];
    detailVc.pictchString = info.imageString;
    detailVc.titleString = info.bookName;
    detailVc.miaoshuString = info.bookIntroduction;
    detailVc.idString = info.bookId;
    [self.navigationController pushViewController:detailVc animated:YES];
}
#pragma mark --- 删除操作
//1.设置可编辑
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [self.tableView setEditing:YES animated:YES];
}
//2.哪一行可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//3.编辑样式 删除

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

//4.编辑完样式 删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SqlModel *model = [SqlModel sharedInstance];
    BmobUser *user = [BmobUser getCurrentUser];
    BookInformation *info = self.allBookArray[indexPath.row];
    if (user != nil) {
        if ([model delegateInfoBookSql:user.username bookId:info.bookId]== 1) {
            
            
           //删除tableview某一行
            [self.allBookArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            
            NSLog(@"%@  %@",user.username,info.bookId);
        }
        
    }

    //通知tableView删除成功
    
    
    
}





- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 80;
    }
    return _tableView;
}
-(NSMutableArray *)allBookArray{
    if (_allBookArray == nil) {
        self.allBookArray = [NSMutableArray new];
    }
    return _allBookArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
