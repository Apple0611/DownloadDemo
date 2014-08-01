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

@end

@implementation TKDownloadItem{
    
    NSInteger _retryTime;
    
    NSTimeInterval _startTime;                      //下载开始时间
    
    unsigned long _completedSizeInOneDownloadTime;  //某次下载的大小
    
    unsigned long _completedSizeInLastDownloadTime;  //上次下载的大小
    
    unsigned long _totalCompletedSize;               //下载完成总大小
    
    unsigned long _speed;                            //下载速度
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
        
        NSString *downloadFileName=[_localDownloadItem getItemFileSavaPath];
        NSString *cacheCategory=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *tempDataCategory=[cacheCategory stringByAppendingPathComponent:@"tempData"];
        NSString *statusCacheCategory=[cacheCategory stringByAppendingPathComponent:@"statusCache"];
        self.tmpSavePath=[tempDataCategory stringByAppendingPathExtension:downloadFileName];
        self.statusSavePath=[statusCacheCategory stringByAppendingPathExtension:downloadFileName];
        
        NSString *documentCategory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.savepath=[documentCategory stringByAppendingPathExtension:downloadFileName];
        
        if ([self isContinueTransferFromBreakpoint]) {
            
            
        }
   
    }
    return self;
}

//是否有缓存，判断断点续传
-(BOOL)isContinueTransferFromBreakpoint{
    BOOL isTmpSavePathExist=[[NSFileManager defaultManager]fileExistsAtPath:self.tmpSavePath];
    BOOL isStatusSavePath=[[NSFileManager defaultManager]fileExistsAtPath:self.statusSavePath];
    if (isTmpSavePathExist && isStatusSavePath) {
        return YES;
    }
    return NO;
}

-(void)startDownload{
    if ([self isDownloading]) {
        return;
    }
    _retryTime=0;
    [self downLoading];
}

-(void)retryDownload{
    _retryTime++;
    [self downLoading];
    
}

-(void)downLoading{
    _startTime=[[NSDate date]timeIntervalSince1970];
    [_localDownloadItem setItemDownloadStatus:MDownloadItemStatusDownloading];
    
}

-(void)pauseDownload{
    
}

-(void)saveCurrentDownloadStatus{
    
}

-(BOOL)isDownloading{
    if (_status==MDownloadItemStatusDownloading || _status==MDownloadItemStatusRequestingURL) {
        return YES;
    }
    return NO;
}

-(NSInteger)downloadingSpeed{
    return _speed;
}

-(float)downloadedPercent{
    
}

-(long)downloadedSize{
    
}

-(long)getTotalPacketSize{
    
}

@end
