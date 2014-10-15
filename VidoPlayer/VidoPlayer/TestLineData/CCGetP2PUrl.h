//
//  CCGetP2PUrl.h
//  CCTVLiveLine
//
//  Created by lifu on 14-8-1.
//  Copyright (c) 2014年 中视广信. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCGetP2PData.h"

@protocol CCGetP2PUrlDelegate <NSObject>

/*
 * 代理
 */

-(void)ReturnGetP2Purl:(BOOL)bRet  P2PVideoUrlData:(NSDictionary*)dicVideoUrl;

@end

@interface CCGetP2PUrl : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,CCGetP2PDataDelegate>

@property (retain,nonatomic)NSMutableData *dataArray;
@property (retain,nonatomic)NSURLConnection *connectionUrl;
@property (retain,nonatomic)id<CCGetP2PUrlDelegate>delegate;

-(void)startPlalyQuest;

@end
