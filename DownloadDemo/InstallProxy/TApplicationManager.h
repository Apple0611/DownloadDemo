//
//  TApplicationManager.h
//  DownjoyCenter
//  管理程序的下载队列，安装列表读取
//  Created by thilong on 12-4-19.
//  Copyright 2012年 d.cn. All rights reserved.
//
// com.d.cn.TApplicationManager.downloadingCompletedProcessed


#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import "LocalAppInfo.h"
#import "AFNetworking/AFNetworking.h"
typedef enum
{
    InstalledApplicationReadStatusDown,
    InstalledApplicationReadStatusReading,
} InstalledApplicationReadStatus;

//@class LocalAppInfo;

@interface TApplicationManager : NSObject

@property(strong) NSMutableArray *installedApps; //已经安装的应用列表

+ (TApplicationManager *)sharedManager;

- (void)updateInstalledApp:(NSString *)appBundleId appId:(long)appID ipaUrl:(NSString *)ipaUrl iconUrl:(NSString *)iconUrl;

//异步方式获取已经安装的程序，根据readStatus来判断。
- (NSMutableArray *)installedApplications:(NSArray *)wanted reScan:(BOOL)scan readStatus:(InstalledApplicationReadStatus *)readStatus;

//刷新已安装的单个应用
- (void)refreshInstalledApp:(NSString *)bundleId forApp:(LocalAppInfo *)app;

//安装一个应用
- (LocalAppStatus)installApp:(LocalAppInfo *)app;

- (BOOL)isAppInstalled:(LocalAppInfo *)app;

//卸载一个应用
- (BOOL)uninstallApp:(LocalAppInfo *)app;

//导入存档
- (BOOL)importDoc:(NSString *)appPath appId:(NSString *)appId;

//打包一个应用包
- (BOOL)archiveApp:(NSString *)appId __unused;

//恢复一个应用包
- (BOOL)restoreApp:(__unused NSString *)appId __unused;

//移除一个包
- (BOOL)removeArchive:(__unused NSString *)appId __unused;

//已经安装应用的显示名称
- (NSString *)appLocalizedName:(NSString *)identifier;

//已经安装应用的icon,从SBService里面获取
- (UIImage *)appIcon:(NSString *)appID;

//启动一个已安装的应用
- (BOOL)launchApplication:(NSString *)appID __unused;

#pragma mark - 应用更新相关

//获取需要更新的app
- (NSArray *)appNeedUpgrade;

//检测应用更新
- (void)checkAppUpgrade:(NSArray *)wanted;

//搜索相关
//保存历史搜索记录
+ (void)saveSearchHistory;
+ (NSMutableArray *)searchArray;

+ (void)addSearchHistoryToArray:(NSString*) code searchname:(NSString*)name searchtype:(int)type;

+ (void)removeAllHistory;

+(void)removeSigleHistory:(NSString *)_str;

+ (NSMutableArray *)IPAInstalled:(NSArray *)wanted;
@end
