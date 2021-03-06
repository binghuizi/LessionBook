//
//  ZYAudioManager.m
//  LessionBook
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "ZYAudioManager.h"
#import "ZYMusicTool.h"
#import "detailModel.h"
#import "AppDelegate.h"
@interface ZYAudioManager ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) NSMutableDictionary *musicPlayers;
@property (nonatomic, strong) NSMutableDictionary *soundIDs;
@end

static ZYAudioManager *_instance = nil;
static detailModel *_prePlayMusic;
@implementation ZYAudioManager
+ (void)initialize
{
    // 音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // 设置会话类型（播放类型、播放模式,会自动停止其他音乐的播放）
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 激活会话
    [session setActive:YES error:nil];
}

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    __block ZYAudioManager *temp = self;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((temp = [super init]) != nil) {
            _musicPlayers = [NSMutableDictionary dictionary];
            _soundIDs = [NSMutableDictionary dictionary];
        }
    });
    self = temp;
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

//播放音乐
- (AVAudioPlayer *)playingMusic:(NSString *)filename
{
   // if (filename == nil || filename.length == 0) return nil;
    AVAudioPlayer *player = self.musicPlayers[filename];      //先查询对象是否缓存了
 
   BOOL file = [[NSFileManager defaultManager]fileExistsAtPath:filename];
     NSError *error = nil;
   
    
    if (!player) {
        
        if (file) {
            NSURL *url = [NSURL fileURLWithPath:filename];
            
            player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        }else{
            NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kMusic,filename]];
            NSData *date = [NSData dataWithContentsOfURL:urlString];
            NSLog(@"%@",urlString);
            //NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
            
            //if (!url)  return nil;
            //        NSError *error = nil;
            player = [[AVAudioPlayer alloc] initWithData:date error:&error];
        }
        if (![player prepareToPlay]) return nil;
        
        //后台播放音频设置
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        self.musicPlayers[filename] = player;            //对象是最新创建的，那么对它进行一次缓存
    }
    player.delegate = _instance;
    
    if (![player isPlaying]) {                 //如果没有正在播放，那么开始播放，如果正在播放，那么不需要改变什么
        [player play];
    }
    return player;
}
-(detailModel *)prePlayMusic{
  return   _prePlayMusic;
}
//代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
   
    [ZYMusicTool setPlayingMusic:[ZYMusicTool nextMusic]];//下一曲数据
    detailModel *model = [ZYMusicTool nextMusic];
    
    _prePlayMusic = [ZYMusicTool nextMusic];//记录在播放的歌曲
    
    [[ZYAudioManager defaultManager]playingMusic:model.download];//播放下一曲
    
}

- (void)pauseMusic:(NSString *)filename
{
   // if (filename == nil || filename.length == 0)  return;
    
    AVAudioPlayer *player = self.musicPlayers[filename];
    
    if ([player isPlaying]) {
        [player pause];
    }
}

- (void)stopMusic:(NSString *)filename
{
    if (filename == nil || filename.length == 0)  return;
    
    AVAudioPlayer *player = self.musicPlayers[filename];
    
    [player stop];
    
    [self.musicPlayers removeObjectForKey:filename];
}





@end
