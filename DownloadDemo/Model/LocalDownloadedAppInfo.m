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

-(NSString *)getItemFileName{
    return [NSString stringWithFormat:@"%@_%ld_%@.ipa",_name,_ID,_version];
}

-(void)setItemDownloadStatus:(DownloadStatusType)status{
    switch (status) {
        case MDownloadItemStatusWaiting:
            _status=LocalAppStatusDownloadWaiting;
            break;
        case MDownloadItemStatusRequestingURL:
            _status=LocalAppStatusDownloading;
            break;
        case MDownloadItemStatusDownloading:
            _status=LocalAppStatusDownloading;
            break;
        case MDownloadItemStatusPaused:
            _status=LocalAppStatusDownloadPaused;
            break;
        case MDownloadItemStatusFailed:
            _status=LocalAppStatusDownloadFailed;
            break;
        case MDownloadItemStatusCanceled:
            _status=LocalAppStatusDownloadFailed;
            break;
        case MDownloadItemStatusCompleted:
            _status=LocalAppStatusDownloadCompleted;
            break;
        case MDownloadItemStatusError:
            _status=LocalAppStatusDownloadCheckFailed;
            break;
        default:
            break;
    }
}

@end
