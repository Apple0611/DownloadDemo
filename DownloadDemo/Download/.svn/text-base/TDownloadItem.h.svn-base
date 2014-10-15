//
// Created by thilong on 13-4-20.
// Copyright (c) 2013 thilong.tao. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
// description: 用于下载队列，如果要实现自已的下载项目，请使用此类来实现你想要的子类


#import <Foundation/Foundation.h>

//@class ASIFormDataRequest;
//@protocol ASIHTTPRequestDelegate;

@protocol TDownloadDelegate <NSObject>
- (void) getIpaUrlSuccessful;
- (void) getIpaUrlFaild;
@end
typedef enum
{
    kTDownloadErrorNoError        = 0x00,
    kTDownloadErrorAddressInvalid = 0x01,
} kTDownloadError;

@interface TDownloadItem : NSObject


@property(nonatomic) kTDownloadError lastError;
@property(nonatomic, assign) id <TDownloadDelegate> delegate;
//返回下载地址
- (NSURL *)getDownloadUrl;

- (void)setDownloadUrl:(NSString *)urlStr;

//设置下载项的大小
- (void)setRemoteFileSize:(unsigned long)size;

//返回要保存的文件名
- (NSString *)getSaveFileName;

//返回项目的状态是否正在下载,不代表实际的下载项,仅在数据缓存后用于判断
- (BOOL)isDownloading;

- (BOOL)isPaused;

//比较是否正在下载这个项目(子类实现)
- (BOOL)isDownloadingMe:(id)sender;

- (void)setDownloadState:(int)downloadState;

- (NSString *)getId;

- (void)saveDownloadingState;

- (void)downloadCanceled;

- (void)downloadComplete;

//获取下载队列对应的状态
- (int)getTDownloadQueueItemCorrespondingStatus;

//- (ASIFormDataRequest *)getPathForDownload:(id <ASIHTTPRequestDelegate>)delegate;
- (void)getPathForDownload;

@end