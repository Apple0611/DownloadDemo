//
//  CCGetP2PData.h
//  CCTVLiveLine
//
//  Created by lifu on 14-8-1.
//  Copyright (c) 2014年 中视广信. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 代理方法
 */

@protocol CCGetP2PDataDelegate <NSObject>

- (void)returnGetP2PData:(BOOL)bRet andP2PVideoUrl:(NSDictionary *)dicVideoUrl;

@end

@interface CCGetP2PData : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (retain,nonatomic)NSMutableData *dataArray;
@property (retain,nonatomic)NSURLConnection *UrlConnection;
@property (retain,nonatomic)id<CCGetP2PDataDelegate> delegate;

-(void)startGetP2PData:(NSString*)p2pUrl;

@end
