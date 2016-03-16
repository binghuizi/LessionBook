//
//  DiscoverViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DiscoverViewController.h"
#import "VOSegmentedControl.h"
@interface DiscoverViewController ()
@property(nonatomic,retain) VOSegmentedControl *segment1;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.segment1];
}
//懒加载
-(VOSegmentedControl *)segment1{
    if (_segment1 == nil) {
        
                self.segment1 = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"分类"},
                                                                      @{VOSegmentText:@"精选"}]];
        self.segment1.textColor = [UIColor blackColor];
        self.segment1.selectedTextColor = [UIColor orangeColor];
        self.segment1.contentStyle = VOContentStyleTextAlone;
        self.segment1.indicatorStyle = VOSegCtrlIndicatorStyleTopLine;
        
        self.segment1.allowNoSelection = NO;
        self.segment1.frame = CGRectMake(0,60,kWideth, 44);

        
    }
    return _segment1;
}

















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
