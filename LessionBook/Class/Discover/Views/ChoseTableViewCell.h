//
//  ChoseTableViewCell.h
//  LessionBook
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseModel.h"

@protocol imageviewDelegate <NSObject>

- (void)showImage:(NSString *)imageUrl
           anchor:(NSString *)anchor
           author:(NSString *)author
         describe:(NSString *)describe
        titleName:(NSString *)titleName
        idString:(NSString *)idString;
-(void)typeIdString:(NSString *)typeId;

@end

@interface ChoseTableViewCell : UITableViewCell
@property (nonatomic, assign) id<imageviewDelegate>delgate;
@property (weak, nonatomic) IBOutlet UIButton *manyBtn;
@property (weak, nonatomic) IBOutlet UIButton *onebtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property(nonatomic,strong) NSString *picthString;

@property (weak, nonatomic) IBOutlet UIImageView *twoImage;
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;
@property (weak, nonatomic) IBOutlet UIImageView *threeImage;

@property (nonatomic,strong) ChoseModel *model;
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) NSMutableArray *zhuboArray;
@property(nonatomic,strong) NSMutableArray *zuozheArray;
@property(nonatomic,strong) NSMutableArray *miaosuArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *idArray;
@property(nonatomic,strong) NSMutableArray *typeIdArray;
@end
