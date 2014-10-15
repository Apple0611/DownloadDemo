//
//  VPVideoPlayerView.m
//  VidoPlayer
//
//  Created by helfy on 14-9-2.
//  Copyright (c) 2014年 helfy . All rights reserved.
//

#import "VPVideoPlayerView.h"

NSString * const kVideoPlayerVideoChangedNotification = @"VideoPlayerVideoChangedNotification";
NSString * const kVideoPlayerWillHideControlsNotification = @"VideoPlayerWillHideControlsNotitication";
NSString * const kVideoPlayerWillShowControlsNotification = @"VideoPlayerWillShowControlsNotification";
NSString * const kTrackEventVideoStart = @"Video Start";
NSString * const kTrackEventVideoLiveStart = @"Video Live Start";
NSString * const kTrackEventVideoComplete = @"Video Complete";
#define PLAYER_CONTROL_BAR_HEIGHT 38
#define BUTTON_PADDING 21
#define CURRENT_POSITION_WIDTH 56
#define TIME_LEFT_WIDTH 59
#define ALIGNMENT_FUZZ 2
#define ROUTE_BUTTON_ALIGNMENT_FUZZ 8
#define PADDING 5
@implementation VPVideoPlayerView
{


    UILabel *titleLabel;
    UIView *playerControlBar;
    UIButton *fullScreenButton;
    UIButton *playPauseButton;
    CustomSliderView *videoScrubber;
    UILabel *currentPositionLabel;
    UILabel *timeLeftLabel;
    UIProgressView *progressView;
    UIActivityIndicatorView *activityIndicator;
    
    UIButton *HDButton;
    UIButton *normalButton;
    UIButton *lowButton;
    UIView *topBar;
    
    VideoPlayerObj *playerObj;
    
    
    
    float tempSeek;
    
    BOOL seekToZeroBeforePlay;
    BOOL playerIsBuffering;
    BOOL playWhenReady;
    BOOL scrubBuffering;
    
    BOOL sliderPush;
    
    id scrubberTimeObserver;
    id playClockTimeObserver;
    
    
    CGPoint prePoint;
    int changeVType;// 0，none ;1，声音  2：进度
    
    
    NSMutableArray *modeButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self loadMenuView];
    }
    return self;
}

-(void)removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self removeObserversFromVideoPlayerItem];
    [self removePlayerTimeObservers];

    //    self.currentVideoInfo =nil;
    scrubberTimeObserver =nil;
    playClockTimeObserver =nil;

    
    if( self.videoPlayer)
    {
        [self.videoPlayer pause];
        self.videoPlayer = nil;
    }
    self.delegate = nil;

    [super removeFromSuperview];
    
}

