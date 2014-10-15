//  InstallOperation
//  DownjoyCenterV2.0
//
//  Created by thilong on 13-4-27.
//  Copyright (c) 2012 thilong.tao. All rights reserved.
//  Description: 


#import "InstallOperation.h"
#import "LocalAppInfo.h"
#import "TApplicationManager.h"
#import "CodeHelper/AppStrings.h"


@implementation InstallOperation

- (void)main
{
    
    if (self.isCancelled || _appInfo==nil)
    {
        return;
    }
    if (!IS_JAILBREAKED) {
         [[TApplicationManager sharedManager] installApp:_appInfo];
    }
    else{
        _appInfo.status = LocalAppStatusInstalling;
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [[NSNotificationCenter defaultCenter] postNotificationName:IDS_INSTALL_PROXY_Install_Status_Changed object:nil userInfo:nil];
                      });
        
        _appInfo.status = [[TApplicationManager sharedManager] installApp:_appInfo];
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [[NSNotificationCenter defaultCenter] postNotificationName:IDS_INSTALL_PROXY_Install_Complete object:_appInfo.bundleID userInfo:nil];
                      });
    }
}
-(void)setStatusAfterdeletePack{
    _appInfo.status = LocalAppStatusDeletePackage;
}
- (void)dealloc
{
    [_appInfo release];
    [super dealloc];
}
@end