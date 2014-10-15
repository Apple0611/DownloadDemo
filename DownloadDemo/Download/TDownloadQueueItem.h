//
//  TDownloadQueueItem.h
//  GameCenter
//
//  Created by thilong on 13-4-13.
//  Copyright (c) 2013年 thilong.tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDownloadQueueItemDelegate.h"
#import "TDownloadItem.h"
#import "AFNetworking/AFNetworking.h"
#import "AppInfoParser.h"

@class AppInfoLite;
@protocol NSURLConnectionDataDelegate;
//@protocol ASIHTTPRequestDelegate;
typedef enum
{
    TDownloadItemStatusWaiting = 0,
    TDownloadItemStatusRequestingUrl,
    TDownloadItemStatusDownloading,
    TDownloadItemStatusPaused,
    TDownloadItemStatusFailed,
    TDownloadItemStatusCompleted,
    TDownloadItemStatusCanceled,
    TDownloadItemStatusError,
} TDownloadItemStatus;

@interface TDownloadQueueItem : NSObject <NSURLConnectionDataDelegate,TDownloadDelegate>

@property(assign, readonly) TDownloadItemStatus              status;
@property(assign, nonatomic) id <TDownloadQueueItemDelegate> manager;

- (id)initWithDownloadItem:(TDownloadItem *)item;

//计算下载状态
- (void)calcState;

- (void)start;

- (void)retry;

- (void)pause;

- (void)cancelAndDeleteFile;

- (BOOL)isDownloadingItem:(TDownloadItem *)item;

- (TDownloadItem *)targetDownloadItem;

- (void)setWait;

#pragma mark - 获取状态
- (BOOL)isDownloading;

- (unsigned int)speed;

- (float)completePercent;

- (unsigned long)completeSize;

- (unsigned long)getTotalSize;

- (void)restoreCorrespondingStatus;

- (NSString *)remoteTotalSize;

- (NSString *)downloadSpeed;

- (NSString *)downloadCompletedSize;

- (NSString *)statusDescription;
- (unsigned int)finishedPercent;

- (unsigned long)downloadTargetSize;
@end
