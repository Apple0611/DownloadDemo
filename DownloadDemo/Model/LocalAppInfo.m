//
//  LocalAppInfo.m
//  DownjoyCenter
//
//  Created by thilong on 12-4-19.
//  Copyright 2012年 d.cn. All rights reserved.
//

#import "KeyChain/MCSMKeychainItem.h"
#import "LocalAppInfo.h"
#import "AFNetworking/AFNetworking.h"
//#import "AppMicro.h"
#import "FMDB/FMDatabase.h"
#import "AppInfoLite.h"
#import "AppInfo.h"
//#import "CodeHelper.h"
#import "CodeHelper/AppStrings.h"
#import "AppDetailInfo.h"
//#import "NSString+Base64.h"
#import "External/NSObject+External/NSString+Base64.h"
typedef enum
{
    kTDownloadItemStatusWaiting = 0,
    kTDownloadItemStatusRequestingUrl,
    kTDownloadItemStatusDownloading,
    kTDownloadItemStatusPaused,
    kTDownloadItemStatusFailed,
    kTDownloadItemStatusCompleted,
    kTDownloadItemStatusCanceled,
    kTDownloadItemStatusError,
} kTDownloadItemStatus;

@interface LocalAppInfo ()
{
    AFHTTPClient *httpClient;
}
@end

@implementation LocalAppInfo

- (id)init
{
    self = [super init];
    if (self)
    {
        self.status = LocalAppStatusNew;
    }
    return self;
}

- (void)dealloc
{
    self.ipaUrl          = nil;
    self.iconUrl         = nil;
    self.bundleID        = nil;
    self.name            = nil;
    self.englishName     = nil;
    self.version         = nil;
    self.versionNew      = nil;
    self.appPathOnDevice = nil;
    self.icon            = nil;
    self.upVersion   = nil;
    self.hatTag =nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    LocalAppInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.ID              = self.ID;
    copy.size            = self.size;
    copy.newVersionSize  = self.newVersionSize;
    copy.status          = self.status;
    copy.ipaUrl          = self.ipaUrl;
    copy.iconUrl         = self.iconUrl;
    copy.bundleID        = self.bundleID;
    copy.name            = self.name;
    copy.englishName     = self.englishName;
    copy.version         = self.version;
    copy.versionNew      = self.versionNew;
    copy.appPathOnDevice = self.appPathOnDevice;
    copy.icon            = self.icon;
    copy.upVersion   = self.upVersion;
    copy.hatTag   = self.hatTag;
    return copy;
}

- (NSString *)getSizeDescription
{
    return SizeToString(_size);
}

- (NSString *)getStatusDescription
{
    switch (_status)
    {
        case LocalAppStatusNew:
            return nil;
        case LocalAppStatusDownloadWaiting:
            return @"等待";
        case LocalAppStatusDownloading:
            return @"正在下载";
        case LocalAppStatusDownloadPaused:
            return @"下载已暂停";
        case LocalAppStatusDownloadFailed:
            return @"下载失败";
        case LocalAppStatusDownloadCompleted:
            return @"下载完成";
        case LocalAppStatusInstallingWaiting:
            return @"等待安装";
        case LocalAppStatusInstalling:
            return @"正在安装";
        case LocalAppStatusInstallFailed:
            return @"安装失败";
        case LocalAppStatusInstalled:
            if([self getLocalFilePath] == nil)
            {
                return @"已安装且包已删除";
            }
            return @"已安装";
        case LocalAppStatusUninstallingWaiting:
            return @"等待卸载";
        case LocalAppStatusUninstalling:
            return @"正在卸载";
        case LocalAppStatusUninstallFailed:
            return @"卸载失败";
        case LocalAppStatusDeletePackage:
            return @"已安装且包已删除";
        case LocalAppStatusNotInstall:
            return @"未安装";
        case LocalAppStatusDownloadCheckFailed:
            return @"下载出错";
        default:
            return nil;
    }
}

- (BOOL)isEqualTo:(LocalAppInfo *)other
{
    
    if (other && [other.bundleID isEqualToString:self.bundleID] && [other.version isEqualToString:self.version])
    {
        return YES;
    }
    return NO;
}

- (NSString *)getLocalFilePath
{
#ifdef _DEB_
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentFolder = [documentFolder stringByReplacingOccurrencesOfString:@"/root/" withString:@"/mobile/"];
#else
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#endif
    NSString *fileSavePath   = [documentFolder stringByAppendingPathComponent:[self getSaveFileName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileSavePath])
    {
        return fileSavePath;
    }
    else
    {
        return nil;
    }
}

