//
//  TDownloadQueue.h
//  GameCenter
//
//  Created by thilong on 13-4-13.
//  Copyright (c) 2013年 thilong.tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDownloadQueueItemDelegate.h"
#import "TDownloadItem.h"
#import "TDownloadQueueDelegate.h"


@class TDownloadQueueItem;

@interface TDownloadQueue : NSObject <TDownloadQueueItemDelegate, UIActionSheetDelegate>

@property(nonatomic, assign) id <TDownloadQueueDelegate> delegate;

+ (TDownloadQueue *)sharedQueue;

//试图添加一个下载项目到下载队列
- (void)tryAddDownloadItem:(TDownloadItem *)item animateIcon:(UIImageView *)animateIcon;

- (void)tryAddDownloadItemWithOutCheck:(TDownloadItem *)item;

//添加一个应用下载到下载队列
- (void)addItem:(TDownloadItem *)item;

//添加一组应用下载到下载队列
- (void)addItems:(NSArray *)items __unused;

//恢复一个下载
- (void)resume:(TDownloadItem *)item;

//取消一个下载,下载会从下载队列删除，临时文件会被清空(只比较bundleID 与 version)
- (void)cancel:(TDownloadItem *)app;

//取消所有下载,下载会从下载队列删除，临时文件会被清空
- (void)cancelAll __unused;

//停止一个下载(暂停)
- (void)pause:(TDownloadItem *)item;

//停上所有下载(暂停)
- (void)pauseAll;

//开始所有下载
- (void)resumeAll;

//所有的下载项目
- (NSArray *)downloadingItems;

//正在进行的下载
- (NSUInteger)currentDownloadingCount;

//从下载队列中获取对应的下载项
- (TDownloadQueueItem *)queryDownloadingItem:(TDownloadItem *)item;

//保存程序状态(保存正在下载列表)
- (void)saveDownloadingState;

//读取上一次程序的状态
- (void)loadDownloadingState;

- (NSUInteger)currentDownloadingSpeed:(unsigned int *)speed;

@end
