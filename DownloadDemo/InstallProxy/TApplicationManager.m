//
//  TApplicationManager.m
//  DownjoyCenter
//
//  Created by thilong on 12-4-19.
//  Copyright 2012年 d.cn. All rights reserved.
//

#import "TApplicationManager.h"
#import "Objective-Zip/FileInZipInfo.h"
#import "Objective-Zip/ZipReadStream.h"
#import "LocalAppInfo.h"
//#import "ASIFormDataRequest.h"
//#import "AppMicro.h"
//#import "CodeHelper.h"
#import "CodeHelper/AppStrings.h"
#import "GDataXMLNode.h"
#import "AppInfoParser.h"
#import "FMDB/FMDatabase.h"
#import "AppDelegate.h"
#import "AppSetting.h"
//#import "UIAlertView+Blocks.h"
//#import "NSDictionary+SafeObjectForKey.h"
#import "AppInfoLite.h"
#import "Tools.h"
#import "AppGlobal.h"


typedef NSDictionary *(*PMobileInstallationLookup)(NSDictionary *params, id callBack_unknown_usage);

typedef int __unused (*SBSLaunchApplicationWithIdentifier)(CFStringRef displayIdentifier, Boolean suspended);

@interface NSString(compaire)

-(NSComparisonResult)compareVersion:(NSString *)string options:(NSStringCompareOptions)mask;

@end

@implementation  NSString(compaire)

-(NSComparisonResult)compareVersion:(NSString *)string options:(NSStringCompareOptions)mask
{
    NSArray *v1A = [[self stringByReplacingOccurrencesOfString:@" " withString:@"" ] componentsSeparatedByString:@"."];
    NSArray *v2A = [[string stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"."];
    
    NSMutableArray *v1AM = [NSMutableArray arrayWithArray:v1A];
    NSMutableArray *v2AM = [NSMutableArray arrayWithArray:v2A];
    for(int i=4;i>0;i--)
    {
        if(v1AM.count < 4)
            [v1AM addObject:@"0"];
        if(v2AM.count < 4)
            [v2AM addObject:@"0"];
    }
    NSString *fStr1 = [v1AM componentsJoinedByString:@"."];
    NSString *fStr2 = [v2AM componentsJoinedByString:@"."];
    return [fStr1 compare:fStr2 options:mask];
}

@end

@interface TApplicationManager ()


//#ifdef OFFICAL_VERSION
-(void)prepareInstallPackage:(LocalAppInfo *)app;
-(void)prepareInstallMetadata:(LocalAppInfo *)app;
//#endif

+ (NSMutableArray *)IPAInstalled:(NSArray *)wanted;

- (void)refreshInstalledApp:(NSString *)bundleId forApp:(LocalAppInfo *)app byApps:(NSArray *)byApps;

@end

@implementation TApplicationManager
//static NSMutableArray *_arraySearchString;

+ (TApplicationManager *)sharedManager
{
    static TApplicationManager *_sharedManager;
    if (nil == _sharedManager)
    {
        _sharedManager = [[TApplicationManager alloc] init];
    }
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        ADD_NOTIFICATION(@"kReachabilityChangedNotification", @selector(checkAppUpgrade:), nil);
    }
    return self;
}

- (void)dealloc
{
    [_installedApps release];
    [super dealloc];
}

- (void)updateInstalledApp:(NSString *)appBundleId appId:(long)appID ipaUrl:(NSString *)ipaUrl iconUrl:(NSString *)iconUrl
{
    if (_installedApps == nil || [_installedApps count] == 0)
    {
        return;
    }
    @synchronized (_installedApps)
    {
        for (LocalAppInfo *app in _installedApps)
        {
            if ([app.bundleID isEqualToString:appBundleId])
            {
                app.iconUrl = iconUrl;
                app.ID      = appID;
                app.ipaUrl  = ipaUrl;
            }
        }
    }
}

#pragma mark - 已安装处理

