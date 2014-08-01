//
//  LocalDownloadedAppInfo.m
//  DownloadDemo
//
//  Created by downjoymac on 14-7-30.
//  Copyright (c) 2014年 Apple0611. All rights reserved.
//

#import "LocalDownloadedAppInfo.h"

@implementation LocalDownloadedAppInfo

-(void)dealloc{
    self.ipaUrl          = nil;
    self.iconUrl         = nil;
    self.bundleID        = nil;
    self.name            = nil;
    self.englishName     = nil;
    self.version         = nil;
    self.versionNew      = nil;
    self.appPathOnDevice = nil;
    self.icon            = nil;
    [super dealloc];
}

@end