-(void)loadMenuView
{
    playerControlBar = [[UIView alloc] init];
    [playerControlBar setOpaque:NO];
    [playerControlBar setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    playerControlBar.layer.shadowOpacity =1;
    playerControlBar.layer.shadowColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3].CGColor;
    
    
    topBar = [[UIView alloc] init];
    [topBar setOpaque:NO];
    [topBar setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    [self addSubview:topBar];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setNumberOfLines:1];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    [topBar addSubview:titleLabel];
    
    
    playPauseButton = [[UIButton alloc] init];
    [playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [playPauseButton setShowsTouchWhenHighlighted:YES];
    [playerControlBar addSubview:playPauseButton];
    
    fullScreenButton = [[UIButton alloc] init];
    [fullScreenButton setImage:[UIImage imageNamed:@"zoomin.png"] forState:UIControlStateNormal];
    [fullScreenButton setShowsTouchWhenHighlighted:YES];
    [playerControlBar addSubview:fullScreenButton];
    
    videoScrubber = [[CustomSliderView alloc] init];
    [playerControlBar addSubview:videoScrubber];
    
    currentPositionLabel = [[UILabel alloc] init];
    [currentPositionLabel setBackgroundColor:[UIColor clearColor]];
    [currentPositionLabel setTextColor:[UIColor whiteColor]];
    [currentPositionLabel setFont:[UIFont systemFontOfSize:12]];
    [currentPositionLabel setTextAlignment:NSTextAlignmentCenter];
    [playerControlBar addSubview:currentPositionLabel];
    
    timeLeftLabel = [[UILabel alloc] init];
    [timeLeftLabel setBackgroundColor:[UIColor clearColor]];
    [timeLeftLabel setTextColor:[UIColor whiteColor]];
    [timeLeftLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLeftLabel setTextAlignment:NSTextAlignmentCenter];
    [playerControlBar addSubview:timeLeftLabel];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:activityIndicator];
    
    
    
    [playPauseButton addTarget:self action:@selector(playPauseHandler) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    [fullScreenButton addTarget:self action:@selector(fullScreenButtonHandler) forControlEvents:UIControlEventTouchUpInside];

    
    [videoScrubber addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
    [videoScrubber addTarget:self action:@selector(scrubberIsScrolling) forControlEvents:UIControlEventValueChanged];
    [videoScrubber addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:( UIControlEventTouchCancel)];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [pinchRecognizer setDelegate:(id)self];
    [self addGestureRecognizer:pinchRecognizer];

    
    UITapGestureRecognizer *doulbeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseHandler)];
    [doulbeTap setDelegate:(id)self];
    doulbeTap.numberOfTapsRequired=2;
    
    UITapGestureRecognizer *playerTouchedGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTapHandler)];
    playerTouchedGesture.delegate = (id) self;
    [playerTouchedGesture requireGestureRecognizerToFail:doulbeTap];
    [self addGestureRecognizer:playerTouchedGesture];

    [self addGestureRecognizer:doulbeTap];

    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeVolume:)];
    [self addGestureRecognizer:pan];
  
    
}
-(void)changeVolume:(UIPanGestureRecognizer *)pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        prePoint = [pan locationInView:pan.view];
        changeVType = 0;
    }
    
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint curPoint = [pan locationInView:pan.view];
        
        switch (changeVType) {
            case 0:
            {
                if(ABS(curPoint.y - prePoint.y)>10 && ABS(curPoint.y - prePoint.y)> ABS(curPoint.x - prePoint.x))
                {
                    changeVType = 1;
                }
                else if(ABS(curPoint.x - prePoint.x)>10 && ABS(curPoint.x - prePoint.x)> ABS(curPoint.y - prePoint.y))
                {
                    changeVType = 2;
                    [self scrubbingDidBegin];
                    
                }
                return;
            }
                break;
            case 1:
            {
                MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
                mpc.volume =  mpc.volume + (prePoint.y -curPoint.y)/100;
            }
                break;
            case 2:
            {// TODO
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlsAnimated:) object:@YES];
                CMTime playerDuration = [self playerItemDuration];
                double duration = CMTimeGetSeconds(playerDuration);
                if (isfinite(duration)) {
                    
                    videoScrubber.value = videoScrubber.value+(curPoint.x -prePoint.x)/300;
                
                    double currentTime = floor(duration * videoScrubber.value);
                    double timeLeft = floor(duration - currentTime);
                    
                    if (currentTime <= 0) {
                        currentTime = 0;
                        timeLeft = floor(duration);
                    }
                    
                    [currentPositionLabel setText:[NSString stringWithFormat:@"%@ ", [self stringFormattedTimeFromSeconds:&currentTime]]];
                    
                    if (!self.showStaticEndTime) {
                        [timeLeftLabel setText:[NSString stringWithFormat:@"-%@", [self stringFormattedTimeFromSeconds:&timeLeft]]];
                    } else {
                        [timeLeftLabel setText:[NSString stringWithFormat:@"%@", [self stringFormattedTimeFromSeconds:&duration]]];
                    }
               
                }
            }
                break;
                
            default:
                break;
        }
        prePoint = curPoint;
        
    } else if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
        [self scrubbingDidEnd];
    }
    
}
- (void)playVideoWithObj:(VideoPlayerObj*)obj
{
    if(playerObj == obj)return;
    playerObj = obj;

    //add ModeButtons
    if(modeButtons)
    {
        [modeButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [modeButtons removeAllObjects];
    }
   
    modeButtons = [NSMutableArray array];
    if(playerObj.videoModes.count >1)
    {
    for (int index =0;index <obj.videoModes.count;index++) {
        VideoPlayerModeObj *modeObj = [playerObj.videoModes objectAtIndex:index];
        UIButton *modeButton = [[UIButton alloc] init];
        modeButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [modeButton setTitle:modeObj.videoUrlDes forState:UIControlStateNormal];
        [modeButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [modeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        modeButton.layer.cornerRadius =5;
        modeButton.layer.borderColor = [UIColor grayColor].CGColor;
        modeButton.layer.borderWidth = 1;
        [modeButton addTarget:self action:@selector(videoChangeMode:) forControlEvents:UIControlEventTouchUpInside];
        modeButton.tag =index;
        [topBar addSubview:modeButton];
        [modeButtons addObject:modeButton];
        
        
        if(index == playerObj.defauleIndex)
        {
            modeButton.enabled = NO;
            modeButton.layer.borderWidth = 1;
        }
        else {
            modeButton.enabled = YES;
            modeButton.layer.borderWidth = 0;
        }
    }
    }
    
    [self.videoPlayer pause];
    [activityIndicator startAnimating];
    // Reset the buffer bar back to 0
    [self.videoPlayer seekToTime:kCMTimeZero];
    [videoScrubber setProgress:0 animated:NO];
    [self showControls];
    
   
   
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kVideoPlayerVideoChangedNotification
                                                        object:self
                                                      userInfo:nil];
    
    if ([self.delegate respondsToSelector:@selector(trackEvent:videoObj:)]) {
        if (obj.isStreaming) {
            [self.delegate trackEvent:kTrackEventVideoLiveStart videoObj:obj];
        } else {
            [self.delegate trackEvent:kTrackEventVideoStart videoObj:obj];
           
        }
    }
    
    [currentPositionLabel setText:@""];
    [timeLeftLabel setText:@""];
    videoScrubber.value = 0;
    
    [titleLabel setText:obj.title];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{
                                                                MPMediaItemPropertyTitle: obj.title
                                                                }];
    VideoPlayerModeObj *modePlayer =[playerObj.videoModes objectAtIndex:obj.defauleIndex];
    
    
    NSURL *url = nil;
        if (obj.isStreaming) {
            url =[NSURL URLWithString:[modePlayer.videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else{
            url= [NSURL fileURLWithPath:modePlayer.videoUrl];
        }
    
    
    [self setURL:url];
    [self syncPlayPauseButtons];
    [self playVideo];
}

- (void)setURL:(NSURL *)url
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    if(playerObj.isStreaming == NO)
    {
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    }
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [playerItem addObserver:self
                 forKeyPath:@"playbackBufferEmpty"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [playerItem addObserver:self
                 forKeyPath:@"playbackLikelyToKeepUp"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [playerItem addObserver:self
                 forKeyPath:@"loadedTimeRanges"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    if (!self.videoPlayer) {
        
      
        self.videoPlayer = [[AVQueuePlayer alloc ]initWithItems:[NSArray arrayWithObject:playerItem]];
     
      
        
        if ([self.videoPlayer respondsToSelector:@selector(setAllowsExternalPlayback:)]) { // iOS 6 API
            [self.videoPlayer setAllowsExternalPlayback:YES];
        }
        [self setPlayer:self.videoPlayer];

        
    } else {
        [self removeObserversFromVideoPlayerItem];
        [self.videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
    }
    


    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.videoPlayer.currentItem];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];
    
    CGRect insetBounds = CGRectInset(bounds, PADDING, PADDING);
   
//    CGSize titleLabelSize = [[titleLabel text] sizeWithFont:[titleLabel font]
//                                           constrainedToSize:CGSizeMake(insetBounds.size.width, CGFLOAT_MAX)
//                                               lineBreakMode:NSLineBreakByCharWrapping];
    
    //    UIImage *shareImage = [UIImage imageNamed:@"share-button"];
 
    
        
        self.autoresizingMask = UIViewAutoresizingNone;
        

        
        if(bounds.size.width >[[UIScreen mainScreen] bounds].size.width)
        {
            titleLabel.hidden = NO;
            [topBar setFrame:CGRectMake(0,
                                         0,
                                         bounds.size.width,
                                         30+20)];
            float maxWidth =  modeButtons.count * 60;
            [titleLabel setFrame:CGRectMake(insetBounds.origin.x ,
                                            20,
                                            insetBounds.size.width-maxWidth,
                                            30)];
            for (UIButton *button in modeButtons) {
                [button setFrame:CGRectMake(insetBounds.size.width - maxWidth, 3+20,35, 25)];
                maxWidth= maxWidth-60;
            }
            
 

        }
        else{
            [topBar setFrame:CGRectMake(0,
                                         0,
                                         bounds.size.width,
                                         30)];
            titleLabel.hidden = modeButtons.count>0?YES:NO;

            float maxWidth =  modeButtons.count * 45;
            [titleLabel setFrame:CGRectMake(PADDING ,
                                            0,
                                            topBar.frame.size.width-maxWidth,
                                            30)];
            for (UIButton *button in modeButtons) {
               [button setFrame:CGRectMake(insetBounds.size.width - maxWidth, 3,35, 25)];
                
                
                maxWidth= maxWidth-45;
            }
            
     
            
     
        }
        
        


    [playerControlBar setFrame:CGRectMake(bounds.origin.x,
                                           bounds.size.height - PLAYER_CONTROL_BAR_HEIGHT,
                                           bounds.size.width,
                                           PLAYER_CONTROL_BAR_HEIGHT)];
    
    [activityIndicator setFrame:CGRectMake((bounds.size.width - activityIndicator.frame.size.width)/2.0,
                                            (bounds.size.height - activityIndicator.frame.size.width)/2.0,
                                            activityIndicator.frame.size.width,
                                            activityIndicator.frame.size.height)];
    
    [playPauseButton setFrame:CGRectMake(0,
                                          0,
                                          PLAYER_CONTROL_BAR_HEIGHT,
                                          PLAYER_CONTROL_BAR_HEIGHT)];
    
    CGRect fullScreenButtonFrame = CGRectMake(bounds.size.width - 24-5,
                                              (playerControlBar.frame.size.height -21)/2 ,
                                              24,
                                              21);
    [fullScreenButton setFrame:fullScreenButtonFrame];
    
    CGRect routeButtonRect = CGRectZero;
 
    [currentPositionLabel setFrame:CGRectMake(PLAYER_CONTROL_BAR_HEIGHT,
                                               ALIGNMENT_FUZZ,
                                               CURRENT_POSITION_WIDTH,
                                               PLAYER_CONTROL_BAR_HEIGHT)];
    [timeLeftLabel setFrame:CGRectMake(bounds.size.width - PLAYER_CONTROL_BAR_HEIGHT - TIME_LEFT_WIDTH
                                        - routeButtonRect.size.width,
                                        ALIGNMENT_FUZZ,
                                        TIME_LEFT_WIDTH,
                                        PLAYER_CONTROL_BAR_HEIGHT)];
    
    CGRect scrubberRect = CGRectMake(PLAYER_CONTROL_BAR_HEIGHT + CURRENT_POSITION_WIDTH-20,
                                     0,
                                     bounds.size.width - (PLAYER_CONTROL_BAR_HEIGHT * 2) - TIME_LEFT_WIDTH -
                                     CURRENT_POSITION_WIDTH - (TIME_LEFT_WIDTH - CURRENT_POSITION_WIDTH)
                                     - routeButtonRect.size.width+40,
                                     PLAYER_CONTROL_BAR_HEIGHT);
    
    [videoScrubber setFrame:scrubberRect];
    [progressView setFrame:[videoScrubber trackRectForBounds:scrubberRect]];
    progressView.hidden = YES;
}

- (void)pinchGesture:(id)sender
{
    if([(UIPinchGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
        [self fullScreenButtonHandler];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)playPauseHandler
{
    
    if (seekToZeroBeforePlay) {
        seekToZeroBeforePlay = NO;
        [_videoPlayer seekToTime:kCMTimeZero];
    }
    
    if ([self isPlaying]) {
        playWhenReady = NO;
        [_videoPlayer pause];
    } else {
          playWhenReady = YES;
        [self playVideo];
    }
    if([self.delegate respondsToSelector:@selector(videoPlayStatusChanged)])
    {
        [self.delegate videoPlayStatusChanged];
    }
    [self syncPlayPauseButtons];
    [self showControls];
}
- (void)videoTapHandler
{
    if (playerControlBar.alpha) {
        [self hideControlsAnimated:YES];
        
    } else {
        [self showControls];
        
    }
}

-(void)scrubbingDidBegin
{
  
    [self syncPlayPauseButtons];
    [self showControls];
    
    sliderPush = [self isPlaying];
   dispatch_async(dispatch_get_main_queue(), ^{
       playWhenReady = NO;
       [_videoPlayer pause];
   });
    
}

-(void)scrubberIsScrolling
{
    CMTime playerDuration = [self playerItemDuration];
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        double currentTime = floor(duration * videoScrubber.value);
        double timeLeft = floor(duration - currentTime);
        
        if (currentTime <= 0) {
            currentTime = 0;
            timeLeft = floor(duration);
        }
        
        [currentPositionLabel setText:[NSString stringWithFormat:@"%@ ", [self stringFormattedTimeFromSeconds:&currentTime]]];
        
        if (!self.showStaticEndTime) {
            [timeLeftLabel setText:[NSString stringWithFormat:@"-%@", [self stringFormattedTimeFromSeconds:&timeLeft]]];
        } else {
            [timeLeftLabel setText:[NSString stringWithFormat:@"%@", [self stringFormattedTimeFromSeconds:&duration]]];
        }
        
        //        [self.videoPlayer seekToTime:CMTimeMakeWithSeconds((float) currentTime, NSEC_PER_SEC) completionHandler:^(BOOL finish){
        ////            [_videoPlayer];
        //        }];
//        [_videoPlayer seekToTime:CMTimeMakeWithSeconds((float) currentTime, NSEC_PER_SEC)];
      
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlsAnimated:) object:@YES];
}

-(void)scrubbingDidEnd
{
    if(sliderPush)
    {
        [_videoPlayer play];
        [ activityIndicator stopAnimating];
    }
    else{
        [_videoPlayer pause];
        [ activityIndicator startAnimating];
         [self performSelector:@selector(hideControlsAnimated:) withObject:@YES afterDelay:4.0];
    }
    
    CMTime playerDuration = [self playerItemDuration];
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        double currentTime = floor(duration * videoScrubber.value);
        double timeLeft = floor(duration - currentTime);
        
        if (currentTime <= 0) {
            currentTime = 0;
            timeLeft = floor(duration);
        }
        [self.videoPlayer seekToTime:CMTimeMakeWithSeconds((float) currentTime, NSEC_PER_SEC) completionHandler:^(BOOL finish){
         
                   }];
//    [_videoPlayer seekToTime:CMTimeMakeWithSeconds((float) currentTime, NSEC_PER_SEC)];
    }
    [self showControls];
}
#pragma Mark setLayer

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}
- (void)setPlayer:(AVPlayer *)player
{

    [(AVPlayerLayer *)self.layer setPlayer:player];
    [self addSubview:playerControlBar];
}

#pragma Mark

-(BOOL)isFullscreen
{
    return self.bounds.size.width >[[UIScreen mainScreen] bounds].size.width;
}

- (BOOL)isPlaying
{
    return [_videoPlayer rate] != 0.0;
}
-(BOOL)controllerBarHidden{
    return playerControlBar.alpha;
}
//改变mode   //这里不确定Mode 的 URL是否会改变。。
-(void)videoChangeMode:(UIButton *)button
{
    
    for (UIButton *modeButton in modeButtons) {
        if(button == modeButton)
        {
            modeButton.enabled = NO;
            modeButton.layer.borderWidth = 1;
        }
        else {
            modeButton.enabled = YES;
            modeButton.layer.borderWidth = 0;
        }
   
 
 
    }
    
    VideoPlayerModeObj *modePlayer =[playerObj.videoModes objectAtIndex:button.tag];
    if ([self.delegate respondsToSelector:@selector(changeToMode:)]) {
        [self.delegate changeToMode:modePlayer];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setInteger:button.tag forKey:@"videoMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      
        
        NSURL *url = [NSURL URLWithString:[modePlayer.videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self saveSeek];
        [self setURL:url];
        [self reSeek];
    }
}

- (void)fullScreenButtonHandler
{
    if([self.delegate respondsToSelector:@selector(changeInterfaceOrientation)])
    {
        [self.delegate changeInterfaceOrientation];
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    
    
    if (object != [_videoPlayer currentItem]) {
        return;
    }
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:
                playWhenReady = YES;
                break;
            case AVPlayerStatusFailed:
                // TODO:
                [self removeObserversFromVideoPlayerItem];
                [self removePlayerTimeObservers];
                self.videoPlayer = nil;
                
                break;
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"] && _videoPlayer.currentItem.playbackBufferEmpty) {
        playerIsBuffering = YES;
        [activityIndicator startAnimating];
        [self syncPlayPauseButtons];
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"] && _videoPlayer.currentItem.playbackLikelyToKeepUp) {
        if (![self isPlaying] && (playWhenReady ||  playerIsBuffering || scrubBuffering)) {
            [self playVideo];
        }
        [self updatePlaybackProgress];
        [activityIndicator stopAnimating];
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        float durationTime = CMTimeGetSeconds([[self.videoPlayer currentItem] duration]);
        float bufferTime = [self availableDuration];
        
        [ activityIndicator stopAnimating];
        [videoScrubber setProgress:bufferTime/durationTime animated:YES];
    }
    
    return;
}
-(void)removePlayerTimeObservers
{
    if (scrubberTimeObserver) {
        [self.videoPlayer removeTimeObserver:scrubberTimeObserver];
        scrubberTimeObserver = nil;
    }
    
    if (playClockTimeObserver) {
        [self.videoPlayer removeTimeObserver:playClockTimeObserver];
        playClockTimeObserver = nil;
    }
}
- (float)availableDuration
{
    NSArray *loadedTimeRanges = [[self.videoPlayer currentItem] loadedTimeRanges];
    
    // Check to see if the timerange is not an empty array, fix for when video goes on airplay
    // and video doesn't include any time ranges
    if ([loadedTimeRanges count] > 0) {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        return (startSeconds + durationSeconds);
    } else {
        return 0.0f;
    }
}
- (void)updatePlaybackProgress
{
    [self syncPlayPauseButtons];
    [self showControls];
    
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (CMTIME_IS_INDEFINITE(playerDuration) || duration <= 0) {
        [videoScrubber setHidden:YES];
        [progressView setHidden:YES];
        [self syncPlayClock];
        return;
    }
    
    [videoScrubber setHidden:NO];
    [progressView setHidden:NO];
    
    CGFloat width = CGRectGetWidth([videoScrubber bounds]);
    interval = 0.5f * duration / width;
   __block VPVideoPlayerView *obj = self;
    scrubberTimeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                                       queue:NULL
                                                                  usingBlock:^(CMTime time) {
                                                                      [obj syncScrubber];
                                                                  }];
    
    // Update the play clock every second
    playClockTimeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)
                                                                        queue:NULL
                                                                   usingBlock:^(CMTime time) {
                                                                       [obj syncPlayClock];
                                                                   }];
    
}

- (void)syncScrubber
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        videoScrubber.minimumValue = 0.0;
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        float minValue = [videoScrubber minimumValue];
        float maxValue = [videoScrubber maximumValue];
        double time = CMTimeGetSeconds([_videoPlayer currentTime]);
        [videoScrubber setValue:(maxValue - minValue) * time / duration + minValue];
    }
}