- (NSMutableArray *)installedApplications:(NSArray *)wanted reScan:(BOOL)scan readStatus:(InstalledApplicationReadStatus *)readStatus
{
    BOOL shouldScan = scan;
    if(readStatus)
        *readStatus = InstalledApplicationReadStatusDown;
    if (_installedApps == nil)
    {
        self.installedApps = [[[NSMutableArray alloc] init] autorelease];
        shouldScan = YES;
    }
    if (shouldScan)
    {
        if(readStatus)
            *readStatus = InstalledApplicationReadStatusReading;
        dispatch_queue_t queue = dispatch_queue_create("get_installed_applications_queue", NULL);
        __block __weak TApplicationManager *weakManager = self;
        dispatch_async(
                       queue, ^
                       {
                           NSArray *curInstalled = [TApplicationManager IPAInstalled:nil];
                           if(weakManager.installedApps.count == 0)
                           {
                               [weakManager.installedApps addObjectsFromArray:curInstalled];
                           }
                           else
                           {
                               @synchronized (weakManager.installedApps){
                                   for(int i=weakManager.installedApps.count ;i>0;i--)
                                   {
                                       LocalAppInfo * app = weakManager.installedApps[i-1];
                                       BOOL inInstalled = NO;
                                       for(LocalAppInfo * iapp in curInstalled)
                                       {
                                           if([app.bundleID isEqualToString:iapp.bundleID])
                                           {
                                               app.version = iapp.version;
                                               
                                               inInstalled = YES;
                                               break;
                                           }
                                       }
                                       if(!inInstalled)
                                       {
                                           [weakManager.installedApps removeObject:app];
                                       }
                                   }
                                   for(LocalAppInfo * iapp in curInstalled)
                                   {
                                       BOOL newInstall = YES;
                                       for(LocalAppInfo * app in weakManager.installedApps )
                                       {
                                           if([app.bundleID isEqualToString:iapp.bundleID])
                                           {
                                               newInstall = NO;
                                               break;
                                           }
                                       }
                                       if(newInstall)
                                       {
                                           [weakManager.installedApps addObject:iapp];
                                       }
                                   }
                               }
                           }
                           dispatch_async(
                                          dispatch_get_main_queue(), ^
                                          {
                                              POST_NOTIFICATION(IDS_INSTALL_PROXY_App_Refreshed, nil);
                                          });
                           // yyt 2014.7.11
                           dispatch_queue_t queue = dispatch_queue_create("update apps", NULL);
                           dispatch_async(queue, ^{
                               [self checkAppUpgrade:nil];
                           });
                       });
        dispatch_release(queue);
    }
    return _installedApps;
}


- (void)refreshInstalledApp:(NSString *)bundleId forApp:(LocalAppInfo *)app
{
    NSMutableArray *apps = [TApplicationManager IPAInstalled:@[bundleId]];
    [self refreshInstalledApp:bundleId forApp:app byApps:apps];
}

- (void)refreshInstalledApp:(NSString *)bundleId forApp:(LocalAppInfo *)app byApps:(NSArray *)byApps
{
    if (byApps && byApps.count > 0)
    {
        @synchronized (_installedApps)
        {
            for (LocalAppInfo *tiApp in byApps)
            {
                BOOL inInstalled = NO;
                for (LocalAppInfo *iApp in _installedApps)
                {
                    if ([iApp.bundleID isEqualToString:tiApp.bundleID])
                    {
                        iApp.version = tiApp.version;
                        inInstalled = YES;
                        if ([iApp.bundleID isEqualToString:app.bundleID])
                        {
                            iApp.ID      = app.ID;
                            iApp.ipaUrl  = app.ipaUrl;
                            iApp.iconUrl = app.iconUrl;
                        }
                        break;
                    }
                }
                if (!inInstalled)
                {
                    if (tiApp.icon == nil)
                    {
                        tiApp.icon = [self appIcon:tiApp.bundleID];
                    }
                    if ([tiApp.bundleID isEqualToString:app.bundleID])
                    {
                        tiApp.ID      = app.ID;
                        tiApp.ipaUrl  = app.ipaUrl;
                        tiApp.iconUrl = app.iconUrl;
                    }
                    [_installedApps addObject:tiApp];
                }
            }
        }
    }
}

