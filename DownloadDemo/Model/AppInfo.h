//
//  AppInfo.h
//  DownloadDemo
//
//  Created by downjoymac on 14-7-30.
//  Copyright (c) 2014年 Apple0611. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

@property(nonatomic) long ID;
@property(nonatomic, retain) NSString *BundleId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *englishName;
@property(nonatomic, retain) NSString *appStoreID;
@property(nonatomic, retain) NSString *appStoreUrl;
@property(nonatomic, retain) NSString *version;
@property(nonatomic, retain) NSString *iconUrl;
@property(nonatomic) long size;
@property(nonatomic, retain) NSString *strSize;
@property(nonatomic, retain) NSString *categoryName;
@property(nonatomic, retain) NSString *categoryEnglishName;
@property(nonatomic, retain) NSString *modifyTime;
@property(nonatomic, retain) NSString *tags;
@property(nonatomic, retain) NSString *ipaUrl;
@property(nonatomic) long  downloadCount;
@property(nonatomic, retain) NSString *strDownloadCount;
@property(nonatomic) float appStar;

@property(nonatomic, retain) NSString *chineseDescription;

@property(nonatomic) int commentCount;
@property(nonatomic) int hotValue;

@property(nonatomic) float currentPrice;
@property(nonatomic, retain) NSString *priceUnit;
@property(nonatomic, retain) NSString *originalPrice;

- (NSString *)sizeFormat:(NSString *)size;

- (NSString *)countFormat:(long) count;

- (int) appStarFormat;


@end
