//
//  VPVideoPlayerView.h
//  VidoPlayer
//
//  Created by helfy on 14-9-2.
//  Copyright (c) 2014年 helfy . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayerObj.h"
#import "CustomSliderView.h"
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
extern NSString * const kVideoPlayerVideoChangedNotification;
extern NSString * const kVideoPlayerWillHideControlsNotification;
extern NSString * const kVideoPlayerWillShowControlsNotification;
extern NSString * const kTrackEventVideoStart;
extern NSString * const kTrackEventVideoLiveStart;
extern NSString * const kTrackEventVideoComplete;


@protocol VPVideoPlayerViewDelegate <NSObject>

@optional

- (void)trackEvent:(NSString *)event videoObj:(VideoPlayerObj *)obj;  //状态改变
- (void)changeInterfaceOrientation;  //改变横竖屏
- (void)playerMenuHidden:(BOOL)hidde;  //播放器菜单隐藏/显示

- (void)changeToMode:(VideoPlayerModeObj *)mode; //改变播放模式

- (void)videoPlayStatusChanged;  //播放状态发生改变。。实现暂停添加广告代理

@end
@interface VPVideoPlayerView : UIView

@property (nonatomic, readonly, getter=isFullscreen) BOOL fullscreen;
-(void)setFullscreen:(BOOL)isFullscreen;

@property (nonatomic, assign) id<VPVideoPlayerViewDelegate> delegate;
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic,readonly,getter = isPlaying) BOOL isPlaying;
@property (nonatomic,readonly,getter = controllerBarHidden) BOOL controllerBarHidden;
@property (nonatomic) BOOL showStaticEndTime;  //静态剩余时间

- (void)playVideoWithObj:(VideoPlayerObj*)obj;


-(void)addAdView:(UIView *)adView;

@end