- (BOOL)uninstallApp:(LocalAppInfo *)app
{
    typedef int (*MobileInstallationUninstall)(NSString *appId, NSDictionary *dict, void *callback);
    
    if ([app bundleID] == nil)
    {
        return NO;
    }
    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib)
    {
        MobileInstallationUninstall pMobileInstallationUninstall = (MobileInstallationUninstall) dlsym(lib, "MobileInstallationUninstall");
        if (pMobileInstallationUninstall)
        {
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"User", @"ApplicationType", nil];
            int ret = pMobileInstallationUninstall(app.bundleID, params, nil);
            if (ret == 0)
            {
                LocalAppInfo *shouldRemove = nil;
                @synchronized (self.installedApps)
                {
                    
                    for (LocalAppInfo *installedAppItem in self.installedApps)
                    {
                        if ([installedAppItem.bundleID isEqualToString:app.bundleID])
                        {
                            shouldRemove = installedAppItem;
                        }
                    }
                    if (shouldRemove)
                    {
                        [self.installedApps removeObject:shouldRemove];
                    }
                }
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)importDoc:(NSString *)appPath appId:(NSString *)appId
{

    bool isDEB = [NSHomeDirectory() rangeOfString:@"/mobile/Application"].location == NSNotFound;
    
    bool existsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:appPath];
    if (existsAtPath && appId != nil && [appId class] != [NSNull class] && appId.length > 0)
    {
        NSMutableArray    *installed      = [TApplicationManager IPAInstalled:[NSArray arrayWithObjects:appId, nil]];
        LocalAppInfo      *currentInstall = nil;
        for (LocalAppInfo *lapp in installed)
        {
            if ([lapp.bundleID isEqualToString:appId])
            {
                currentInstall = lapp;
            }
        }

        if (currentInstall != nil && currentInstall.appPathOnDevice != nil)
        {
            NSString *rootPathOnDevice = [NSString stringWithString:currentInstall.appPathOnDevice];
            NSRange range = [rootPathOnDevice rangeOfString:[rootPathOnDevice lastPathComponent]];
            NSRange pathRange;
            pathRange.location = 0;
            pathRange.length   = range.location;
            NSString *rootPath = [rootPathOnDevice substringWithRange:pathRange];
            ZipFile  *unz      = [[ZipFile alloc] initWithFileName:appPath mode:ZipFileModeUnzip];
            
            if (unz == nil)
            {
                return NO;
            }
            [unz goToFirstFileInZip];
            do
            {
                FileInZipInfo *unzFileInfo = [unz getCurrentFileInZipInfo];
                //                NSLog(@"name=%@",unzFileInfo.name);
                NSRange testRange = [unzFileInfo.name rangeOfString:@"Container/"];
                if (testRange.location != 0 || testRange.length != 10)
                {
                    continue;
                }
                if ([unzFileInfo.name isEqualToString:@"Container/Library/"] ||
                    [unzFileInfo.name isEqualToString:@"Container/Documents/"] ||
                    [unzFileInfo.name isEqualToString:@"Container/tmp/"] ||
                    [unzFileInfo.name isEqualToString:@"Container/"])
                {
                    continue;
                }
                //                NSLog(@"name=%@",unzFileInfo.name);
                NSRange lastCharRange;
                lastCharRange.length   = 1;
                lastCharRange.location = unzFileInfo.name.length - 1;
                NSString *lastChar = [unzFileInfo.name substringWithRange:lastCharRange];
                NSRange unzFileNameRange = {10, unzFileInfo.name.length - 10};
                NSString *unzFileName    = [unzFileInfo.name substringWithRange:unzFileNameRange];
                NSString *targetFilePath = [rootPath stringByAppendingPathComponent:unzFileName];
                if ([lastChar isEqualToString:@"/"])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:targetFilePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                else
                {
                    ZipReadStream *unzReader  = [unz readCurrentFileInZip];
                    NSMutableData *uzFileData = [[NSMutableData alloc] initWithLength:unzFileInfo.length];
                    int readed = [unzReader readDataWithBuffer:uzFileData];
                    if (readed == unzFileInfo.length)
                    {
                        [uzFileData writeToFile:targetFilePath atomically:YES];
                    }
                    [uzFileData release];
                    [unzReader finishedReading];
                }
                //如果是deb版导入存档后还要修改用户组
                if(isDEB) {
                    system([NSString stringWithFormat:@"chown mobile \"%@\"",targetFilePath].UTF8String);
                }
            } while ([unz goToNextFileInZip]);
            [unz close];
            [unz release];
            
        }
        return YES;
    }
    return NO;
    
}
void _installCallBack(NSDictionary *dic, int art)
{
    
    
}

