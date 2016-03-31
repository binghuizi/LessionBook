//
//  PlayViewController.h
//  LessionBook
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
@protocol PlayViewControllerDelagate <NSObject>

-(void)getNum:(NSInteger)cunrrentNum;

@end
@interface PlayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

- (IBAction)playAction:(id)sender;

-(void)show;

@property (nonatomic, strong) detailModel *playingMusic;
@property (nonatomic, strong) detailModel *currentplayingMusic;
@property(nonatomic,assign) BOOL isPlay;
@property(nonatomic,strong) NSArray *arrayAll;
@property(nonatomic,assign) NSInteger num;

@property(nonatomic,assign) id<PlayViewControllerDelagate>delegate;
@end
