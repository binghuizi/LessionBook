//
//  ZYMusicTool.h
//  LessionBook
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 迪士尼工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class ZYMusic;
@class detailModel;
@interface ZYMusicTool : NSObject
@property(nonatomic,strong) NSArray *musics;
/**
 *  正在播放的歌曲
 *
 */
+ (detailModel *)playingMusic;

/**
 *  重新设置歌曲
 *
 */
+ (void)setPlayingMusic:(detailModel *)playingMusic;

/**
 *
 *
 *  @return 所有歌曲
 */
+ (NSArray *)musics :(NSArray *)array;
//-(NSMutableArray *)musics;
/**
 *
 *  下一首歌曲
 */
+ (detailModel *)nextMusic;

/**
 *  上一首歌曲
 *
 */
+ (detailModel *)previousMusic;
@end
