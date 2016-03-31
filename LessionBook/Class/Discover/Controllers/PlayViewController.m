//
//  PlayViewController.m
//  LessionBook
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "detailModel.h"
#import "ZYMusicTool.h"
#import "ZYAudioManager.h"
#import "AppDelegate.h"
@interface PlayViewController ()<MPMediaPickerControllerDelegate,AVAudioPlayerDelegate>{
    AppDelegate *myAppDelagate;
}
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) BOOL timeStart;
@property (nonatomic, assign) BOOL typePlay;

@property (nonatomic, strong) AVAudioPlayer *player;
/**
 *  判断歌曲播放过程中是否被电话等打断播放
 */
@property (nonatomic, assign) BOOL isInterruption;

@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;

@property (weak, nonatomic) IBOutlet UIImageView *imageVc;



@property (weak, nonatomic) IBOutlet UIButton *exitBtn;



- (IBAction)exit:(id)sender;




- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender;





- (IBAction)preClick:(id)sender;

- (IBAction)nextClick:(id)sender;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"消失");
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha = 0.3;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    
  
}
-(void)show{
      myAppDelagate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
     UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    self.view.bounds = windows.bounds;
    [windows addSubview:self.view];
    self.view.y = self.view.height;
    self.view.hidden = NO;
//    if (self.currentplayingMusic != [ZYMusicTool playingMusic]) {
//        [self resetPlayingMusic];
//    }
    if (myAppDelagate.currentplayingMusic != [ZYMusicTool playingMusic]) {
        [self resetPlayingMusic];
    }
    
     windows.userInteractionEnabled = NO;         //以免在动画过程中用户多次点击，或者造成其他事件的发生
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = 0;
    }completion:^(BOOL finished) {
        windows.userInteractionEnabled = YES;
        [self startPlayingMusic];
    }];
   

}

#pragma mark ----音乐控制
//重置播放的歌曲
- (void)resetPlayingMusic

{
    self.timeLabel.text = [self stringWithTime:0];
//    //停止播放音乐
//    [[ZYAudioManager defaultManager]stopMusic:self.currentplayingMusic.download];
//
    
    //停止播放音乐
    [[ZYAudioManager defaultManager]stopMusic:myAppDelagate.currentplayingMusic.download];
    
    [[ZYAudioManager defaultManager]stopMusic:myAppDelagate.detailModel.download];
    
    self.player = nil;
    [self removeCurrentTimer];

}
//开始播放音乐
- (void)startPlayingMusic
{
//    if (self.num == 0 &&  self.currentplayingMusic == [ZYMusicTool playingMusic])
    
     if (self.num == 0 &&  myAppDelagate.currentplayingMusic == [ZYMusicTool playingMusic]){
        // 开放播放音乐
     // self.playingMusic = self.arrayAll[self.num];
        self.playingMusic = myAppDelagate.arrayAll[self.num];
        self.player = [[ZYAudioManager defaultManager]playingMusic:self.playingMusic.download];
//        
//        
        self.player.delegate = self;
        [self addCurrentTimer];
//        
        self.playBtn.selected = YES;
    }else{
        if (myAppDelagate.currentplayingMusic == [ZYMusicTool playingMusic]) {
            [self addCurrentTimer];
           
            return;
        }
        // 开放播放音乐
        //self.playingMusic = self.arrayAll[self.num];
        self.playingMusic = myAppDelagate.arrayAll[self.num];
        self.player = [[ZYAudioManager defaultManager]playingMusic:self.playingMusic.download];
        
        
        self.player.delegate = self;
        [self addCurrentTimer];
        
        self.playBtn.selected = YES;

    }
    

}
#pragma mark ----进度条定时器处理
/**
 *  添加定时器
 */
- (void)addCurrentTimer
{
    if (![self.player isPlaying]) {
        return;
    }
    //新增定时器之前
    [self removeCurrentTimer];
    [self updateCurrentTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
//移除定时器
-(void)removeCurrentTimer{
    [self.timer invalidate];
    self.timer = nil;
    
}
/**
 *  触发定时器
 */
- (void)updateCurrentTimer
{
    double temp = self.player.currentTime / self.player.duration;
    self.playProgress.progress = temp;
    self.timeLabel.text =  [self stringWithTime:self.player.currentTime];
    self.bookNameLabel.text = self.playingMusic.name;
    [self.playBtn setImage:[UIImage imageNamed:@"play_button_pause"]forState:UIControlStateNormal];
}


#pragma mark ----私有方法
/**
 *  将时间转化为合适的字符串
 *
 */
- (NSString *)stringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute, second];
}



