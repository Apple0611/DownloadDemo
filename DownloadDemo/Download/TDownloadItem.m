//
// Created by thilong on 13-4-20.
// Copyright (c) 2013 thilong.tao. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TDownloadItem.h"
#import "AFNetworking/AFNetworking.h"
#import "KeyChain/MCSMKeychainItem.h"

@implementation TDownloadItem

//static NSString *host = @"api.ios.d.cn";
//static NSString *dir  = @"api";


//C++快捷函数

//NSString *servicePath()
//{
//    return [NSString stringWithFormat:@"http://%@/%@", host, dir];
//}
//
//NSURL *servicePathURL()
//{
//    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", host, dir]];
//}
- (NSURL *)getDownloadUrl {
    return nil;
}

#pragma mark - keychain read & write

NSString* keychainValueForKey(const NSString* key)
{
    MCSMGenericKeychainItem *keychainItem =
    [MCSMGenericKeychainItem genericKeychainItemForService:@"DJGameCenter"
                                                  username:(NSString*)key];
    
    return keychainItem.password;
    
}
void setKeychainValueForKey(const NSString *value,const NSString *key)
{
    MCSMGenericKeychainItem *keychainItem =
    [MCSMGenericKeychainItem genericKeychainItemForService:@"DJGameCenter"
                                                  username:(NSString*)key];
    if(keychainItem)
    {
        [keychainItem removeFromKeychain];
    }
    
    [MCSMGenericKeychainItem genericKeychainItemWithService:@"DJGameCenter"
                                                   username:(NSString*)key
                                                   password:(NSString*)value];
}

- (void)setDownloadUrl:(NSString *)urlStr
{

}

- (void)setRemoteFileSize:(unsigned long)size
{

}

- (void)setDownloadStatePaused
{
    
}
- (void)setDownloadState:(int)downloadState
{
    
}

- (NSString *)getSaveFileName {
    return nil;
}

- (BOOL)isDownloading
{
    return NO;
}

- (BOOL)isPaused
{
    return NO;
}


- (BOOL)isDownloadingMe:(id)sender {
    return NO;
}

- (NSString *)getId
 {
     return nil;
 }

- (void)saveDownloadingState
{

}

- (void)downloadCanceled
{

}

- (void)downloadComplete
{

}


- (int)getTDownloadQueueItemCorrespondingStatus
{
    return 0;
}

//- (ASIFormDataRequest *)getPathForDownload:(id)delegate
//{
//    return nil;
//}

- (void)getPathForDownload
{
    
}
- (void) dealloc
{
    self.delegate = nil;
    [super dealloc];
}
@end