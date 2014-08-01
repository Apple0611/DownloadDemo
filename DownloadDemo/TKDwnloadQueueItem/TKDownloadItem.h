//
//  TKDownloadItem.h
//  DownloadDemo
//
//  Created by downjoymac on 14-7-30.
//  Copyright (c) 2014年 Apple0611. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalDownloadedAppInfo.h"
#import "DYMicro.h"
#import "AFHTTPRequestOperation.h"

@class AppInfo;

@interface TKDownloadItem : NSObject<NSURLConnectionDataDelegate>

@property(nonatomic)DownloadStatusType status;

-(id)initWithDownloadItem:(LocalDownloadedAppInfo *)item;

-(void)startDownload;

-(void)retryDownload;

-(void)downLoading;

-(void)pauseDownload;

-(void)saveCurrentDownloadStatus;

-(BOOL)isDownloading;

-(NSInteger)getDownloadingSpeed;

-(float)getDownloadedPercent;

-(long)getDownloadedSize;

-(long)getTotalPacketSize;

@end