//点击播放
- (IBAction)playAction:(id)sender {
    
    if (self.playBtn.isSelected == NO) {
         [sender setImage:[UIImage imageNamed:@"play_button_pause"]forState:UIControlStateNormal];
        self.playBtn.selected =  YES;
[[ZYAudioManager defaultManager]playingMusic:self.playingMusic.download];
        
        [self addCurrentTimer];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"play_button_play"]forState:UIControlStateNormal];
        self.playBtn.selected = NO;
        [[ZYAudioManager defaultManager]pauseMusic:self.playingMusic.download];
       
        [self removeCurrentTimer];
        
    }
    
}



#pragma mark -----离开页面
- (IBAction)exit:(id)sender {
    
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    windows.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = self.view.height;
    }completion:^(BOOL finished) {
        self.view.hidden = YES;            //view看不到了，将之隐藏掉，可以减少性能的消耗
        [self removeCurrentTimer];
       
        windows.userInteractionEnabled = YES;
    }];
    
    
    myAppDelagate.num = self.num;

}
/**
 *  轻击progressView，使得滑块走到对应位置
 *
 */
- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    
    self.player.currentTime = (point.x / sender.view.width) * self.player.duration;
    
    [self updateCurrentTimer];
 
    
}
#pragma mark ------上一集
- (IBAction)preClick:(id)sender {
    UIWindow *windo = [UIApplication sharedApplication].keyWindow;
    windo.userInteractionEnabled = NO;
    [[ZYAudioManager defaultManager]stopMusic:self.playingMusic.download];
    [ZYMusicTool setPlayingMusic:[ZYMusicTool previousMusic]];
    self.num -= 1;
    if (self.num < 0) {
        self.num = 0;
    }
    
    [self removeCurrentTimer];
    [self startPlayingMusic];
    
    
    windo.userInteractionEnabled = YES;
    [self.delegate getNum:self.num];

}

- (IBAction)nextClick:(id)sender {
    
    UIWindow *windo = [UIApplication sharedApplication].keyWindow;
    windo.userInteractionEnabled = NO;
    [[ZYAudioManager defaultManager]stopMusic:self.playingMusic.download];
   // [ZYMusicTool setPlayingMusic:[ZYMusicTool nextMusic]];
    self.num += 1;
    
//    if (self.num > self.arrayAll.count - 1) {
//        self.num = 0;
//    }
    if (self.num > myAppDelagate.arrayAll.count - 1) {
        self.num = 0;
    }
     [self removeCurrentTimer];
     [self startPlayingMusic];
   
    windo.userInteractionEnabled = YES;
   // myAppDelagate.num = self.num;
    //[self.delegate getNum:self.num ];
}
#pragma mark ----AVAudioPlayerDelegate
#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

//    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    NSLog(@"%ld",self.num);
    NSLog(@"%ld",myAppDelagate.arrayAll.count - 1);
//    if (self.num  == myAppDelagate.arrayAll.count - 1) {
//        [self.playBtn setImage:[UIImage imageNamed:@"play_button_play"]forState:UIControlStateNormal];
//        [[AVAudioSession sharedInstance]setActive:NO error:nil];
//        
//    }else{
       [self nextClick:nil];
//}
    
    
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if ([self.player isPlaying]) {
        [self playAction:nil];
        self.isInterruption = YES;
    }
}
/**
 *  打断结束，做相应的操作
 *
 */
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    if (self.isInterruption) {
        self.isInterruption = NO;
        [self playAction:nil];
    }
}



#pragma mark - 远程控制事件监听
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            [self playAction:nil];
            break;
            
            case UIEventSubtypeRemoteControlNextTrack:
            [self nextClick:nil];
            break;
            case UIEventSubtypeRemoteControlPreviousTrack:
            [self preClick:nil];
            
            
        default:
            break;
    }
}


@end
