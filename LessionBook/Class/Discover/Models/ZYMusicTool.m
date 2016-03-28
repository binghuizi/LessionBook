//
//  ZYMusicTool.m
//  LessionBook
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import "ZYMusicTool.h"
static NSArray *_musics;
static detailModel *_playingMusic;
@implementation ZYMusicTool

//所有歌曲
+(NSArray *)musics:(NSArray *)array{
    if (_musics == nil) {
        _musics = array;
    }
    NSLog(@"%ld",_musics.count);
    return _musics;
}
+ (detailModel *)playingMusic
{
    return _playingMusic;
}

+ (void)setPlayingMusic:(detailModel *)playingMusic
{
    if (playingMusic == nil || ![_musics containsObject:playingMusic] || playingMusic == _playingMusic) {
        return;
    }
    _playingMusic = playingMusic;
}

+ (detailModel *)nextMusic
{
    int nextIndex = 0;
    if (_playingMusic) {
//        int playingIndex = (int)[[self musics] indexOfObject:_playingMusic];
      //  int playingIndex = (int)[[self mu] indexOfObject:_playingMusic];
        int playingIndex = (int)[_musics indexOfObject:_playingMusic];
        nextIndex = playingIndex + 1;
        NSLog(@"%ld",_musics.count);
        if (nextIndex >= _musics.count) {
            nextIndex = 0;
        }
    }
    return _musics[nextIndex];
}

+ (detailModel *)previousMusic
{
    int previousIndex = 0;
    if (_playingMusic) {
        int playingIndex = (int)[_musics indexOfObject:_playingMusic];
        previousIndex = playingIndex - 1;
        if (previousIndex < 0) {
            previousIndex = (int)_musics.count - 1;
        }
    }
    return _musics[previousIndex];
}





@end
