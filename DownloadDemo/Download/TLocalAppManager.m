//  TLocalAppManager
//  GameCenter
//
//  Created by thilong on 13-4-17.
//  Copyright (c) 2012 thilong.tao. All rights reserved.
//  Description: 


#import "TLocalAppManager.h"
#import "TKMicro.h"
//#import "AppInfoLite.h"
#import "LocalAppInfo.h"
#import "FMDatabase.h"
#import "InstallOperation.h"
#import "UninstallOperation.h"
#import "TKCodeHelper.h"
#import "AppStrings.h"
#import <dlfcn.h>

#define PROXY_TYPE_INSTALL 1u
#define PROXY_TYPE_UNINSTALL 2u

@interface UIApplication (Undocumented)

- (void)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspended;

- (void)saveDownloadedApp:(LocalAppInfo *)app postStatus:(BOOL)post saveStatus:(BOOL)save;
@end

@interface TLocalAppManager ()

@property(nonatomic, strong) NSMutableArray   *downloadedAppCache;
@property(nonatomic, strong) NSObject         *downloadAppCacheLock;
@property(nonatomic, strong) NSOperationQueue *installQueue;
@property(nonatomic, strong) NSOperationQueue *uninstallQueue;

- (void)installApp:(LocalAppInfo *)app postStatus:(BOOL)post;

- (void)uninstallApp:(LocalAppInfo *)app postStatus:(BOOL)post;

- (void)deleteAllFileInDirectory:(NSString *)path extension:(NSString *)ext;

@end

@implementation TLocalAppManager

+ (TLocalAppManager *)sharedManager
{
    static TLocalAppManager *_sharedManager = nil;
    if (_sharedManager == nil)
    {
        _sharedManager = [[TLocalAppManager alloc] init];
    }
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (void)dealloc
{
    self.downloadedAppCache   = nil;
    self.downloadAppCacheLock = nil;
    self.installQueue         = nil;
    self.uninstallQueue       = nil;
    [super dealloc];
}

#pragma mark - 已下载相关
- (NSArray *)downloadedApps
{
    @synchronized (self.downloadAppCacheLock)
    {
        if (self.downloadedAppCache == nil)
        {
            self.downloadedAppCache = [[[NSMutableArray alloc] init] autorelease];
        }
    }
    return self.downloadedAppCache;
}

- (BOOL)isAppDownloaded:(LocalAppInfo *)app
{
    BOOL exists = NO;
    @synchronized (self.downloadAppCacheLock)
    {

        for (LocalAppInfo *appIt in self.downloadedAppCache)
        {
            if ([app isEqualTo:appIt])
            {
                exists = YES;
                break;
            }
        }
    }
    return exists;
}


- (void)saveDownloadedApp:(LocalAppInfo *)app
{
    [self saveDownloadedApp:app postStatus:YES saveStatus:YES];
}

- (void)saveDownloadedApp:(LocalAppInfo *)app postStatus:(BOOL)post saveStatus:(BOOL)save
{
    @synchronized (self.downloadAppCacheLock)
    {
        if (self.downloadedAppCache == nil)
        {
            self.downloadedAppCache = [[[NSMutableArray alloc] init] autorelease];
        }
        bool exists = false;
        for (LocalAppInfo *appIt in self.downloadedAppCache)
        {
            if ([app isEqualTo:appIt])
            {
                exists = true;
                break;
            }
        }
        if (!exists)
        {
            [self.downloadedAppCache addObject:app];
            if (save)
            {
                [app saveDownloadedState];
            }
            if (post)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
            }

        }
    }
}

