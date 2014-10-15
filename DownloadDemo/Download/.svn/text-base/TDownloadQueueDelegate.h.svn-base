//  TDownloadQueueDelegate
//  DownjoyCenter4All
//
//  Created by thilong on 13-7-24.
//  Copyright (c) 2012 thilong.tao. All rights reserved.
//  Description: 


#import <Foundation/Foundation.h>

typedef enum
{
    TDownloadQueueNoError                    = 0x00,
    TDownloadQueueErrorDownloadAlreadyExist  = -1,
    TDownloadQueueErrorItemAlreadyDownloaded = -2,
} TDownloadQueueError;

@class TDownloadQueue;
@class TDownloadItem;
@class FMResultSet;

@protocol TDownloadQueueDelegate <NSObject>
@required

- (TDownloadItem *)tDownloadQueue:(TDownloadQueue *)queue parseDownloadItem:(FMResultSet *)item;

- (BOOL)tDownloadQueue:(TDownloadQueue *)queue isItemDownloaded:(TDownloadItem *)item;

- (void)tDownloadQueue:(TDownloadQueue *)queue downloadItemComplete:(TDownloadItem *)item;

- (void)tDownloadQueue:(TDownloadQueue *)queue addDownloadItemSucceed:(TDownloadItem *)item;

- (void)tDownloadQueue:(TDownloadQueue *)queue addDownloadItemFailed:(TDownloadItem *)item errorCode:(TDownloadQueueError)errorCode;

- (void)tDownloadQueue:(TDownloadQueue *)queue removeDownloadedItem:(TDownloadItem *)item;

- (BOOL)tDownloadQueue:(TDownloadQueue *)queue willAddItemDownload:(TDownloadItem *)item;

- (BOOL)tDownloadQueue:(TDownloadQueue *)queue canStartNewDownlaod:(TDownloadItem *)item;

- (BOOL)tDownloadQueue:(TDownloadQueue *)queue canContinueDownload:(TDownloadItem *)item;

@end