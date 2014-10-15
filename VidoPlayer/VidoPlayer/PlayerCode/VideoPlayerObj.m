//
//  VideoPlayerObj.m
//  VidoPlayer
//
//  Created by helfy  on 14-9-1.
//  Copyright (c) 2014年 helfy . All rights reserved.
//

#import "VideoPlayerObj.h"

@implementation VideoPlayerModeObj
+(VideoPlayerModeObj *)modeObjFor:(NSString *)url videoUrlDes:(NSString *)des
{
    VideoPlayerModeObj *modeObj = [[VideoPlayerModeObj alloc] init];
    modeObj.videoUrl = url;
    modeObj.videoUrlDes =des;
    
    return modeObj;
}
@end;


@implementation VideoPlayerObj
@synthesize videoModes = _videoModes;
-(NSMutableArray *)videoModes
{
    if (_videoModes == nil) {
        _videoModes = [NSMutableArray array];
    }
    return _videoModes;
}
@end
