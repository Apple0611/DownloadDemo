//
//  VideoPlayerObj.h
//  VidoPlayer
//
//  Created by helfy  on 14-9-1.
//  Copyright (c) 2014年 helfy . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoPlayerModeObj : NSObject
@property (nonatomic,strong )NSString *videoUrl;    //视频链接
@property (nonatomic,strong )NSString *videoUrlDes;  //mode描述   高清／标准／流畅。。。。

+(VideoPlayerModeObj *)modeObjFor:(NSString *)Url videoUrlDes:(NSString *)des;
@end



@interface VideoPlayerObj : NSObject
@property (nonatomic,strong )NSString *title;  //标题
@property (nonatomic,strong )NSString *idStr;  //id
@property (nonatomic,strong )NSMutableArray *videoModes;  //模式
@property (nonatomic,assign) int defauleIndex; //默认播放
@property (nonatomic,assign) BOOL isStreaming;
@end
