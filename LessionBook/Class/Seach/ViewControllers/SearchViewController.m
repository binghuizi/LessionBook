//
//  SearchViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "SearchViewController.h"
#import <AFNetworking.h>
#import "VOSegmentedControl.h"
#import "SearchModel.h"
#import <UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "PlayViewController.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

{
    NSInteger _index;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VOSegmentedControl *segmentControl;


@property (nonatomic, strong) NSMutableArray *danjiArray;
@property (nonatomic, strong) NSMutableArray *xiaoshuoArray;

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, copy) NSString *Searchtext;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    [self showBackBtn];
    [self showRightBtn];
    
    //添加数组
    [self.listArray addObject:self.danjiArray];
    [self.listArray addObject:self.xiaoshuoArray];
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.tableView];
    _index = 0;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark ----------CustomMethod

- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    [backBtn setImage:[UIImage imageNamed:@"search_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

- (void)backBtnAction{
    self.tableView.hidden = YES;
    self.segmentControl.hidden = YES;
    self.searchBar.text = nil;

}

- (void)showRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 44);
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)rightBtnAction{
    [self.searchBar resignFirstResponder];
    self.segmentControl.hidden = NO;
    self.tableView.hidden = NO;
    self.Searchtext = [self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSLog(@"%@", self.Searchtext);
    [self requestModel];
}
- (void)requestModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [sessionManager GET:[NSString stringWithFormat:kSearch, self.Searchtext] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        
        NSDictionary *successDic = responseObject;
        NSArray *dataArray = successDic[@"data"];
        if (dataArray.count > 0) {
            //如果请求的数据小说单集都有则赋值
            if (dataArray.count == 2) {
                NSDictionary *firstdic = dataArray[0];
                NSDictionary *seconddic = dataArray[1];
                NSDictionary *firstDoc = firstdic[@"doclist"];
                NSString *firstgroup = firstdic[@"groupValue"];
                NSDictionary *secondDoc = seconddic[@"doclist"];
                NSString *secondgroup = seconddic[@"groupValue"];
                NSArray *firstArray = firstDoc[@"docs"];
                NSArray *secondArray = secondDoc[@"docs"];
                if (self.xiaoshuoArray.count > 0) {
                    [self.xiaoshuoArray removeAllObjects];
                }
                if (self.danjiArray.count > 0) {
                    [self.danjiArray removeAllObjects];
                }
                for (NSDictionary *dic in firstArray) {
                    SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
                    if ([firstgroup isEqualToString:@"virtualprogram"]) {
                        [self.danjiArray addObject:model];
                    }else{
                        [self.xiaoshuoArray addObject:model];
                    }
                }
                for (NSDictionary *dic in secondArray) {
                    SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
                    if ([secondgroup isEqualToString:@"virtualchannel"]) {
                        [self.xiaoshuoArray addObject:model];
                        
                    }else{
                        [self.danjiArray addObject:model];
                    }
                }
                [self.tableView reloadData];
            }else{
                NSDictionary *firstdic = dataArray[0];
                NSDictionary *firstDoc = firstdic[@"doclist"];
                NSString *firstgroup = firstdic[@"groupValue"];
                NSArray *firstArray = firstDoc[@"docs"];
                if (self.xiaoshuoArray.count > 0) {
                    [self.xiaoshuoArray removeAllObjects];
                }
                if (self.danjiArray.count > 0) {
                    [self.danjiArray removeAllObjects];
                }
                for (NSDictionary *dic in firstArray) {
                    SearchModel *model = [[SearchModel alloc] initWithDictionary:dic];
                    if ([firstgroup isEqualToString:@"virtualprogram"]) {
                        [self.danjiArray addObject:model];
                    }else{
                        [self.xiaoshuoArray addObject:model];
                    }
                }
                [self.tableView reloadData];
            }
            //返回数据中无数据
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无相关数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)segmentCtrlValueChange:(VOSegmentedControl *)segmentCtrl{
    switch (segmentCtrl.selectedSegmentIndex) {
        case 0:
            _index = 0;
            [self.tableView reloadData];
            break;
        case 1:
            _index = 1;
            [self.tableView reloadData];
            break;
        case 2:
            _index = 2;
            [self.tableView reloadData];
            break;
        default:
            break;
    }
    
}


#pragma mark ----------Lazyloading

- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kWideth - 120, 44)];
        self.searchBar.placeholder = @"搜索书名，作者";
        self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kWideth, kHeight - 108) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 50;
        self.tableView.hidden = YES;
    }
    return _tableView;
}