- (void)syncPlayClock
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    
    if (CMTIME_IS_INDEFINITE(playerDuration)) {
        [currentPositionLabel setText:@""];
        [timeLeftLabel setText:@""];
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        double currentTime = floor(CMTimeGetSeconds([_videoPlayer currentTime]));
        double timeLeft = floor(duration - currentTime);
        
        if (currentTime <= 0) {
            currentTime = 0;
            timeLeft = floor(duration);
        }
        
        [currentPositionLabel setText:[NSString stringWithFormat:@"%@ ", [self stringFormattedTimeFromSeconds:&currentTime]]];
        if (!self.showStaticEndTime) {
            [timeLeftLabel setText:[NSString stringWithFormat:@"-%@", [self stringFormattedTimeFromSeconds:&timeLeft]]];
        } else {
            [timeLeftLabel setText:[NSString stringWithFormat:@"%@", [self stringFormattedTimeFromSeconds:&duration]]];
        }
	}
}

- (NSString *)stringFormattedTimeFromSeconds:(double *)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:*seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    if (*seconds >= 3600) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    return [formatter stringFromDate:date];
}
- (CMTime)playerItemDuration
{
    if (_videoPlayer.status == AVPlayerItemStatusReadyToPlay) {
        return([_videoPlayer.currentItem duration]);
    }
    
    return(kCMTimeInvalid);
}
#pragma mark 定位
-(float)getSeek
{
    double time = CMTimeGetSeconds([_videoPlayer currentTime]);
    return time;
}
-(void)seekTo:(float)value
{
    [self.videoPlayer seekToTime:CMTimeMakeWithSeconds((float) value, NSEC_PER_SEC)];
}
-(void)saveSeek
{
    tempSeek = CMTimeGetSeconds([self.videoPlayer currentTime]);
}
-(void)reSeek
{
    [self.videoPlayer seekToTime:CMTimeMakeWithSeconds((float) tempSeek, NSEC_PER_SEC)];
}