- (LocalAppStatus)installApp:(LocalAppInfo *)app
{
    if (!IS_JAILBREAKED) {
        if(![AppDelegate sharedDelegate].installProxyStarted)
        {
            [[AppDelegate sharedDelegate] beginHttpServer];
        }
        BOOL b_hacked=NO;
        if (IS_JAILBREAKED) {
            b_hacked = YES;
        }
        NSString *strAppInfoBase64=[app getAppBase64InfoOfHttpsPlist:b_hacked];
        //https plist下载
        NSString *installProxyUrl=[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@custom-%@.plist", HTTPS_SERVER_ADDRESS, strAppInfoBase64];
        //    NSString *installProxyUrl=[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@d.cn.installapp/%@", HTTP_SERVER_ADDRESS, [app getMetadataFileName]];
        
        //    NSLog(@"plist  address=%@",installProxyUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installProxyUrl]];
        return LocalAppStatusInstalled;
    }
    typedef int (*MobileInstallationInstall)(NSString *path, NSDictionary *dict, void *na, NSString *path2_equal_path_maybe_no_use);
    
    BOOL finalResult = NO;
    
    @try {
        void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
        if (lib)
        {
            MobileInstallationInstall pMobileInstallationInstall = (MobileInstallationInstall) dlsym(lib, "MobileInstallationInstall");
            
            NSString *ipaPath     = [app getLocalFilePath];
            NSString *realIpaPath = ipaPath;
            if (pMobileInstallationInstall)
            {
                if (nil == ipaPath)
                {
                    app.status=LocalAppStatusDeletePackage;
                    dlclose(lib);
                    return LocalAppStatusInstallFailed;
                }
                do
                {
                    BOOL isBtIPA = NO;
                    ZipFile *unz = [[ZipFile alloc] initWithFileName:ipaPath mode:ZipFileModeUnzip];
                    if (unz == nil)
                    {
                        finalResult = NO;
                        break;
                    }
                    [unz goToFirstFileInZip];
                    do
                    {
                        FileInZipInfo *unzFileInfo = [unz getCurrentFileInZipInfo];
                        NSRange testRange = [unzFileInfo.name rangeOfString:@"Container/"];
                        if (testRange.location != 0 || testRange.length != 10)
                        {
                            continue;
                        }
                        else
                        {
                            isBtIPA = YES;
                            break;
                        }
                    } while ([unz goToNextFileInZip]);
                    [unz close];
                    [unz release];
                    //是否备份安装包
                    if (![[AppSetting sharedSetting] getDeletePackageAfterInstall])
                    {
                        ipaPath = [ipaPath stringByAppendingPathExtension:@"temp.ipa"];
                        NSError *_error=nil;
                        if (NO == [[NSFileManager defaultManager] copyItemAtPath:realIpaPath toPath:ipaPath error:&_error])
                        {
                            NSLog(@"%@",[_error localizedDescription]);
                            finalResult = false;
                            //                        break;
                        }
                    }
                    int ret = pMobileInstallationInstall(ipaPath, [NSDictionary dictionaryWithObject:@"User" forKey:@"ApplicationType"], _installCallBack, ipaPath);
                    
                    if (ret == 0 && (nil != app.bundleID))
                    {
                        [self importDoc:realIpaPath appId:app.bundleID];
                    }
                    if (!isBtIPA&&[[AppSetting sharedSetting] getDeletePackageAfterInstall])
                    {
                        [[NSFileManager defaultManager] removeItemAtPath:realIpaPath error:nil];
                    }
                    finalResult = (ret == 0);
                    if (finalResult && app.bundleID)
                    {
                        sleep(1);
                        [self refreshInstalledApp:app.bundleID forApp:app];
                    }
                } while (false);
            }
            dlclose(lib);
        }
        
    }
    @catch (NSException *exception) {
        finalResult = false;
    }
    @finally {
        
    }
    
    //    return finalResult;
    if (finalResult) {
        if ([[AppSetting sharedSetting] getDeletePackageAfterInstall]){
            return LocalAppStatusDeletePackage;
        }
        else  return LocalAppStatusInstalled;
    }
    else return LocalAppStatusInstallFailed;
}

//是否已经安装过此app
- (BOOL)isAppInstalled:(LocalAppInfo *)app
{
    BOOL inInstalled = NO;
    @synchronized (_installedApps){
        for (LocalAppInfo *iApp in _installedApps)
        {
//             NSLog(@"%@:%@\n%@:%@\n%@:%@", app.name, iApp.name, app.bundleID, iApp.bundleID, app.version, iApp.version);
            if ([iApp.bundleID isEqualToString:app.bundleID] && [iApp.version isEqualToString:app.version])
            {
                inInstalled = YES;
                break;
            }
        }
    }
    return inInstalled;
}

- (BOOL)archiveApp:(NSString *)appId __unused
{
    typedef int (*MobileInstallationArchive)(NSString *appId, NSDictionary *cmd);
    
    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib)
    {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        //[dic setValue:@"ApplicationOnly" forKey:@"ArchiveType"];
        //[dic setValue:YES   forKey:@"SkipUninstall"];
        //NSString* temp = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ii.ipa"];
        MobileInstallationArchive pFunc = (MobileInstallationArchive) dlsym(lib, "MobileInstallationArchive");
        if (pFunc)
        {
            int ret = pFunc(appId, dic);
            return ret == 0 ? YES : NO ;
        }
    }
    return NO;
}