+ (LocalAppInfo *)initWithAppInfoLite:(AppInfoLite *)appInfoLite
{
    LocalAppInfo *copy = [[[LocalAppInfo alloc] init] autorelease];
    copy.ID              = appInfoLite.ID;
    copy.name            = appInfoLite.name;
    copy.englishName     = appInfoLite.englishName;
    copy.version         = appInfoLite.version;
    copy.iconUrl         = appInfoLite.iconUrl;
    copy.size            = appInfoLite.size;
    copy.bundleID        = appInfoLite.BundleId;
    copy.ipaUrl          = appInfoLite.ipaUrl;
    copy.hatTag          = appInfoLite.hatTag;
    copy.ipaUrl          = appInfoLite.ipaUrl;
    
    copy.appPathOnDevice = nil;
    return copy;
}

+ (LocalAppInfo *)initWithAppInfo:(AppInfo *)appInfo
{
    LocalAppInfo *copy = [[[LocalAppInfo alloc] init] autorelease];
    copy.ID              = (long)[appInfo.appID longLongValue];
    copy.name            = appInfo.name;
    copy.englishName     = appInfo.englishName;
    copy.version         = appInfo.version;
    copy.iconUrl         = appInfo.icon;
    copy.size            = (long)[appInfo.size longLongValue];
    copy.bundleID        = appInfo.bundleID;
    copy.hatTag        = appInfo.hatTag;
    copy.ipaUrl         = appInfo.ipaUrl;
    copy.appPathOnDevice = nil;
    return copy;
}

+ (LocalAppInfo *)initWithDictionary:(NSDictionary *)d
{
    LocalAppInfo *copy = [[[LocalAppInfo alloc] init] autorelease];
    copy.ID              = [[d objectForKey:@"ID"] longValue];
    copy.name            = [d objectForKey:@"Name"];
    copy.englishName     = [d objectForKey:@"EnglishName"];
    copy.version         = [d objectForKey:@"Version"];
    copy.iconUrl         = [d objectForKey:@"IconUrl"];
    copy.status          = LocalAppStatusNew;
    copy.size            = 0;
    copy.bundleID        = [d objectForKey:@"BundleID"];
    copy.hatTag          = [d objectForKey:@"hatTag"];
    copy.appPathOnDevice = nil;
    return copy;
}

+ (LocalAppInfo *)appInfoWithAppDetailInfo:(AppDetailInfo *)app
{
    LocalAppInfo *copy = [[[LocalAppInfo alloc] init] autorelease];
    copy.ID              = app.ID;
    copy.name            = app.Name;
    copy.englishName     = app.EnglishName;
    copy.version         = app.Version;
    copy.iconUrl         = app.IconUrl;
    copy.size            = 0;
    copy.bundleID        = app.BundleID;
    copy.appPathOnDevice = nil;
    copy.ipaUrl          = app.IpaUrl;
    copy.hatTag          = app.hatTag;
    return copy;
}



#pragma mark 下载属性相关

- (BOOL)isDownloading
{
    return _status == LocalAppStatusDownloading;
}

- (BOOL)isPaused
{
    return _status == LocalAppStatusDownloadPaused;
}

- (int)getTDownloadQueueItemCorrespondingStatus
{
    if(_status == LocalAppStatusDownloading)
    {
        return kTDownloadItemStatusWaiting;
    }
    else if(_status == LocalAppStatusDownloadPaused || _status == LocalAppStatusDownloadCheckFailed)
    {
        return kTDownloadItemStatusPaused;
    }
    else if(_status == LocalAppStatusInstallFailed)
    {
        return kTDownloadItemStatusFailed;
    }
    return kTDownloadItemStatusWaiting;
}

- (void)setDownloadUrl:(NSString *)urlStr
{
    self.ipaUrl = urlStr;
}

- (void)setRemoteFileSize:(unsigned long)size
{
    _size = size;
}

- (void)setDownloadState:(int)downloadState
{
    if(downloadState == kTDownloadItemStatusWaiting)
    {
        _status = LocalAppStatusDownloadWaiting;
    }
    else if(downloadState == kTDownloadItemStatusRequestingUrl || downloadState == kTDownloadItemStatusDownloading)
    {
        _status = LocalAppStatusDownloading;
    }
    else if(downloadState == kTDownloadItemStatusFailed)
    {
        _status = LocalAppStatusInstallFailed;
    }
    else if(downloadState == kTDownloadItemStatusPaused)
    {
        _status = LocalAppStatusDownloadPaused;
    }
    else if(downloadState == kTDownloadItemStatusError)
    {
        _status = LocalAppStatusDownloadCheckFailed;
    }
}

- (NSURL *)getDownloadUrl
{
    if (nil == self.ipaUrl)
    {
        return nil;
    }
    return [NSURL URLWithString:self.ipaUrl];
}

- (NSString *)getSaveFileName
{
    return [self getSaveFileNameEn];

    if (_fileType == LocalAppFileTypeDocument)
    {
        return [NSString stringWithFormat:@"%ld_%@_%@.djsave", self.ID, self.name, self.version];
    }
    return [NSString stringWithFormat:@"%ld_%@_%@.ipa", self.ID, self.name, self.version];
}

