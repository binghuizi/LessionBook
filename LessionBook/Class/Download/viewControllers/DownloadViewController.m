//
//  DownloadViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DownloadViewController.h"
#import "VOSegmentedControl.h"


@interface DownloadViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) VOSegmentedControl *segmentControl;
@property (nonatomic, strong) UITableView *tableView;


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
    
}

#pragma mark ----------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}

#pragma mark ----------UITableViewDelegate;



#pragma mark ----------Lazyloding

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kWideth, kHeight - 108) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 50;
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

#pragma mark ----------CustomMethod

- (void)segmentCtrlValueChange:(VOSegmentedControl *)segmentctrl{

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