- (VOSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"全部"}, @{VOSegmentText:@"小说"}, @{VOSegmentText:@"单集"}]];
        self.segmentControl.frame = CGRectMake(0, 0, kWideth, 44);
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
        self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentControl.backgroundColor = [UIColor whiteColor];
        self.segmentControl.selectedTextColor = [UIColor orangeColor];
        self.segmentControl.selectedIndicatorColor = [UIColor orangeColor];
        self.segmentControl.indicatorThickness = 4;
        [self.segmentControl addTarget:self action:@selector(segmentCtrlValueChange:) forControlEvents:UIControlEventValueChanged];
        self.segmentControl.hidden = YES;
    }
    return _segmentControl;
}

- (NSMutableArray *)danjiArray{
    if (_danjiArray == nil) {
        self.danjiArray = [NSMutableArray new];
    }
    return _danjiArray;
}

- (NSMutableArray *)xiaoshuoArray{
    if (_xiaoshuoArray == nil) {
        self.xiaoshuoArray = [NSMutableArray new];
    }
    return _xiaoshuoArray;
}
-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

#pragma mark ----------UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_index == 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_index == 0) {
        if (section == 0) {
            return [self.listArray[0] count];
        }
        return [self.listArray[1] count];
    }else if (_index == 1){
        return [self.listArray[1] count];
    }else{
        return [self.listArray[0] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    switch (_index) {
        case 0:{
            if (self.listArray.count > 0) {
                if ([self.listArray[indexPath.section] count] > 0) {
                    SearchModel *model = self.listArray[indexPath.section][indexPath.row];
                    cell.textLabel.text = model.name;
                    cell.detailTextLabel.text = model.catname;
                    if (cell.imageView.image != nil) {
                        cell.imageView.image = nil;
                    }
                }
            }
        }
            break;
        case 1:{
            if ([self.listArray[1] count] > 0) {
                SearchModel *model = self.listArray[1][indexPath.row];
                cell.textLabel.text = model.name;
                cell.detailTextLabel.text = model.catname;
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
            }
        }
            break;
        case 2:{
            if ([self.listArray[0] count] > 0) {
                SearchModel *model = self.listArray[0][indexPath.row];
                cell.textLabel.text = model.name;
                cell.detailTextLabel.text = model.cname;
                if (cell.imageView.image != nil) {
                    cell.imageView.image = nil;
                }
            }
        }
            break;
    }
    return cell;
}

#pragma mark ----------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (_index) {
        case 0:
        {
            
                DetailViewController *detailVC = [[DetailViewController alloc] init];
                SearchModel *model = self.listArray[indexPath.section][indexPath.row];
            if (indexPath.section == 0) {
                detailVC.titleString = model.cname;
            }else{
            detailVC.titleString = model.name;
            }
                detailVC.pictchString = model.cover;
                detailVC.miaoshuString = model.miaoshu;
                detailVC.idString = model.cid;
                [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 1:
        {
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            SearchModel *model = self.xiaoshuoArray[indexPath.row];
            detailVC.titleString = model.name;
            detailVC.pictchString = model.cover;
            detailVC.miaoshuString = model.miaoshu;
            detailVC.idString = model.cid;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 2:
        {
        
        }
            break;
    }
}


#pragma mark ----------UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    self.segmentControl.hidden = NO;
    self.tableView.hidden = NO;
    self.Searchtext = [self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSLog(@"%@", self.Searchtext);
    [self requestModel];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
    self.segmentControl.hidden = NO;
    self.tableView.hidden = NO;
    self.Searchtext = [self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSLog(@"%@", self.Searchtext);
    [self requestModel];
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
