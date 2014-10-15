//  TKDebug.h
//
//
//  Created by thilong on 13-8-22.
//  Copyright (c) 2012 thilong.tao. All rights reserved.
//  Description: 


#import <Foundation/Foundation.h>

#ifndef __DEBUG__H__
#define __DEBUG__H__


#ifdef T_DEBUG
#   define DLog NSLog
#else
    void Log(NSString *format,...){}
#   define DLog Log
#endif

#endif