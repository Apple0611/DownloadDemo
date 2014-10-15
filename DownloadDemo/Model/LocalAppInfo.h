//
//  LocalAppInfo.h
//  DownjoyCenter
//
//  Created by thilong on 12-4-19.
//  Copyright 2012年 d.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDownloadItem.h"
typedef enum
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
} LocalAppStatus;

typedef enum
{
    LocalAppFileTypeApp      = 0x00,
    LocalAppFileTypeDocument = 0x01,
} LocalAppFileType;

@class TDownloadItem;
@class AppInfoLite;
@class AppInfo;
@class AppDetailInfo;

@interface LocalAppInfo : TDownloadItem
@property(nonatomic) long           ID;
@property(nonatomic) long           size;
@property(nonatomic) long           newVersionSize; //新版本的大小
@property(nonatomic) LocalAppStatus status;         //当前状态
@property(nonatomic, strong) NSString *ipaUrl;      //ipa的下载地址
@property(nonatomic, strong) NSString *iconUrl;     //icon的址址
@property(nonatomic, strong) NSString *bundleID;    //标识
@property(nonatomic, strong) NSString *name;        //名称
@property(nonatomic, strong) NSString *englishName; //英文名
@property(nonatomic, strong) NSString *version;     //版本
@property(nonatomic, strong) NSString *versionNew;   //最新版本
@property(nonatomic, strong) NSString *appPathOnDevice; //本地应用程序路径
@property(nonatomic, retain) UIImage  *icon;         //icon
@property(nonatomic) LocalAppFileType fileType;
@property(nonatomic, strong) NSString *upVersion;   //最新版本
@property(nonatomic, strong) NSString *versionTMP;// 记录更新列表点击更新后app的临时版本  更新的app 在下载管理列表和可更新中 显示的版本号和实际的版本号不一样 
@property(nonatomic, strong) NSString *hatTag;  //普通传0，BT传1

@property (nonatomic, strong) NSString *neewFeature;

@property (nonatomic, assign) BOOL isFolded;
//NSString *servicePath();
//NSURL *servicePathURL();
- (id)copyWithZone:(NSZone *)zone;
+ (LocalAppInfo *)initWithAppInfoLite:(AppInfoLite *)appInfoLite;

+ (LocalAppInfo *)initWithAppInfo:(AppInfo *)appInfo;

+ (LocalAppInfo *)initWithDictionary:(NSDictionary *)d;

+ (LocalAppInfo *)appInfoWithAppDetailInfo:(AppDetailInfo *)app;

- (NSString *)getSizeDescription;

- (NSString *)getStatusDescription;

- (NSString *)getLocalFilePath;

- (BOOL)isEqualTo:(LocalAppInfo *)app;

-(NSString *)getSaveFileNameEn;

- (void)saveDownloadedState;

- (void)removeDownloadedState;

-(NSString *)getMetadataFileName;

//-- xiaojun 2013.12.18
// 获取app的https plist下载信息的base64编码
-(NSString*) getAppBase64InfoOfHttpsPlist:(BOOL) b_hacked;
@end
