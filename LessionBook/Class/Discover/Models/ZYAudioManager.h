//
//  ZYAudioManager.h
//  LessionBook
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface ZYAudioManager : NSObject
+ (instancetype)defaultManager;

//播放音乐
- (AVAudioPlayer *)playingMusic:(NSString *)filename;
- (void)pauseMusic:(NSString *)filename;
- (void)stopMusic:(NSString *)filename;
@end
