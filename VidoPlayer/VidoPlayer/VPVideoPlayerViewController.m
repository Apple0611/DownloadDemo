//
//  VPVideoPlayerViewController.m
//  VidoPlayer
//
//  Created by helfy  on 14-9-1.
//  Copyright (c) 2014年 helfy . All rights reserved.
//

#import "VPVideoPlayerViewController.h"
#import "VPAdView.h"
@interface VPVideoPlayerViewController ()
{
    VPVideoPlayerView *mVideoPlayer;
    UIView *doneView;
    
    VideoPlayerObj *playVideoObj;
    //test ad View
    VPAdView *adView;
}
@end

@implementation VPVideoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

//设置播放的obj
-(void)setVideoPlayerObj:(VideoPlayerObj *)obj
{
    [doneView removeFromSuperview];
    
  
    playVideoObj = obj;
    
    if(mVideoPlayer ==nil)
    {
        mVideoPlayer = [[VPVideoPlayerView alloc] init];
        
        mVideoPlayer.delegate = (id)self;
        
        [self.view addSubview:mVideoPlayer];
        
        float heigth = 180;
        if([[UIScreen mainScreen] bounds].size.height <500)
        {
            heigth =180;
        }
        mVideoPlayer.frame =CGRectMake(0, (kDevIsIOS7?20:0), [[UIScreen mainScreen] bounds].size.width, heigth);
        
    }
   //设置播放的obj
    [mVideoPlayer playVideoWithObj:playVideoObj];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
-(void)hiddenBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        self.navigationController.navigationBarHidden = YES;
        [UIView beginAnimations:nil context:nil];
        mVideoPlayer.frame = CGRectMake(0, 0,self.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width);
        [UIView commitAnimations];
    
        if([mVideoPlayer controllerBarHidden])
        {
            [self performSelector:@selector(hiddenBar) withObject:nil afterDelay:0];
        }
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else{
        [UIView beginAnimations:nil context:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
        float heigth = 180;
        if([[UIScreen mainScreen] bounds].size.height <500)
        {
            heigth =180;
        }

        mVideoPlayer.frame = CGRectMake(0,  (kDevIsIOS7?20:0),[[UIScreen mainScreen] bounds].size.width, heigth);
        [UIView commitAnimations];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }

}


#pragma mark videoPlayer
-(void)playerMenuHidden:(BOOL)hidde //播放器菜单隐藏
{
    if(hidde)
    {
        if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) || mVideoPlayer.frame.size.width > [[UIScreen mainScreen] bounds].size.width)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
        else{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }
    else{
        if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
        else{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }
    
}
- (void)changeInterfaceOrientation
{
    if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }
    else{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }
    [UIViewController attemptRotationToDeviceOrientation];
}
- (void)trackEvent:(NSString *)event videoObj:(VideoPlayerObj *)obj{
    
    if([event isEqualToString:kTrackEventVideoComplete])
    {
        //播放完成
        if(playVideoObj)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
   
    }
   
}
 //播放状态发生改变。。实现暂停添加广告代理
- (void)videoPlayStatusChanged{
    
    if(mVideoPlayer.isPlaying)
    {
        [adView removeFromSuperview];
    }
    else{
        if(adView == nil)
        {
       
            adView=[[VPAdView alloc] initWithFrame:self.view.frame];
          
        }
             //mode1
//        adView.frame =self.view.frame;
//        [self.view addSubview:adView];
        
         //mode2
        adView.frame =CGRectInset(mVideoPlayer.bounds, 10, 10);
        [mVideoPlayer addAdView:adView];
    }
}
//改变mode  不实现则直接使用初始modeURL
//- (void)changeToMode:(VideoPlayerModeObj *)mode;
//{
//
// 
//    
//}
@end