- (BOOL)restoreApp:(__unused NSString *)appId __unused
{
    
    return NO;
}

- (BOOL)removeArchive:(__unused NSString *)appId __unused
{
    return NO;
}

+ (NSMutableArray *)IPAInstalled:(NSArray *)wanted
{
    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib)
    {
        PMobileInstallationLookup pMobileInstallationLookup = (PMobileInstallationLookup) dlsym(lib, "MobileInstallationLookup");
        if (pMobileInstallationLookup)
        {
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"User", @"ApplicationType", wanted
                                    , @"BundleIDs", nil];
            NSDictionary *dict   = pMobileInstallationLookup(params, NULL);
            if (dict == nil)
            {
                return nil;
            }
            NSMutableArray *appList     = [NSMutableArray new];
            NSString       *appBundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleIdentifierKey];
            for (int i = 0; i < [[dict allKeys] count]; i++)
            {
                NSDictionary *appInfo            = [dict objectForKey:[[dict allKeys] objectAtIndex:i]];
                NSString     *cfBundleIdentifier = [appInfo objectForKey:@"CFBundleIdentifier"];
                if (cfBundleIdentifier != nil && [cfBundleIdentifier isEqualToString:appBundleID])
                {
                    continue;
                }
//                if ([appInfo objectForKey:@"CFBundleDisplayName"] != nil || [appInfo objectForKey:@"CFBundleName"] != nil)
//                {
                
                    LocalAppInfo *app = [[LocalAppInfo alloc] init];
                    app.bundleID = [appInfo objectForKey:@"CFBundleIdentifier"];
                    NSString *shortVersion  = [appInfo objectForKey:@"CFBundleShortVersionString"];
                    NSString *bundleVersion = [appInfo safeObjectForKey:@"CFBundleVersion"];
                    
                    if(shortVersion && [shortVersion isKindOfClass:[NSString class]])
                    {
                        app.version         =[shortVersion stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                    else if(bundleVersion && [bundleVersion isKindOfClass:[NSString class]])
                    {
                        app.version         =[bundleVersion stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                    
                    app.name            = [[TApplicationManager sharedManager] appLocalizedName:app.bundleID];
                    app.icon            = [[TApplicationManager sharedManager] appIcon:app.bundleID];
                    app.appPathOnDevice = [appInfo objectForKey:@"Path"];
                    if (![app.version isKindOfClass:[NSString class]])
                    {
                        app.version = [app.version description];
                    }
                    [appList addObject:app];
                    [app release];
//                }
            }
            [appList autorelease];
            return appList;
        }
    }
    
    return nil;
}

- (NSString *)appLocalizedName:(NSString *)identifier
{
    typedef NSString *(*SBSCopyLocalizedApplicationNameForDisplayIdentifier)(NSString *identifier);
    
    void *lib = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
    if (lib)
    {
        SBSCopyLocalizedApplicationNameForDisplayIdentifier pSBSCopyLocalizedApplicationNameForDisplayIdentifier = (SBSCopyLocalizedApplicationNameForDisplayIdentifier) dlsym(lib, "SBSCopyLocalizedApplicationNameForDisplayIdentifier");
        return pSBSCopyLocalizedApplicationNameForDisplayIdentifier(identifier);
    }
    return nil;
}

- (UIImage *)appIcon:(NSString *)appID
{
    typedef NSData *(*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString *identifier);
    
    void *lib = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
    if (lib)
    {
        SBSCopyIconImagePNGDataForDisplayIdentifier pSBSCopyIconImagePNGDataForDisplayIdentifier = (SBSCopyIconImagePNGDataForDisplayIdentifier) dlsym(lib, "SBSCopyIconImagePNGDataForDisplayIdentifier");
        NSData *data = pSBSCopyIconImagePNGDataForDisplayIdentifier(appID);
        if (data == nil || data.length == 0)
        {
            return nil;
        }
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }
    return nil;
}

- (BOOL)launchApplication:(NSString *)appID __unused
{
    return YES;
}

#pragma mark - 应用更新相关

- (NSArray *)appNeedUpgrade
{
    NSMutableArray *result = [[NSMutableArray new] autorelease];
    @synchronized (_installedApps)
    {
        for (LocalAppInfo *app in _installedApps)
        {
//            if (app.versionNew != nil && [app.versionNew compareVersion:app.version options:NSNumericSearch] == NSOrderedDescending)
//            {
//                [result addObject:app];
//            }
            if (app.versionNew != nil && [AppGlobal versionCompareWithArray:@[app.versionNew, app.version]])
            {
                [result addObject:app];
            }
        }
    }
    
    return result;
}

- (void)checkAppUpgrade:(NSArray *)wanted
{
    NSMutableString *appBundleIds = [[[NSMutableString alloc] init] autorelease];
    
    NSMutableArray     *apps           = _installedApps;
    @synchronized (_installedApps)
    {
        for (LocalAppInfo *app in apps)
        {
            if (wanted == nil || ![wanted isKindOfClass:[NSArray class]])
            {
                [appBundleIds appendString:app.bundleID];
                [appBundleIds appendString:@";"];
            }
            else
            {
                for (NSString *appId in wanted)
                {
                    if ([appId isEqualToString:app.bundleID])
                    {
                        [appBundleIds appendString:app.bundleID];
                        [appBundleIds appendString:@";"];
                    }
                }
            }
        }
    }
    NSMutableDictionary *dictionary;
    if (IS_JAILBREAKED) {
        dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:appBundleIds, @"BundleId", CLIENT_PLATFORM, @"client", isHD(), @"ishd",  nil];
    }
    else{
        dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:appBundleIds, @"BundleId", CLIENT_PLATFORM, @"client", isHD(), @"ishd", AUTHORISED_FLAG, @"authorised", nil];
    }
    
    [[AFHTTPClient clientWithBaseURL:servicePathURL()] postPath:IDS_API_upgradeAppByJson parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicJsonData = [operation.responseString objectFromJSONString];
        NSArray *liteApps = [AppInfoParser appLitesFromUpdateInfo:dicJsonData];
        @synchronized (_installedApps)
        {
            for (AppInfoLite *lApp in liteApps)
            {
                for (LocalAppInfo *app in _installedApps)
                {
                    if ([app.bundleID isEqualToString:lApp.BundleId])
                    {
                        app.iconUrl        = lApp.iconUrl;
                        app.ipaUrl         = lApp.ipaUrl;
                        app.ID             = lApp.ID;
                        app.newVersionSize = lApp.size;
                        app.versionNew     = lApp.version;
                        app.upVersion = lApp.version;
                        app.name           = lApp.name;
                        app.neewFeature = lApp.newFeature;
                        app.hatTag = lApp.hatTag;
                        break;
                    }
                }
            }
        }
        POST_NOTIFICATION(IDS_INSTALL_PROXY_Check_Upgrade_Complete, nil);

        if([[AppSetting sharedSetting] getShowDesktopBadge]){
            NSArray *canUpdateApps = [[TApplicationManager sharedManager] appNeedUpgrade];
            [UIApplication sharedApplication].applicationIconBadgeNumber = canUpdateApps.count;
        }
        else
        {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        POST_NOTIFICATION(IDS_INSTALL_PROXY_Check_Upgrade_Failed, nil);
    }];
}
//搜索相关
+ (NSMutableArray *)searchArray
{
    NSMutableArray * _arraySearchString = [[[NSMutableArray alloc] init] autorelease];
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    FMResultSet *rs = [db executeQuery:SQL_QUERY_SEARCH_HISTORY_CACHE];
    if (rs != nil)
    {
        while ([rs next])
        {
            NSString *namestr = [rs stringForColumn:@"name"];
            NSString *codestr = [rs stringForColumn:@"code"];
            NSString * searchtype =[NSString stringWithFormat:@"%d", [[rs stringForColumn:@"type"]intValue]];
            NSArray *objArray=[[NSArray alloc]initWithObjects:codestr,namestr,searchtype, nil];
            NSArray *keysArray=[[NSArray alloc]initWithObjects:@"code",@"name",@"type", nil];
            NSDictionary *dic=[[NSDictionary alloc]initWithObjects:objArray forKeys:keysArray];
            if(namestr)
            {
                [_arraySearchString addObject:dic];
            }
            [dic release];
        }
    }
    [db close];
    return _arraySearchString;
}

