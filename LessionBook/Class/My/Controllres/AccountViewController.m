//
//  AccountViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "AccountViewController.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import "BmobPay/BmobPay.h"
#import <BmobSDK/BmobFile.h>
#import <UIImageView+WebCache.h>
#import <EaseMob.h>
#import "AppDelegate.h"

@interface AccountViewController ()<UITableViewDataSource, UITableViewDelegate, BmobPayDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    AppDelegate *myAppDelegate;
    BmobPay *bPay;
}
@property (nonatomic, strong)UITableView *tableView;
//图片选择视图控制器
@property(nonatomic, strong) UIImagePickerController *pickController;

@property(nonatomic, strong) UIImageView *userImageView;

@property(nonatomic, strong) NSString *city;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号设置";
    [self.view addSubview:self.tableView];
    
    //初始化支付对象
    bPay = [[BmobPay alloc] init];
    bPay.delegate = self;
    //头视图
    [self configheaderView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        NSString *url = [user objectForKey:@"imageUrl"];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"a040144d464bf201a150a57abf8f8292"]];
    }else{
    [self.userImageView setImage:[UIImage imageNamed:@"a040144d464bf201a150a57abf8f8292"]];
    }
}

#pragma mark ------------CustomMethod

//添加头视图
- (void)configheaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:201 / 255.0 blue:1 alpha:1.0];
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 80)/ 2, 10, 80, 80)];
    self.userImageView.image = [UIImage imageNamed:@"a040144d464bf201a150a57abf8f8292"];
    self.userImageView.layer.cornerRadius = 40;
    self.userImageView.clipsToBounds = YES;
    UIButton *selectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectImageBtn.frame = CGRectMake((kScreenWidth - 80)/ 2, 10, 80, 80);
    selectImageBtn.backgroundColor = [UIColor clearColor];
    selectImageBtn.layer.cornerRadius = 40;
    selectImageBtn.clipsToBounds = YES;
    [selectImageBtn addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.userImageView];
    [headerView addSubview:selectImageBtn];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}


- (void)selectImage{
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        [self pickImage];
    }
}

- (void)pickImage{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选取", nil];
    [sheet showInView:self.view];
}

//UIActionSheet必须实现的方法

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //调用系统相机
            [self pickerPictureFromCamera];
            break;
        case 1:
            //从图库中选择
            [self pickerPictureFromAlumb];
            break;
        default:
            break;
    }
}

//调用系统相机方法
- (void)pickerPictureFromCamera{
    //判断摄像头是否可用
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        self.pickController = [[UIImagePickerController alloc] init];
        self.pickController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
        self.pickController = [[UIImagePickerController alloc] init];
        self.pickController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else{
        //两者都不能用，从相册获取
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"摄像头调用失败" message:@"从图库选取" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    //初始化图片控制对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//从手机图库获取图片的方法
- (void)pickerPictureFromAlumb{
    //初始化图片控制对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.userImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSData *imageData = UIImagePNGRepresentation(self.userImageView.image);
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imagePath = [documentPath stringByAppendingString:@"/image.da"];
    //写入
    [imageData writeToFile:imagePath atomically:YES];
    BmobUser *user = [BmobUser getCurrentUser];
    BmobFile *file1 = [[BmobFile alloc] initWithFilePath:imagePath];
    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
        //如果文件保存成功，则把文件添加到filetype列
        if (isSuccessful) {
            [user setObject:file1  forKey:@"filetype"];
            [user setObject:file1.url forKey:@"imageUrl"];
            [user updateInBackground];
            //打印file文件的url地址
        }else{
            //进行处理
        }
    }];
}

#pragma mark ------------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    switch (indexPath.row) {
        case 0:
        {
            BmobUser *user = [BmobUser getCurrentUser];
            if (user != nil) {
            cell.textLabel.text = [NSString stringWithFormat:@"用户名：%@", user.username];
            }else{
            cell.textLabel.text = @"用户名";
            }
        }
            break;
        case 1:
        {
           cell.textLabel.text = @"开通会员";
        }
            break;
        case 2:
        {
            BmobUser *user = [BmobUser getCurrentUser];
            if (user) {
                NSString *city = [user objectForKey:@"city"];
                if ([city isEqualToString:@""]) {
                    cell.textLabel.text = @"地区";
                }else{
                    cell.textLabel.text = city;
                }
            }else{
            cell.textLabel.text = @"地区";
            }
        }
            break;
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

#pragma mark ------------UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            //支付变成VIP
            [self payBecomeVIP];
        }
            break;
        case 2:
        {
            [self setCity];
        }
            break;
        case 3:
        {
            BmobUser *currntUser = [BmobUser getCurrentUser];
            if (currntUser != nil) {
                [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                    if (!error) {
                        [BmobUser logout];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前用户已退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                        myAppDelegate.isLogin = 0;
                        [alert show];
                        [self.userImageView setImage:[UIImage imageNamed:@"a040144d464bf201a150a57abf8f8292"]];
                        [self.tableView reloadData];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                        [alert show];
                    }
                } onQueue:nil];
            }
        }
            break;
    }
}

- (void)setCity{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"地区城市" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        BmobUser *user = [BmobUser getCurrentUser];
        NSLog(@"%@", textField.text);
        [user setObject:textField.text forKey:@"city"];
        [user updateInBackground];
        [self.tableView reloadData];
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark ----------Lazylaoding

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark --------支付

- (void)payBecomeVIP{
    [self payMoney];
}

//支付
- (void)payMoney{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"开通VIP" message:@"获得会员资格之后可以下载小说，离线听书\n注：收款方为迪士尼工作室，付款后系统会自动为您升级为VIP！如有问题，请联系86+15981915364" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [bPay setPrice:[NSNumber numberWithFloat:0.1]];
        [bPay setProductName:@"马里亚纳听书永久会员"];
        [bPay setBody:@"获得会员资格之后可以下载小说，离线听书"];
        [bPay setAppScheme:@"Mariana"];
        [bPay payInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //输出订单号以让用户了解订单号
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单号" message:bPay.tradeNo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                NSLog(@"支付失败");
            }
        }];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action];
    [alertC addAction:action1];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}

- (void)changeVIP{
    BmobUser *user = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobUser query];
    [bquery getObjectInBackgroundWithId:user.objectId block:^(BmobObject *object, NSError *error) {
        [object setObject:@"true" forKey:@"VIP"];
        [object updateInBackground];
    }];
}

- (void)paySuccess{
    //支付成功修改用户权限为VIP
    [self changeVIP];
}

//支付失败
-(void)payFailWithErrorCode:(int) errorCode{
    NSLog(@"test");
    switch(errorCode){
            /*
             * 4000 订单支付失败
             * 6001 用户中途取消
             * 6002 网络连接出错
             */
        case 6001:{
            NSLog(@"用户中途取消");
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"用户中途取消" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
            
        case 6002:{
            NSLog(@"网络连接出错");
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"网络连接出错" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
            
        case 4000:{
            NSLog(@"订单支付失败");
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"订单支付失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
    }
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
