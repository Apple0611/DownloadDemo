//
//  TKDownloadItem.m
//  DownloadDemo
//
//  Created by downjoymac on 14-7-30.
//  Copyright (c) 2014年 Apple0611. All rights reserved.
//

#import "TKDownloadItem.h"

@interface TKDownloadItem()

@property(nonatomic,retain)LocalDownloadedAppInfo *localDownloadItem;

@property(nonatomic,retain)NSString *savepath;

@property(nonatomic,retain)NSString *tmpSavePath;

@property(nonatomic,retain)NSString *statusSavePath;

@property(nonatomic,retain)NSFileHandle *tmpSaveHandle;

@property(nonatomic,retain)NSMutableData *tmpData;

@property(nonatomic,retain)NSMutableDictionary *statusDic;

@property(nonatomic,retain)NSURLConnection *connection;

@property(nonatomic,assign)NSInteger retryTime;

@end

@implementation TKDownloadItem{
    
    NSTimeInterval _startTime;
    
    unsigned long _completedSizeInOneDownloadTime;
    
    unsigned long _completedSizeInLastDownloadTime;
    
    unsigned long _totalCompletedSize;
}

-(void)dealloc{
    [super dealloc];
}

-(id)initWithDownloadItem:(LocalDownloadedAppInfo *)item{
    self=[super init];
    if (self) {
        _retryTime=0;
        _startTime=0;
        _localDownloadItem=item;
        _tmpSaveHandle=nil;
        _status=MDownloadItemStatusWaiting;
        NSString *cacheCategory=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *documentCategory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *tempDataCategory=[cacheCategory stringByAppendingPathComponent:@"tempData"];
        NSString *statusCacheCategory=[cacheCategory stringByAppendingPathComponent:@"statusCache"];
        
        
    }
    return self;
}

-(void)startDownload{
    
}

-(void)retryDownload{
    
}

-(void)pauseDownload{
    
}


-(BOOL)isDownloading{
    
}

-(NSInteger)downloadingSpeed{
    
}

-(float)downloadedPercent{
    
}

-(long)downloadedSize{
    
}

-(long)getTotalPacketSize{
    
}

@end