+ (void)removeSigleHistory:(NSString *)_str
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    [db executeUpdate:IDS_DATABASE_Delete_Search_History_Cache,_str];
    [db close];
}
+ (void)removeAllHistory
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    [db executeUpdate:SQL_CLEAN_SEARCH_HISTORY_CACHE];
    [db close];
}

+ (void)addSearchHistoryToArray:(NSString*) code searchname:(NSString*)name searchtype:(int)type
{
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    [db open];
    [db executeUpdate:IDS_DATABASE_Replace_Search_History_Cache,code,name,@(type)];
    [db close];
}

//保存历史搜索记录
+(void)saveSearchHistory{
    /*
     FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
     [db open];
     //搜索记录
     [db executeUpdate:SQL_CLEAN_SEARCH_HISTORY_CACHE];
     for (NSString *str in _arraySearchString)
     {
     [db executeUpdate:SQL_SAVE_SEARCH_HISTORY_CACHE,
     str];
     }
     [db close];*/
}

-(void)prepareInstallPackage:(LocalAppInfo *)app
{
    return;
    NSString *basePath = AppServerPath();
    NSString *toPath = [basePath stringByAppendingPathComponent:[app getSaveFileNameEn]];
    [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
    [[NSFileManager defaultManager] copyItemAtPath:[app getLocalFilePath] toPath:toPath error:nil];
}

-(void)prepareInstallMetadata:(LocalAppInfo *)app
{
    NSString *proxyFileName = [app getMetadataFileName];
    NSString *basePath = AppServerPath();
    NSString *toPath = [[basePath stringByAppendingPathComponent:@"d.cn.installapp"] stringByAppendingPathComponent:proxyFileName];
    NSString *fromPath = [[NSBundle mainBundle] pathForResource:@"proxy" ofType:@"plist"];
    [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
    if (![[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:nil]) {
        return;
    }
    
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:toPath];
    NSMutableDictionary *usePlist = [[plist objectForKey:@"items"] objectAtIndex:0];
    NSMutableDictionary *dicHttp =  [[usePlist objectForKey:@"assets"] objectAtIndex:0];
    
    //2013-12-16,by xiaojun
    NSString *iconName = [NSString stringWithFormat:@"%@.png",app.version];
    NSString *iconLocalPath = [basePath stringByAppendingPathComponent:@"d.cn.installapp"] ;
    saveImagewithFileNameofType(app.icon
                                , app.version
                                , @"png"
                                , iconLocalPath);
    NSString *icon127Path = [NSString stringWithFormat:@"%@%@", HTTP_SERVER_ADDRESS,iconName];
    NSMutableDictionary *dicHttpDisplay =  [[usePlist objectForKey:@"assets"] objectAtIndex:1];
    [dicHttpDisplay setObject:icon127Path forKey:@"url"];
    
    NSMutableDictionary *dicHttpFullSize =  [[usePlist objectForKey:@"assets"] objectAtIndex:2];
    [dicHttpFullSize setObject:icon127Path forKey:@"url"];
    //2013-12-16,by xiaojun
    
    
    NSString *appPath = [NSString stringWithFormat:@"%@%@", HTTP_SERVER_ADDRESS, [app getSaveFileNameEn]];
    [dicHttp setObject:appPath forKey:@"url"];
    NSMutableDictionary *dicInfo = [usePlist objectForKey:@"metadata"];
    
    [dicInfo setObject:app.bundleID forKey:@"bundle-identifier"];
    [dicInfo setObject:app.version forKey:@"bundle-version"];
    [dicInfo setObject:app.name forKey:@"subtitle"];
    [dicInfo setObject:app.name forKey:@"title"];
    [plist writeToFile:toPath atomically:YES];
}

@end
