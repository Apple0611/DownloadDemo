//  UninstallOperation
//  DownjoyCenterV2.0
//
//  Created by thilong on 13-4-27.
//  Copyright (c) 2012 thilong.tao. All rights reserved.
//  Description: 


#import "UninstallOperation.h"
#import "LocalAppInfo.h"
#import "TApplicationManager.h"
#import "CodeHelper/AppStrings.h"


@implementation UninstallOperation

- (void)main
{
    if (self.isCancelled || _appInfo == nil)
    {
        return;
    }
    _appInfo.status = LocalAppStatusUninstalling;
    dispatch_sync(
            dispatch_get_main_queue(), ^
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:IDS_INSTALL_PROXY_Uninstall_Status_Changed object:_appInfo.bundleID userInfo:nil];
            });
    BOOL result = [[TApplicationManager sharedManager] uninstallApp:_appInfo];
    sleep(1);
    if (result)
    {
        _appInfo.status = LocalAppStatusDeleted;
    }
    else
    {
        _appInfo.status = LocalAppStatusUninstallFailed;
    }
    dispatch_sync(
            dispatch_get_main_queue(), ^
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:IDS_INSTALL_PROXY_Uninstall_Complete object:_appInfo.bundleID userInfo:nil];
            });
}

- (void)dealloc
{
    self.appInfo = nil;
    [super dealloc];
}
@end