//
//  DownloadViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DownloadViewController.h"
#import "VOSegmentedControl.h"
#import "DownloadTableViewCell.h"
#import "DownloadDidTableViewCell.h"
#import "DidDownLoadViewController.h"
#import "ChatRoomViewController.h"
#import "DownlaodTask.h"

static NSString *_downloadcell = @"cell";
static NSString *_didDownload = @"did";

@interface DownloadViewController ()<UITableViewDataSource, UITableViewDelegate, downloadDelegate>
@property (nonatomic, strong) VOSegmentedControl *segmentControl;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL selectdidDownload;

@property (nonatomic, strong) NSMutableArray *downlistArray;
//已完成列表
@property (nonatomic, strong) NSMutableArray *didloadArray;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"下载";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segmentControl];
    [self.tableView registerNib:[UINib nibWithNibName:@"DownloadTableViewCell" bundle:nil] forCellReuseIdentifier:_downloadcell];
    [self.tableView registerClass:[DownloadDidTableViewCell class] forCellReuseIdentifier:_didDownload];
    
    self.selectdidDownload = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    DownlaodTask *task = [DownlaodTask shareInstance];
    self.downlistArray = [task getdownLoadModel];
    [self.tableView reloadData];
    
}

#pragma mark ----------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.selectdidDownload) {
        return self.downlistArray.count;
    }
    return self.didloadArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.selectdidDownload) {
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_downloadcell forIndexPath:indexPath];
        cell.model = self.downlistArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    DownloadDidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_didDownload forIndexPath:indexPath];
    if (self.didloadArray.count > 0) {
        cell.model = self.didloadArray[indexPath.row];
    }
    return cell;
}

#pragma mark ----------UITableViewDelegate;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.selectdidDownload) {
        return 75;
    }
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectdidDownload) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        detailModel *model = self.didloadArray[indexPath.row];
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", model.name]];
        NSLog(@"---%@", filePath);
    }
}

#pragma mark ------tableView可编辑状态

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [self.tableView setEditing:YES animated:YES];
}
//让所有cell处于可编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//选择编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.selectdidDownload) {
        detailModel *model = self.downlistArray[indexPath.row];
        DownlaodTask *task = [DownlaodTask shareInstance];
        [task deleteModel:model];
        [self.downlistArray removeObjectAtIndex:indexPath.row];
    }else{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        detailModel *model = self.didloadArray[indexPath.row];
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", model.name]];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:filePath error:nil];
        [self.didloadArray removeObjectAtIndex:indexPath.row];
    }
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark ----------Lazyloding

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kWideth, kHeight - 108) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

- (VOSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"已下载"},@{VOSegmentText:@"正在下载"}]];
        self.segmentControl.frame = CGRectMake(0, 0, kWideth, 44);
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
        self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentControl.selectedTextColor = [UIColor orangeColor];
        self.segmentControl.selectedIndicatorColor = [UIColor orangeColor];
        self.segmentControl.indicatorThickness = 2;
        self.segmentControl.backgroundColor = [UIColor whiteColor];
        [self.segmentControl addTarget:self action:@selector(segmentCtrlValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (NSMutableArray *)downlistArray{
    if (_downlistArray == nil) {
        self.downlistArray = [NSMutableArray new];
    }
    return _downlistArray;
}

- (NSMutableArray *)didloadArray{
    if (_didloadArray == nil) {
        self.didloadArray = [NSMutableArray new];
    }
    return _didloadArray;
}

#pragma mark ----------CustomMethod

- (void)segmentCtrlValueChange:(VOSegmentedControl *)segmentctrl{
    switch (segmentctrl.selectedSegmentIndex) {
        case 0:
            self.selectdidDownload = YES;
            [self.tableView reloadData];
            break;
        case 1:
            self.selectdidDownload = NO;
            [self.tableView reloadData];
            break;
    }
}

#pragma mark -------DownloadDelegate

- (void)didDownlaod:(detailModel *)models{
    [self.didloadArray addObject:models];
    [self.downlistArray removeObject:models];
    DownlaodTask *task = [DownlaodTask shareInstance];
    [task deleteModel:models];
    NSLog(@"-166--------------%lu", self.didloadArray.count);
    [self.tableView reloadData];

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
