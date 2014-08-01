//
//  LocalDownloadedAppInfo.h
//  DownloadDemo
//
//  Created by downjoymac on 14-7-30.
//  Copyright (c) 2014年 Apple0611. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfo.h"
#import "DYMicro.h"

@interface LocalDownloadedAppInfo:NSObject

@property(nonatomic) long           ID;

@property(nonatomic) long           size;

@property(nonatomic) long           newVersionSize;

@property(nonatomic) LocalAppStatus status;

@property(nonatomic, strong) NSString *ipaUrl;

@property(nonatomic, strong) NSString *iconUrl;

@property(nonatomic, strong) NSString *bundleID;

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *englishName;

@property(nonatomic, strong) NSString *version;

@property(nonatomic, strong) NSString *versionNew;

@property(nonatomic, strong) NSString *appPathOnDevice;

@property(nonatomic, retain) UIImage  *icon;


-(NSString *)getItemFileSavaPath;

-(void)setItemDownloadStatus:(DownloadStatusType)status;

-(NSURL *)getDownLoadItemIpaURL;

@end