- (void)removeDownloadedApp:(LocalAppInfo *)app
{
    bool removed = false;
    @synchronized (self.downloadAppCacheLock)
    {
        LocalAppInfo      *removeTarget = nil;
        for (LocalAppInfo *appIt in self.downloadedAppCache)
        {
            if ([app isEqualTo:appIt])
            {
                if ([self queryInstallApp:appIt] != InstallingStatusInstalling && [self cancelInstallApp:appIt])
                {  //仅在没有安装时可以移除
                    removeTarget = appIt;
                }
                break;
            }
        }
        if (removeTarget)
        {
            [self cancelInstallApp:removeTarget];
            NSString *filePath = [removeTarget getLocalFilePath];
            if (nil != filePath)
            {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
            [removeTarget removeDownloadedState];
            [self.downloadedAppCache removeObject:removeTarget];
            removed            = true;

            
        }
    }
    if (removed)
    {
        if (IS_PHONE) {
            [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOADED_Queue_Removed object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
        }
        
    }
}

- (void)clearDownloadedApp __unused
{
    @synchronized (self.downloadAppCacheLock)
    {
        for (int i = [self.downloadedAppCache count] - 1; i >= 0; --i)
        {
            LocalAppInfo *appIt = [self.downloadedAppCache objectAtIndex:i];
            if ([self queryInstallApp:appIt] == InstallingStatusInstalling)
            {
                continue;
            }
            if (![self cancelInstallApp:appIt])
            {
                continue;
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:[appIt getLocalFilePath]])
            {
                [[NSFileManager defaultManager] removeItemAtPath:[appIt getLocalFilePath] error:nil];
            }
            [appIt removeDownloadedState];
        }
        [self.downloadedAppCache removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
    }
//    //清除DataCache文件夹
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    path = [path stringByAppendingPathComponent:@"DataCache"];
//    
//    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

//保存程序运行状态(保存已下载列表)
- (void)saveApplicationState
{
    @synchronized (self.downloadAppCacheLock)
    {
        for (LocalAppInfo *appIt in self.downloadedAppCache)
        {
            [appIt saveDownloadedState];
        }
    }
}

//读取上一次的程序状态
- (void)loadApplicationState
{
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    FMResultSet    *item      = [db executeQuery:IDS_DATABASE_Query_Downloaded_Cache];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if (item != nil)
    {
        while ([item next])
        {
            LocalAppInfo *app = [[LocalAppInfo alloc] init];
            app.ID              = [item longForColumn:@"ID"];
            app.size            = [item longForColumn:@"size"];
            app.newVersionSize  = [item longForColumn:@"newVersionSize"];
            app.status          = (LocalAppStatus) [item intForColumn:@"status"];
            app.ipaUrl          = [item stringForColumn:@"ipaUrl"];
            app.iconUrl         = [item stringForColumn:@"iconUrl"];
            app.bundleID        = [item stringForColumn:@"bundleID"];
            app.name            = [item stringForColumn:@"name"];
            app.englishName     = [item stringForColumn:@"englishName"];
            app.version         = [item stringForColumn:@"version"];
            app.versionNew      = [item stringForColumn:@"versionNew"];
            app.appPathOnDevice = [item stringForColumn:@"appPathOnDevice"];
            app.fileType        = (LocalAppFileType) [item intForColumn:@"fileType"];
            app.versionTMP  =  [item stringForColumn:@"versionTmp"];
            
            if (LocalAppStatusInstalling==app.status) {
                app.status=LocalAppStatusNotInstall;
            }
            [tempArray addObject:app];
            [app release];
        }
    }
    [db close];
    @synchronized (self.downloadAppCacheLock)
    {
        for (LocalAppInfo *app in tempArray)
        {
            [self saveDownloadedApp:app postStatus:NO saveStatus:NO];
        }
    }
    [tempArray release];
    [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
}

- (void)clearCache
{
    NSString      *extension          = @"ipa";
    NSFileManager *fileManager        = [NSFileManager defaultManager];
    NSArray       *paths              = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString      *documentsDirectory = [paths objectAtIndex:0];
    NSArray       *contents           = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator  *e                  = [contents objectEnumerator];

    NSString *filename;
    while ((filename = [e nextObject]))
    {
        if ([[filename pathExtension] isEqualToString:extension] || [[filename pathExtension] isEqualToString:@"tmp"]
                || [[filename pathExtension] isEqualToString:@"cache"])
        {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

- (void)clearCacheBefore31
{

}

- (void)clearDownloadedCache
{
    [self clearDownloadedApp];
    [[NSNotificationCenter defaultCenter] postNotificationName:IDS_FILES_CACHE_CLEANED object:nil userInfo:nil];
}

- (void)clearDownloadedToNew
{
    [self clearCacheBefore31];
    NSString *cacheFolder       = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#ifdef _DEB_
    NSString *documentFolder    = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cacheFolder = [cacheFolder stringByReplacingOccurrencesOfString:@"/root/" withString:@"/mobile/"];
#else
    NSString *documentFolder    = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#endif
    NSString *tempDataFolder    = [cacheFolder stringByAppendingPathComponent:@"tempData"];
    NSString *statusCacheFolder = [cacheFolder stringByAppendingPathComponent:@"statusCache"];
    [self deleteAllFileInDirectory:documentFolder extension:@"ipa"];
    [self deleteAllFileInDirectory:tempDataFolder extension:nil];
    [self deleteAllFileInDirectory:statusCacheFolder extension:nil];
}

- (void)deleteAllFileInDirectory:(NSString *)path extension:(NSString *)ext
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray       *contents    = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator  *e           = [contents objectEnumerator];
    NSString      *filename;
    while ((filename = [e nextObject]))
    {
        if (((ext != nil && [[filename pathExtension] isEqualToString:ext]) || ext == nil))
        {
            [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

#pragma mark - 安装相关

- (void)installApp:(LocalAppInfo *)app
{
    [self installApp:app postStatus:YES];
}

- (BOOL)cancelInstallApp:(LocalAppInfo *)app
{
    InstallingStatus status = [self queryInstallApp:app];
    if (status == InstallingStatusNotInInstallQueue)
    {
        return YES;
    }
    else if (status == InstallingStatusInstalling)
    {
        return NO;
    }
    else if (status == InstallingStatusInstallWaiting)
    {
        @synchronized (self.installQueue)
        {
            InstallOperation      *target = nil;
            for (InstallOperation *operation in [self.installQueue operations])
            {
                if (![operation isCancelled] && [operation.appInfo isEqualTo:app])
                {
                    target = operation;
//                    [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Status_Changed object:nil];
                    break;
                }
            }
            if (target)
            {
                target.appInfo.status = LocalAppStatusNew;
                [target cancel];
            }
        }
    }
    return YES;
}

- (InstallingStatus)queryInstallApp:(LocalAppInfo *)app
{
    InstallingStatus ret = InstallingStatusNotInInstallQueue;
    @synchronized (self.installQueue)
    {
        for (InstallOperation *operation in [self.installQueue operations])
        {
            if (![operation isCancelled] && [operation.appInfo isEqualTo:app])
            {
                if (operation.appInfo.status == LocalAppStatusInstallingWaiting)
                {
                    ret = InstallingStatusInstallWaiting;
                }
                else if (operation.appInfo.status == LocalAppStatusInstalling)
                {
                    ret = InstallingStatusInstalling;
                }
                break;
            }
        }
    }
    return ret;
}


- (void)installApp:(LocalAppInfo *)app postStatus:(BOOL)post
{
    if (self.installQueue == nil)
    {
        self.installQueue = [[[NSOperationQueue alloc] init] autorelease];
        [self.installQueue setMaxConcurrentOperationCount:1];
    }
    for (InstallOperation *op in self.installQueue.operations)
    {
        if (![op isCancelled] && [op.appInfo isEqualTo:app])
        {
            return;
        }
    }
    @synchronized (self.installQueue)
    {
        if (!IS_JAILBREAKED) {
            app.status                        = LocalAppStatusNotInstall;
        }
        else{
            app.status                        = LocalAppStatusInstallingWaiting;
        }
        InstallOperation *installInstance = [[[InstallOperation alloc] init] autorelease];
        installInstance.appInfo = app;
        [self.installQueue addOperation:installInstance];
        if (post)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:IDS_INSTALL_PROXY_Install_Status_Changed object:app];
        }
    }

}

- (int)countOfInstallOperation
{
    int operationCount = 0;
    @synchronized (self.installQueue)
    {
        for (InstallOperation *op in self.installQueue.operations)
        {
            if (![op isCancelled])
            {
                if (op.appInfo.status == LocalAppStatusInstalling || op.appInfo.status == LocalAppStatusInstallingWaiting)
                {
                    operationCount++;
                }
            }
        }
    }
    return operationCount;
}
#pragma mark - 卸载相关

- (int)countOfUninstallOperation
{
    int operationCount = 0;
    @synchronized (self.uninstallQueue)
    {
        for (UninstallOperation *op in self.uninstallQueue.operations)
        {
            if (![op isCancelled])
            {
                if (op.appInfo.status == LocalAppStatusUninstalling || op.appInfo.status == LocalAppStatusUninstallingWaiting)
                {
                    operationCount++;
                }
            }
        }
    }
    return operationCount;
}

- (void)uninstallApp:(LocalAppInfo *)app
{
    [self uninstallApp:app postStatus:YES];
}


- (BOOL)cancelUnInstallApp:(LocalAppInfo *)app
{
    UnInstallingStatus status = [self queryUnInstallApp:app];
    if (status == UnInstallingStatusNotInUnInstallQueue)
    {
        return YES;
    }
    else if (status == UnInstallingStatusUnInstalling)
    {
        return NO;
    }
    else if (status == UnInstallingStatusUnInstallWaiting)
    {
        @synchronized (self.uninstallQueue)
        {
            UninstallOperation      *target = nil;
            for (UninstallOperation *operation in [self.uninstallQueue operations])
            {
                if (![operation isCancelled] && [operation.appInfo isEqualTo:app])
                {
                    target = operation;
                    break;
                }
            }
            if (target)
            {
                [target cancel];
            }
        }
    }
    return YES;
}

- (UnInstallingStatus)queryUnInstallApp:(LocalAppInfo *)app
{
    UnInstallingStatus ret = UnInstallingStatusNotInUnInstallQueue;
    @synchronized (self.uninstallQueue)
    {
        for (InstallOperation *operation in [self.uninstallQueue operations])
        {
            if (![operation isCancelled] && [operation.appInfo isEqualTo:app])
            {
                if (operation.appInfo.status == LocalAppStatusUninstallingWaiting)
                {
                    ret = UnInstallingStatusUnInstallWaiting;
                }
                else if (operation.appInfo.status == LocalAppStatusUninstalling)
                {
                    ret = UnInstallingStatusUnInstalling;
                }
                break;
            }
        }
    }
    return ret;
}

- (void)uninstallApp:(LocalAppInfo *)app postStatus:(BOOL)post
{
    if (self.uninstallQueue == nil)
    {
        self.uninstallQueue = [[[NSOperationQueue alloc] init] autorelease];
        [self.uninstallQueue setMaxConcurrentOperationCount:1];
    }
    for (InstallOperation *op in self.installQueue.operations)
    {
        if ([op.appInfo.bundleID isEqualToString:app.bundleID])
        {
            return;
        }
    }
    @synchronized (self.uninstallQueue)
    {
        app.status                            = LocalAppStatusUninstallingWaiting;
        UninstallOperation *uninstallInstance = [[[UninstallOperation alloc] init] autorelease];
        uninstallInstance.appInfo = app;
        [self.uninstallQueue addOperation:uninstallInstance];
        if (post)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:IDS_INSTALL_PROXY_Uninstall_Status_Changed object:app.bundleID];
        }
    }

}


@end