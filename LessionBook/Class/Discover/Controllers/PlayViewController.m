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

@interface PlayViewController ()<MPMediaPickerControllerDelegate,AVAudioPlayerDelegate>
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


- (IBAction)preClick:(id)sender;

- (IBAction)nextClick:(id)sender;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.alpha = 0.3;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
   
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.typePlay = 1;
    
    
   // [self show];
}
-(void)show{
     UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    if (self.playingMusic != [ZYMusicTool playingMusic]) {
        [self resetPlayingMusic];
    }
    
     windows.userInteractionEnabled = NO;         //以免在动画过程中用户多次点击，或者造成其他事件的发生
    
    windows.userInteractionEnabled = YES;
    [self startPlayingMusic];

}

#pragma mark ----音乐控制
//重置播放的歌曲
- (void)resetPlayingMusic
{
    //停止播放音乐
    [[ZYAudioManager defaultManager]stopMusic:self.playingMusic.download];
    //停止播放音乐
    //[[ZYAudioManager defaultManager]stopMusic:self.urlString];
    self.player = nil;
    [self removeCurrentTimer];

}
//开始播放音乐
- (void)startPlayingMusic
{
    if (self.playingMusic == [ZYMusicTool playingMusic]) {
        [self addCurrentTimer];
      
        return;
    }
   // 开放播放音乐
    self.player = [[ZYAudioManager defaultManager]playingMusic:self.playingMusic.download];
  //  self.player = [[ZYAudioManager defaultManager]playingMusic:self.urlString];
    NSLog(@"%@",self.playingMusic.download);
    self.player.delegate = self;
    [self addCurrentTimer];
    
    self.playBtn.selected = YES;
    [self.playBtn setImage:[UIImage imageNamed:@"play_button_pause"]forState:UIControlStateNormal];
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",self.timeInt/60,self.timeInt%60];;
    
    //切换锁屏
    [self updateLockedScreenMusic];

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
    
    self.timeInt -=1;
    if (self.timeInt != 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",self.timeInt/60,self.timeInt%60];
    }else{
        
    }
    
    
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
   //     [[ZYAudioManager defaultManager]playingMusic:self.urlString];
        [self addCurrentTimer];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"play_button_play"]forState:UIControlStateNormal];
        self.playBtn.selected = NO;
        [[ZYAudioManager defaultManager]pauseMusic:self.playingMusic.download];
       // [[ZYAudioManager defaultManager]playingMusic:self.urlString];
        [self removeCurrentTimer];
        
    }
    
    
   
}



/**
 *  更新播放进度
 */
//-(void)updateProgress{
//    float progress= (double)self.audioPlayer.currentTime /self.audioPlayer.duration;
//    
//    [self.playProgress setProgress:progress animated:true];
//    
//    self.timeInt -=1;
//    if (self.timeInt != 0) {
//        self.timeLabel.text = [NSString stringWithFormat:@"%02ld: %02ld",(NSInteger)self.timeInt/60,(NSInteger)self.timeInt%60];
//    }else{
//        [self.timer invalidate];
//    }
//}

/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
//-(void)routeChange:(NSNotification *)notification{
//    NSDictionary *dic=notification.userInfo;
//    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
//    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
//    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
//        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
//        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
//        //原设备为耳机则暂停
//        if ([portDescription.portType isEqualToString:@"Headphones"]) {
//            [self pause];
//        }
//    }
//}



//前一首
- (IBAction)preClick:(id)sender {
    UIWindow *windo = [UIApplication sharedApplication].keyWindow;
    windo.userInteractionEnabled = NO;
    [[ZYAudioManager defaultManager]stopMusic:self.playingMusic.download];
    [ZYMusicTool setPlayingMusic:[ZYMusicTool previousMusic]];
    [self removeCurrentTimer];
    [self startPlayingMusic];
    windo.userInteractionEnabled = YES;
    
    
    
    
    
}

- (IBAction)nextClick:(id)sender {
    
    UIWindow *windo = [UIApplication sharedApplication].keyWindow;
    windo.userInteractionEnabled = NO;
    [[ZYAudioManager defaultManager]stopMusic:self.playingMusic.download];
    [ZYMusicTool setPlayingMusic:[ZYMusicTool nextMusic]];
    [self removeCurrentTimer];
    windo.userInteractionEnabled = YES;
}
#pragma mark ----AVAudioPlayerDelegate
#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    NSLog(@"音乐播放完成...");
//    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
//    [[AVAudioSession sharedInstance]setActive:NO error:nil];
//    [self.playBtn setImage:[UIImage imageNamed:@"play_button_play"]forState:UIControlStateNormal];
    [self nextClick:nil];
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

#pragma mark ----锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic
{ //播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    //初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MPMediaItemPropertyAlbumTitle] = self.bookNameLabel.text;
    
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