#pragma makr



- (void)playVideo
{
    if (self.superview) {
        playerIsBuffering = NO;
        scrubBuffering = NO;
        playWhenReady = NO;
        // Configuration is done, ready to start.
        [self.videoPlayer play];
        [self updatePlaybackProgress];
    }
}
- (void)showControls
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kVideoPlayerWillShowControlsNotification
                                                        object:self
                                                      userInfo:nil];
    [UIView animateWithDuration:0.4 animations:^{
        playerControlBar.alpha = 1.0;
        topBar.alpha = 1.0;
        titleLabel.alpha = 1.0;
 
    } completion:nil];
    
    if (self.isFullscreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlsAnimated:) object:@YES];
    
    if ([self isPlaying]) {
        [self performSelector:@selector(hideControlsAnimated:) withObject:@YES afterDelay:4.0];
    }
    if([self.delegate respondsToSelector:@selector(playerMenuHidden:)])
    {
        [self.delegate playerMenuHidden:NO];
        
    }
}
//改变按钮状态
- (void)syncPlayPauseButtons
{
    if ([self isPlaying]) {
        [ playPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    } else {
        [ playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

- (void)hideControlsAnimated:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kVideoPlayerWillHideControlsNotification
                                                        object:self
                                                      userInfo:nil];
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
           playerControlBar.alpha = 0;
            topBar.alpha = 0.0;
            titleLabel.alpha = 0;
        } completion:nil];
        if (self.isFullscreen) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                    withAnimation:UIStatusBarAnimationFade];
        }
        
    } else {
         playerControlBar.alpha = 0;
         topBar.alpha = 0.0;
        
         titleLabel.alpha = 0;
        if (self.isFullscreen) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                    withAnimation:UIStatusBarAnimationNone];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(playerMenuHidden:)])
    {
        [self.delegate playerMenuHidden:YES];
        
    }
}
- (void)removeObserversFromVideoPlayerItem
{
    [self.videoPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    [self.videoPlayer.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.videoPlayer.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.videoPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self syncPlayPauseButtons];
    seekToZeroBeforePlay = YES;
    [activityIndicator stopAnimating];
    if ([self.delegate respondsToSelector:@selector(trackEvent:videoObj:)]) {
        [self.delegate trackEvent:kTrackEventVideoComplete videoObj:playerObj];
    }

}



-(void)addAdView:(UIView *)adView
{
    [self insertSubview:adView belowSubview:playerControlBar];
}
@end
