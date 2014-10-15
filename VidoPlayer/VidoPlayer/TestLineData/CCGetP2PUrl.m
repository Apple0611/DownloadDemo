//
//  CCGetP2PUrl.m
//  CCTVLiveLine
//
//  Created by lifu on 14-8-1.
//  Copyright (c) 2014年 中视广信. All rights reserved.
//

#import "CCGetP2PUrl.h"

#define LiveUrl @"http://app.cntv.cn/special/2012/xml/PAGE1366600840543344.json?lasjdfaskdjflasdfsf"


@implementation CCGetP2PUrl

@synthesize dataArray;
@synthesize connectionUrl;
@synthesize delegate;

#pragma mark Public Class Function  Start request

-(void)startPlalyQuest
{
    NSString  *p2PUrl=[NSString stringWithFormat:LiveUrl];
    
    if (!p2PUrl||0==[p2PUrl length])
    {
        if (delegate)
        {
            [delegate ReturnGetP2Purl:NO P2PVideoUrlData:nil];
        }
        return;
    }
    NSURL  *requestUrl=[NSURL URLWithString:p2PUrl];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"GET"];
    
    if (!request)
    {
        if (delegate)
        {
            [delegate ReturnGetP2Purl:NO P2PVideoUrlData:nil];
        }
    }
    connectionUrl =[[NSURLConnection alloc]initWithRequest:request delegate:self];
}


#pragma mark Private Class Function

-(BOOL)check404Error
{
    NSString *strData=[NSString stringWithFormat:@"%s",[dataArray bytes]];
    
    NSRange  strRange=[strData rangeOfString:@"404 Not Found"];
    
    if (strData&&strRange.location!=NSNotFound )
    {
        if (delegate)
        {
            [delegate ReturnGetP2Purl:NO P2PVideoUrlData:nil];
        }
        return YES;
    }
    return NO;
}

#pragma mark NSURLConnectionDelegate
/*
 * 服务端采用的HTTPS验证, IOS客户端忽略证书的验证,异步请求方式//与HTTP方式不一样
 */
-(BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSArray *trustedHosts=@[challenge.protectionSpace.host];
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([trustedHosts containsObject:challenge.protectionSpace.host])
        {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

/*
 * 接收数据
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    dataArray=[[NSMutableData alloc]initWithCapacity:0];//初始化数组
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataArray appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (delegate)
    {
        [delegate ReturnGetP2Purl:NO P2PVideoUrlData:nil];
    }
 
}

/*
 * 请求数据解析
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *_dicJson=[NSJSONSerialization JSONObjectWithData:dataArray options:0 error:nil];
 
    NSDictionary *_dicData=[_dicJson objectForKey:@"data"];
    NSArray *_arrItems=[_dicData objectForKey:@"items"];
    NSDictionary *_dicOneItem=[_arrItems objectAtIndex:0];
    NSString *_strUrl=[_dicOneItem objectForKey:@"url"];
 
    if (_strUrl)
    {
        CCGetP2PData *GetP2PData=[[CCGetP2PData alloc]init];
        [GetP2PData setDelegate:self];
        [GetP2PData startGetP2PData:_strUrl];
    }
}

#pragma mark CCGetP2PDataDelegate

-(void)returnGetP2PData:(BOOL)bRet andP2PVideoUrl:(NSDictionary *)dicVideoUrl
{
    if (!bRet)
    {
        return;
    }
    
    if (delegate)
    {
        [delegate ReturnGetP2Purl:YES P2PVideoUrlData:dicVideoUrl];
    }
}




@end
