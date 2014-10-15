//  UninstallOperation
//  DownjoyCenterV2.0
//
//  Created by thilong on 13-4-27.
//  Copyright (c) 2012 thilong.tao. All rights reserved.
//  Description: 


#import <Foundation/Foundation.h>

@class LocalAppInfo;


@interface UninstallOperation : NSOperation

@property(strong) LocalAppInfo *appInfo;

@end