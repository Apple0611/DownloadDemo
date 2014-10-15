//
//  CCGetP2PData.m
//  CCTVLiveLine
//
//  Created by lifu on 14-8-1.
//  Copyright (c) 2014年 中视广信. All rights reserved.
//

#import "CCGetP2PData.h"


@implementation CCGetP2PData

@synthesize dataArray;
@synthesize UrlConnection;
@synthesize delegate;


#pragma mark  StartRequest

-(void)startGetP2PData:(NSString *)p2pUrl
{
    if (!p2pUrl||0==[p2pUrl length])
    {
        if (delegate)
        {
            [delegate returnGetP2PData:NO andP2PVideoUrl:nil];
        }
        return;
    }
    
    NSURL *_url=[NSURL URLWithString:p2pUrl];
    
    NSMutableURLRequest *_request=[[NSMutableURLRequest alloc]initWithURL:_url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    [_request setHTTPMethod:@"GET"];
    
    if (delegate)
    {
        [delegate returnGetP2PData:NO andP2PVideoUrl:nil];
    }
    UrlConnection=[[NSURLConnection alloc]initWithRequest:_request delegate:self];
}


#pragma mark Private Class Function  404

-(BOOL)check404Error
{
    NSString *strData=[NSString stringWithFormat:@"%s",[dataArray bytes]];
    
    NSRange  strRange=[strData rangeOfString:@"404 Not Found"];
    
    if (strData&&strRange.location!=NSNotFound )
    {
        if (delegate)
        {
            [delegate returnGetP2PData:NO andP2PVideoUrl:nil];
        }
        return YES;
    }
    return NO;
}

#pragma mark NSURLConnectionDelegate

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NSArray *trustedHosts = [NSArray arrayWithObjects:challenge.protectionSpace.host, nil];
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		if ([trustedHosts containsObject:challenge.protectionSpace.host])
			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    dataArray=[[NSMutableData alloc]initWithCapacity:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataArray appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (delegate)
    {
        [delegate returnGetP2PData:NO andP2PVideoUrl:nil];
    }
    
    NSLog(@" %@",[error localizedFailureReason]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *_dicJson=[NSJSONSerialization JSONObjectWithData:dataArray options:0 error:nil];
    NSLog(@" dicJson=%@",_dicJson);
    NSString *p2pUrlPhone=[_dicJson objectForKey:@"iphone"];
    NSString *p2pUrlPad=[_dicJson objectForKey:@"ipad"];
    NSDictionary *dicUrl=[[NSDictionary alloc]initWithObjectsAndKeys:p2pUrlPhone ,@"iPhone", p2pUrlPad,@"ipad",nil];
    
    if (dicUrl)
    {
        if (delegate)
        {
            [delegate returnGetP2PData:YES andP2PVideoUrl:dicUrl];
        }
    }
}



@end
