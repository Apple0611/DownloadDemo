//
//  VPViewController.m
//  VidoPlayer
//
//  Created by helfy  on 14-9-1.
//  Copyright (c) 2014年 helfy . All rights reserved.
//

#import "VPViewController.h"
#import "VPVideoPlayerViewController.h"
#import "CCGetP2PUrl.h"
@interface VPViewController ()

@end

@implementation VPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)loctionPlay:(id)sender
{
    NSString *videoPath =[[NSBundle mainBundle] pathForResource:@"test.mp4" ofType:nil];
    VideoPlayerObj *Obj = [[VideoPlayerObj alloc] init];
    Obj.isStreaming = NO;
    Obj.title = @"真野惠里菜";
    Obj.idStr = @"test";
    
    VideoPlayerModeObj *modeObj = [VideoPlayerModeObj modeObjFor:videoPath videoUrlDes: @"本地"];
    [Obj.videoModes addObject:modeObj];
     Obj.defauleIndex = 0;
    
    VPVideoPlayerViewController *playerViewController = [[VPVideoPlayerViewController alloc] initWithNibName:nil bundle:nil];
    [playerViewController setVideoPlayerObj:Obj];
    [self.navigationController pushViewController:playerViewController animated:YES ];
}
-(IBAction)onLinePlay:(id)sender
{
    NSString *videoPath=@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";

    VideoPlayerObj *Obj = [[VideoPlayerObj alloc] init];
    Obj.isStreaming = YES;
    Obj.title = @"弥勒佛";
    Obj.idStr = @"test";

    
    [Obj.videoModes addObject:[VideoPlayerModeObj modeObjFor:videoPath videoUrlDes: @"流畅"]];
    [Obj.videoModes addObject:[VideoPlayerModeObj modeObjFor:videoPath videoUrlDes: @"标准"]];
    [Obj.videoModes addObject:[VideoPlayerModeObj modeObjFor:videoPath videoUrlDes: @"高清"]];
    Obj.defauleIndex = 0;
    VPVideoPlayerViewController *playerViewController = [[VPVideoPlayerViewController alloc] initWithNibName:nil bundle:nil];
    [playerViewController setVideoPlayerObj:Obj];
     [self.navigationController pushViewController:playerViewController animated:YES ];
}

-(IBAction)CCTVLivePlay:(id)sender
{
    [self GetP2PData];
}
/*
 *获取视频直播
 */

-(void)GetP2PData
{
    CCGetP2PUrl *p2pData=[[CCGetP2PUrl alloc]init];
    [p2pData setDelegate:(id)self];
    [p2pData startPlalyQuest];
}
-(void)ReturnGetP2Purl:(BOOL)bRet P2PVideoUrlData:(NSDictionary *)dicVideoUrl
{
    if (!bRet)
    {
        return;
    }
   
    NSString *videoPath= [dicVideoUrl objectForKey:@"iPhone"];;
    
    VideoPlayerObj *Obj = [[VideoPlayerObj alloc] init];
    Obj.isStreaming = YES;
    Obj.title = @"CCTV 直播";
    Obj.idStr = @"test";

    
    [Obj.videoModes addObject:[VideoPlayerModeObj modeObjFor:videoPath videoUrlDes: @"直播"]];
 
    Obj.defauleIndex = 0;
    VPVideoPlayerViewController *playerViewController = [[VPVideoPlayerViewController alloc] initWithNibName:nil bundle:nil];
    [playerViewController setVideoPlayerObj:Obj];
    [self.navigationController pushViewController:playerViewController animated:YES ];
}


@end
