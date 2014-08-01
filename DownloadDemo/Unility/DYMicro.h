//
//  DYMicro.h
//  DownloadDemo
//
//  Created by downjoymac on 14-7-30.
//  Copyright (c) 2014年 Apple0611. All rights reserved.
//
/**
 *  程序中的全局宏定义等等
 */


//某一个TKDownloadItem在下载中的状态信息
typedef NS_ENUM(NSInteger,DownloadStatusType)
{
    MDownloadItemStatusWaiting=0,
    MDownloadItemStatusRequestingURL,
    MDownloadItemStatusDownloading,
    MDownloadItemStatusPaused,
    MDownloadItemStatusFailed,
    MDownloadItemStatusCanceled,
    MDownloadItemStatusCompleted,
    MDownloadItemStatusError,
};

//
typedef NS_ENUM(NSInteger,LocalAppStatus)
{
    LocalAppStatusNew = 0,
    //正在下载
    LocalAppStatusDownloading,
    //下载暂停
    LocalAppStatusDownloadPaused,
    //下载失败
    LocalAppStatusDownloadFailed,
    //下载完成
    LocalAppStatusDownloadCompleted,
    //等待下载
    LocalAppStatusDownloadWaiting,
    //正在等待安装
    LocalAppStatusInstallingWaiting,
    //正在安装
    LocalAppStatusInstalling,
    //安装完成
    LocalAppStatusInstalled,
    //安装失败
    LocalAppStatusInstallFailed,
    //未安装
    LocalAppStatusNotInstall,
    //正在等待卸载
    LocalAppStatusUninstallingWaiting,
    //正在卸载
    LocalAppStatusUninstalling,
    //卸载失败
    LocalAppStatusUninstallFailed,
    //已删除
    LocalAppStatusDeleted,
    //删除安装包
    LocalAppStatusDeletePackage,
    
    LocalAppStatusDownloadCheckFailed,
};