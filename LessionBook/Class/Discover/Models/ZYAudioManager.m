//
//  ZYAudioManager.m
//  LessionBook
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "ZYAudioManager.h"

@interface ZYAudioManager ()
@property (nonatomic, strong) NSMutableDictionary *musicPlayers;
@property (nonatomic, strong) NSMutableDictionary *soundIDs;
@end

static ZYAudioManager *_instance = nil;
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
    
    if (!player) {
        NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kMusic,filename]];
        NSData *date = [NSData dataWithContentsOfURL:urlString];
        NSLog(@"%@",urlString);
        //NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        //if (!url)  return nil;
        NSError *error = nil;
        player = [[AVAudioPlayer alloc] initWithData:date error:&error];
        
        if (![player prepareToPlay]) return nil;
        
        self.musicPlayers[filename] = player;            //对象是最新创建的，那么对它进行一次缓存
    }
    
    if (![player isPlaying]) {                 //如果没有正在播放，那么开始播放，如果正在播放，那么不需要改变什么
        [player play];
    }
    return player;
}

- (void)pauseMusic:(NSString *)filename
{
    if (filename == nil || filename.length == 0)  return;
    
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
