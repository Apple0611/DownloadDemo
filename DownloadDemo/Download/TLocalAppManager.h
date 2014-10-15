//  TLocalAppManager
//  GameCenter
//
//  Created by thilong on 13-4-17.
//  Copyright (c) 2012 thilong.tao. All rights reserved.
//  Description: 管理手机上安装与安装的应用，包括安装，卸载，


#import <Foundation/Foundation.h>

@class LocalAppInfo;
typedef enum
{
    InstallingStatusNotInInstallQueue,   //不在安装队列中
    InstallingStatusInstalling,          //正在安装
    InstallingStatusInstallWaiting       //等待安装
} InstallingStatus;

typedef enum
{
    UnInstallingStatusNotInUnInstallQueue,   //不在卸载队列中
    UnInstallingStatusUnInstalling,          //正在卸载
    UnInstallingStatusUnInstallWaiting       //等待卸载
} UnInstallingStatus;

@interface TLocalAppManager : NSObject

+ (TLocalAppManager *)sharedManager;

#pragma mark - 已下载相关
//获取所有已经下载的应用
- (NSArray *)downloadedApps;

//检测一个应用是否已经下载过了
- (BOOL)isAppDownloaded:(LocalAppInfo *)app;

//保存下载的应用
- (void)saveDownloadedApp:(LocalAppInfo *)app;

- (void)saveDownloadedApp:(LocalAppInfo *)app postStatus:(BOOL)post   saveStatus:(BOOL)save;

//删除一个已下载应用缓存
- (void)removeDownloadedApp:(LocalAppInfo *)app;

//清空已下载应用缓存
- (void)clearDownloadedApp __unused;

//保存程序运行状态(保存已下载列表)
- (void)saveApplicationState;

//读取上一次程序的状态
- (void)loadApplicationState;

//清理v3.1之前的缓存
- (void)clearCacheBefore31;

//清理v3.1及以后的缓存
- (void)clearDownloadedCache;

//清理所有的下载记录，恢复至刚安装app的状态
- (void)clearDownloadedToNew;
#pragma mark - 安装相关

- (void)installApp:(LocalAppInfo *)app;

//取消一个安装，如果正在安装，则无法取消
- (BOOL)cancelInstallApp:(LocalAppInfo *)app;

//查询应用的安装状态
- (InstallingStatus)queryInstallApp:(LocalAppInfo *)app;

//查询安装列表数量
- (int)countOfInstallOperation;

#pragma mark - 卸载相关
- (int)countOfUninstallOperation;
- (void)uninstallApp:(LocalAppInfo *)app;

//取消一个卸载，如果正在卸载，则无法取消
- (BOOL)cancelUnInstallApp:(LocalAppInfo *)app;

//查询应用的卸载状态
- (UnInstallingStatus)queryUnInstallApp:(LocalAppInfo *)app;


@end