//
//  DownloadTableViewCell.m
//  LessionBook
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import <AFNetworking.h>


@interface DownloadTableViewCell ()<NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;

@property (strong, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;

//下载属性

@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger currentSize;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSFileHandle *handle;
@property (nonatomic, strong) NSString *fullPath;
@property (nonatomic, strong) NSURLConnection *connect;
@property (nonatomic, assign) BOOL download;
- (IBAction)downloadAction:(UIButton *)sender;

@end

@implementation DownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.downloadBtn.layer.cornerRadius = 30;
    self.downloadBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.downloadBtn.layer.borderWidth = 1;
    
}

#pragma mark ---------CustomMethod

- (void)downloadfile{
    NSLog(@"-------------");
    
    //1.确定url
    NSURL *url = [NSURL URLWithString:@"http://upod.qingting.fm/vod/00/00/0000000000000000000024202041_24.m4a"];
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    
    NSLog(@"%@", range);
    
    //3.发送异步请求
    self.connect = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark ---------NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"---Didresponse-");
    
    //判断是否已经下载过了
    if (self.currentSize > 0) {
        //已经下载过的话，就不需要再次接受response响应，就不需要再做后面的操作（比如创建句柄）
        return;
    }
    
    //0.获得文件的总大小
    //expectedContentLength是本次请求的数据的大小，并不是整个
    self.totalSize = response.expectedContentLength;
    
    //1.得到文件的名称
    self.fileName = response.suggestedFilename;
    //2.获得文件的全路径
    //caches
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [caches stringByAppendingPathComponent:self.fileName];
    self.fullPath = fullPath;
    NSLog(@"%@", fullPath);
    //3.创建一个空的文件
    /*
     第一个参数：路径
     第二个参数：表明这个文件存放的内容
     第三个参数：文件的属性
     第四个参数：
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSLog(@"----------------文件已存在");
        self.downloadProgress.hidden = YES;
        [self.connect cancel];
        return;
    }
    [[NSFileManager defaultManager] createFileAtPath:fullPath contents:nil attributes:nil];
    //4.创建一个文件句柄
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:fullPath];
    self.handle = handle;
}
//接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
     //1.把文件句柄移动到文件的末尾
    [self.handle seekToEndOfFile];
    
    //2.使用文件句柄写数据
    [self.handle writeData:data];
    
    //3.累加g当前下载的数据大小
    self.currentSize += data.length;
    
    //4.计算文件的下载进度
    double progress = (double)self.currentSize/self.totalSize;
    self.downloadProgress.progress = progress;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//1.把文件句柄关闭
    [self.handle closeFile];
    
    //2.清空指针
    self.handle = nil;
    
    //清空进度
    self.downloadProgress.progress = 0;
    self.currentSize = 0;
    self.totalSize = 0;
    self.downloadProgress.hidden = YES;
    [self.downloadBtn setTitle:@"完成" forState:UIControlStateNormal];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downloadAction:(UIButton *)sender {
    NSLog(@"%d", self.download);
    if (!self.download) {
        self.downloadProgress.hidden = NO;
        [self.downloadBtn setTitle:@"正在下载" forState:UIControlStateNormal];
        self.downloadBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        self.download = YES;
        [self downloadfile];
        
    }else{
        [self.downloadBtn setTitle:@"暂停" forState:UIControlStateNormal];
        self.downloadBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.connect cancel];
        self.download = NO;
    }
}
@end