-(NSString *)getSaveFileNameEn
{
    if (_fileType == LocalAppFileTypeDocument)
    {
        return [NSString stringWithFormat:@"%ld_%@_%@.djsave", self.ID, self.englishName ? [self.englishName stringByReplacingOccurrencesOfString:@" " withString:@"_"] : @"__", self.version];
    }
    return [NSString stringWithFormat:@"%ld_%@_%@.ipa", self.ID, self.englishName ? [self.englishName stringByReplacingOccurrencesOfString:@" " withString:@"_"] : @"__", self.version];
}

- (BOOL)isDownloadingMe:(id)sender
{

    LocalAppInfo *app = (LocalAppInfo *) sender;
    NSString *strTmpVersion = app.version;//当可更新的在下载列表
    if (app.versionNew) {
        strTmpVersion = app.versionNew;
    }
    NSString *strTmpVersionSelf = self.version;
    if (self.versionNew) {
        strTmpVersionSelf= self.versionNew;
    }
    if (app.ID != 0 && self.ID != 0)
    {
        if (app.ID == self.ID && [strTmpVersion isEqualToString:strTmpVersionSelf])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    if ([app.bundleID isEqualToString:self.bundleID] && [strTmpVersion isEqualToString:strTmpVersionSelf])
    {
        return YES;
    }

    return NO;
}

- (NSString *)getId
{
    return self.bundleID;
}

- (NSString *)getDownloadId
{
    return self.ID <= 0 ? nil : [NSString stringWithFormat:@"%ld", self.ID];
}

- (void)getPathForDownload
{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(self.ID), @"appid", DeviceUDID(), @"p_UniqueIdentifier", CLIENT_PARTNERS, @"p_Partners", @"2", @"type", nil];
    httpClient=[AFHTTPClient clientWithBaseURL:servicePathURL()];
    [httpClient postPath:IDS_API_appDownloadPath parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!httpClient) {
            return ;
        }
        self.ipaUrl =operation.responseString;
//        NSLog(@"%@", operation.responseString);
        [self.delegate getIpaUrlSuccessful];
        httpClient = nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (!httpClient) {
            return ;
        }
        [self.delegate getIpaUrlFaild];
        httpClient = nil;
//       NSLog(@"%@", [error description]);
    }];
}

- (void)saveDownloadedState
{
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    LocalAppInfo *app = self;
    
    [db executeUpdate:IDS_DATABASE_Replace_Downloaded_Cache,
                      @(app.ID), @(app.size), @(app.newVersionSize), @(app.status),
                      app.ipaUrl, app.iconUrl, app.bundleID, app.name, app.englishName,
                      app.version, app.versionNew, app.appPathOnDevice, @(app.fileType),app.versionTMP];
    [db close];
}

- (void)removeDownloadedState
{
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    LocalAppInfo *app = self;
    [db executeUpdate:IDS_DATABASE_Delete_Downloaded_Cache, app.bundleID ? app.bundleID : NULL, app.version ? app.version : NULL, @(app.fileType)];
    [db close];
}

- (NSString *)getMetadataFileName
{
    return [NSString stringWithFormat:@"%ld__%@.plist",self.ID,self.version];
}

- (void)saveDownloadingState
{
    if (self.name.length == 0 && self.bundleID.length == 0) {
        return;
    }
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    LocalAppInfo *app = self;
    if (app.versionNew) {
        app.version = app.versionNew;
    }
    [db executeUpdate:IDS_DATABASE_Replace_Downloading_Cache,
                      @(app.ID), @(app.size), @(app.newVersionSize), @(app.status),
                      app.ipaUrl, app.iconUrl, app.bundleID, app.name, app.englishName,
                      app.version, app.versionNew, app.appPathOnDevice, @(app.fileType),app.versionTMP];

    [db close];
}

- (void)downloadCanceled 
{
    httpClient = nil;
    [self downloadComplete];
}

- (void)downloadComplete
{
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    LocalAppInfo *app = self;
    [db executeUpdate:IDS_DATABASE_Delete_Downloading_Cache, app.bundleID, app.version, @(app.fileType)];
    [db close];
}


//-- xiaojun 2013.12.18
// 获取app的https plist下载信息的base64编码  b_hacked  是否越狱  0为越狱 1为非越狱
-(NSString*) getAppBase64InfoOfHttpsPlist:(BOOL) b_hacked
{
    NSString *strHacked= b_hacked?@"0":@"1";
    NSString *str= [NSString stringWithFormat:@"%ld|%@|%@|%@",self.ID,[self getSaveFileNameEn],self.version,strHacked];
    
    NSString *lTmp = [NSString stringWithFormat:@"%c",'\n'];
    NSString * result = [[str base64String] stringByReplacingOccurrencesOfString:lTmp withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    result = (NSString*)CFURLCreateStringByAddingPercentEscapes(nil,
                                                                          (CFStringRef)result, nil,
                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]|", kCFStringEncodingUTF8);
    return result;
}
@end
