//
//  AppInfo.m
//  DownloadDemo
//
//  Created by downjoymac on 14-7-30.
//  Copyright (c) 2014年 Apple0611. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo


- (void)dealloc
{
    self.BundleId            = nil;
    self.name                = nil;
    self.englishName         = nil;
    self.appStoreID          = nil;
    self.appStoreUrl         = nil;
    self.version             = nil;
    self.iconUrl             = nil;
    self.categoryName        = nil;
    self.categoryEnglishName = nil;
    self.modifyTime          = nil;
    self.tags                = nil;
    self.ipaUrl              = nil;
    self.chineseDescription  = nil;
    self.priceUnit           = nil;
    self.originalPrice       = nil;
    [super dealloc];
}

- (NSString *)sizeFormat:(NSString *)size
{
    if ([@"" isEqualToString:size])
    {
        return nil;
    }
    NSString *arrangedSize;
    if (([size floatValue] / 1024.0f) > 1.0f)
    {
        arrangedSize = [NSString stringWithFormat:@"%.2fGB", [size floatValue] / 1024.0f];
    }
    else
    {
        arrangedSize = [NSString stringWithFormat:@"%.1fMB", [size floatValue]];
    }
    return arrangedSize;
}

- (NSString *)countFormat:(long) count
{
    if (count > 10000)
    {
        return [NSString stringWithFormat:@"%.2f万次下载", count / 10000.0f];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld次下载", count];
    }
}

- (int) appStarFormat
{
    float appStar = _appStar * 2.0f;
    if (appStar > 10.0f)
    {
        appStar = 10.0f;
    }
    return [[NSString stringWithFormat:@"%.0f", appStar] intValue];
}

@end
