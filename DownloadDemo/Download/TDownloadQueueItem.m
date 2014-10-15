//
//  TDownloadQueueItem.m
//  GameCenter
//
//  Created by thilong on 13-4-13.
//  Copyright (c) 2013年 thilong.tao. All rights reserved.
//

#import "TDownloadQueueItem.h"
#import "LocalAppInfo.h"

#define KEY_FILE_LENGTH @"FileLength"
#define KEY_FILE_COMPLETED_LENGTH @"Completed"
#define MAX_RETRY_TIME 3

@interface TDownloadQueueItem ()
@property(strong, nonatomic) TDownloadItem       *downloadItem;
@property(strong, nonatomic) NSString            *savePath;
@property(strong, nonatomic) NSString            *tempSavePath;
@property(strong, nonatomic) NSString            *statusSavePath;
@property(strong, nonatomic) NSFileHandle        *tempSaveHandle;
@property(strong) NSMutableData                  *tempData;
@property(strong, nonatomic) NSMutableDictionary *statusDic;

@property(strong) NSURLConnection               *connection;
//@property(nonatomic, strong) ASIFormDataRequest *ipaUrlRequest;
@property(nonatomic, assign) int          retryTimes;
@property(nonatomic, assign) unsigned int zeroSizeTimes;

- (void)saveCurrentStatus:(BOOL)finishedDownload;
@end

@implementation TDownloadQueueItem
{
    NSTimeInterval _startTime;
    unsigned long  _remoteFileSize;
    unsigned long  _completedSizeInEachDownloadTime;  //一次下载中完成的大小
    unsigned long  _completedSizeInLastCalcTime;  //上一次下载完成的大小
    unsigned long  _totalCompletedSize; //下载完成的总大小

    unsigned long      _speed;
    long long __unused _exceptedBytes;
}


- (id)initWithDownloadItem:(TDownloadItem *)item
{
    self = [super init];
    if (self)
    {
        self.retryTimes   = 0;
        item.delegate = self;
        self.downloadItem = item;
        _tempSaveHandle = nil;
        _status         = TDownloadItemStatusWaiting;
        NSString *cacheFolder    = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#ifdef _DEB_
        NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        cacheFolder = [cacheFolder stringByReplacingOccurrencesOfString:@"/root/" withString:@"/mobile/"];
        documentFolder = [documentFolder stringByReplacingOccurrencesOfString:@"/root/" withString:@"/mobile/"];
#else
        NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#endif
        NSString *downloadFileName = [item getSaveFileName];
        self.savePath = [documentFolder stringByAppendingPathComponent:downloadFileName];

        NSString *tempDataFolder    = [cacheFolder stringByAppendingPathComponent:@"tempData"];
        NSString *statusCacheFolder = [cacheFolder stringByAppendingPathComponent:@"statusCache"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:tempDataFolder])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:tempDataFolder withIntermediateDirectories:NO attributes:nil error:nil];
        }

        if (![[NSFileManager defaultManager] fileExistsAtPath:statusCacheFolder])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:statusCacheFolder withIntermediateDirectories:NO attributes:nil error:nil];
        }

        self.tempSavePath   = [[cacheFolder stringByAppendingPathComponent:@"tempData"] stringByAppendingPathComponent:downloadFileName];
        self.statusSavePath = [[cacheFolder stringByAppendingPathComponent:@"statusCache"] stringByAppendingPathComponent:downloadFileName];
        self.tempData       = [NSMutableData data];
        _startTime = 0;

        BOOL tempFileExist   = [[NSFileManager defaultManager] fileExistsAtPath:self.tempSavePath];
        BOOL statusFileExist = [[NSFileManager defaultManager] fileExistsAtPath:self.statusSavePath];
        if (tempFileExist && statusFileExist)   //存在缓存文件，为断点续传
        {
            self.statusDic = [NSMutableDictionary dictionaryWithContentsOfFile:self.statusSavePath];
            _remoteFileSize             = [(NSNumber *) [self.statusDic objectForKey:KEY_FILE_LENGTH] unsignedLongValue];
            unsigned long completedSize = [(NSNumber *) [self.statusDic objectForKey:KEY_FILE_COMPLETED_LENGTH] unsignedLongValue];
            _totalCompletedSize = completedSize;
        }
        _status              = (TDownloadItemStatus) [item getTDownloadQueueItemCorrespondingStatus];
    }
    return self;
}

- (void)calcState
{
    if (_connection) //如果正在下载
    {
        [self saveCurrentStatus:NO];  //保存当前的下载状态
        if (_completedSizeInLastCalcTime == _completedSizeInEachDownloadTime)
        {
            _zeroSizeTimes++;
            _zeroSizeTimes = (_zeroSizeTimes > 4 ? 4 : _zeroSizeTimes);
        }
        //如果和上一次取到的大小一样，则认定这次timer没有取到数据,如果连续 3s没有取到数据，则认定下载速度为0
        if (self.zeroSizeTimes >= 3)
        {
            _speed                       = 0;
            _completedSizeInLastCalcTime = _completedSizeInEachDownloadTime = 0;
            _startTime                                                      = [[NSDate date] timeIntervalSince1970];
            _zeroSizeTimes                                                  = 0;
        }
        else
        {
            NSTimeInterval timeFromStart = [[NSDate date] timeIntervalSince1970] - _startTime;
            _speed                       = (unsigned long) (_completedSizeInEachDownloadTime / timeFromStart);
            _completedSizeInLastCalcTime = _completedSizeInEachDownloadTime;
        }
    }
    else
    {
        _speed = 0;
    }
}

- (void)dealloc
{
//    if (self.ipaUrlRequest)
//    {
//        [self.ipaUrlRequest clearDelegatesAndCancel];
//        self.ipaUrlRequest = nil;
//    }
    self.downloadItem   = nil;
    self.tempData       = nil;
    self.savePath       = nil;
    self.tempSavePath   = nil;
    self.statusSavePath = nil;
    if (_tempSaveHandle)
    {
        [_tempSaveHandle closeFile];
    }
    self.tempSaveHandle = nil;
    [super dealloc];
}

- (void)start
{

    if ([self isDownloading])
    {
        return;
    }
    _retryTimes = 0;
    [self retry];
}
//开始下载
- (void)retry
{
    _zeroSizeTimes = 0;
    [_downloadItem setDownloadState:TDownloadItemStatusDownloading];
    if ([_downloadItem getDownloadUrl] == nil) //没有下载地址，获取下载地址
    {
//        if (_ipaUrlRequest)
//        {
//            [_ipaUrlRequest clearDelegatesAndCancel];
//        }
        [_downloadItem getPathForDownload];
        _completedSizeInEachDownloadTime = 0;
        _status                          = TDownloadItemStatusRequestingUrl;
        return;
    }


    _startTime                       = [[NSDate date] timeIntervalSince1970];
    _completedSizeInEachDownloadTime = 0;
    _status                          = TDownloadItemStatusDownloading;

    [_tempData resetBytesInRange:NSMakeRange(0, [_tempData length])];
    [_tempData setLength:0];

    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setURL:[_downloadItem getDownloadUrl]];

    BOOL tempFileExist   = [[NSFileManager defaultManager] fileExistsAtPath:_tempSavePath];
    BOOL statusFileExist = [[NSFileManager defaultManager] fileExistsAtPath:_statusSavePath];
    if (tempFileExist && statusFileExist)   //存在缓存文件，为断点续传
    {
        self.statusDic = [NSMutableDictionary dictionaryWithContentsOfFile:_statusSavePath];
    }
    else    //不存在缓存文件,为新下载
    {
        self.statusDic = [[[NSMutableDictionary alloc] init] autorelease];
        [_statusDic setValue:[NSNumber numberWithUnsignedLong:0] forKey:KEY_FILE_LENGTH];
        [_statusDic setValue:[NSNumber numberWithUnsignedLong:0] forKey:KEY_FILE_COMPLETED_LENGTH];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_statusSavePath])
        {
            [[NSFileManager defaultManager] createFileAtPath:_statusSavePath contents:nil attributes:nil];
        }
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:_tempSavePath])
    {
        [[NSFileManager defaultManager] createFileAtPath:_tempSavePath contents:nil attributes:nil];
    }
    self.tempSaveHandle = [NSFileHandle fileHandleForWritingAtPath:_tempSavePath];

    _remoteFileSize = [(NSNumber *) [_statusDic objectForKey:KEY_FILE_LENGTH] unsignedLongValue];
    [_downloadItem setRemoteFileSize:_remoteFileSize];
    unsigned long completedSize = [(NSNumber *) [_statusDic objectForKey:KEY_FILE_COMPLETED_LENGTH] unsignedLongValue];
    _totalCompletedSize = completedSize;
    NSString *range = [NSString stringWithFormat:@"bytes=%ld-", completedSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO] autorelease];
    [self.connection start];
    if (self.manager)
    {
        [self.manager TDownloadQueueItemStarted:self];
    }
}

- (void)pause
{
    [_downloadItem setDownloadState:TDownloadItemStatusPaused];
    [self saveCurrentStatus:YES];
    _status = TDownloadItemStatusPaused;
}

- (void)cancelAndDeleteFile
{
    if (_connection)
    {
        [_connection cancel];
        self.connection = nil;
    }
    _status = TDownloadItemStatusCanceled;
    if (_tempSaveHandle)
    {
        [_tempSaveHandle closeFile];
        self.tempSaveHandle = nil;
    }
    [_downloadItem downloadCanceled];
    _downloadItem = nil;
    [[NSFileManager defaultManager] removeItemAtPath:_tempSavePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:_statusSavePath error:nil];
}

- (BOOL)isDownloadingItem:(TDownloadItem *)item
{
    if (item == nil || self.downloadItem == nil)
    {
        return NO;
    }
    else
    {
        return [self.downloadItem isDownloadingMe:item];
    }
}

- (TDownloadItem *)targetDownloadItem
{
    return self.downloadItem;
}

- (void)setWait
{
    _status = TDownloadItemStatusWaiting;
    [_downloadItem setDownloadState:TDownloadItemStatusWaiting];
}

- (BOOL)isDownloading
{
    return _status == TDownloadItemStatusDownloading || _status == TDownloadItemStatusRequestingUrl;
}

- (unsigned int)speed
{
    return _speed;
}

- (float)completePercent
{
    if (_remoteFileSize == 0)
    {
        return 0.0f;
    }
    CGFloat currentCompletedSize = _totalCompletedSize * 1.0 / _remoteFileSize * 100;
    if (currentCompletedSize > 100.0) {
        currentCompletedSize = 100.0;
    }
    return currentCompletedSize;
}

- (unsigned long)completeSize
{
    return _totalCompletedSize;
}

- (unsigned long)getTotalSize
{
    return _remoteFileSize;
}

- (void)restoreCorrespondingStatus
{
    _status = [_downloadItem getTDownloadQueueItemCorrespondingStatus];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection1 didReceiveResponse:(NSURLResponse *)response
{
    @synchronized (self)
    {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

        NSDictionary *headerDic   = [httpResponse allHeaderFields];
        NSString     *contentType = [headerDic objectForKey:@"Content-Type"];
        if ([contentType isEqualToString:@"application/iphone"])    //确认下的是ipa包
        {
            if (_remoteFileSize == 0)    //如果是第一次请求
            {
                _remoteFileSize = (unsigned long) [[headerDic objectForKey:@"Content-Length"] longLongValue];
                [_statusDic setValue:@(_remoteFileSize) forKey:KEY_FILE_LENGTH];
                [_statusDic writeToFile:_statusSavePath atomically:YES];
                [_downloadItem setRemoteFileSize:_remoteFileSize]; //把获取到的数据总大小更新到下载的对象中
            }
        }
        else
        {
            _downloadItem.lastError = kTDownloadErrorAddressInvalid;
            [_downloadItem setDownloadUrl:nil];
            [_connection cancel];
            _status = TDownloadItemStatusFailed;
            [_downloadItem setDownloadState:TDownloadItemStatusFailed];
            self.connection = nil;
            return;
        }
        _exceptedBytes = [response expectedContentLength];
    }
}

- (void)connection:(NSURLConnection *)connection1 didReceiveData:(NSData *)data
{
    @synchronized (self)
    {
        [self.tempData appendData:data];
        _completedSizeInEachDownloadTime = _completedSizeInEachDownloadTime + [data length];
    }
}

- (void)connection:(NSURLConnection *)connection1 didFailWithError:(NSError *)error
{
    if (_retryTimes < MAX_RETRY_TIME)
    {
        _retryTimes++;
        [self retry];
        return;
    }
    _retryTimes = 0;
    _status     = TDownloadItemStatusFailed;
    [_downloadItem setDownloadState:TDownloadItemStatusFailed];
    [self saveCurrentStatus:YES];
    if (self.manager)
    {
        [self.manager TDownloadQueueItemFailed:self];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection1
{
    _status = TDownloadItemStatusCompleted;
    [self saveCurrentStatus:YES];
    
    if(_totalCompletedSize < _remoteFileSize)
    {
        [self connection:connection1 didFailWithError:NULL];
        return;
    }
    else if(_totalCompletedSize > _remoteFileSize)
    {
        _status     = TDownloadItemStatusFailed;
        [_downloadItem setDownloadState:TDownloadItemStatusError];
        [[NSFileManager defaultManager] removeItemAtPath:_statusSavePath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:_tempSavePath error:nil];
        if (self.manager)
        {
            [self.manager TDownloadQueueItemFailed:self];
        }
        return;
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:_statusSavePath error:nil];
    [[NSFileManager defaultManager] moveItemAtPath:_tempSavePath toPath:_savePath error:nil];
    if (self.manager)
    {
        [self.manager TDownloadQueueItemCompleted:self];
    }
}

- (void)saveCurrentStatus:(BOOL)finishedDownload
{
    @synchronized (self)
    {
        if (_tempData && _tempData.length > 0)
        {
            [_tempSaveHandle seekToFileOffset:_totalCompletedSize];
            [_tempSaveHandle writeData:_tempData];
            _totalCompletedSize = _totalCompletedSize + _tempData.length;
            [_tempData resetBytesInRange:NSMakeRange(0, [_tempData length])];
            [_tempData setLength:0];
        }
        [self.statusDic setValue:@(_totalCompletedSize) forKey:KEY_FILE_COMPLETED_LENGTH];
        [self.statusDic writeToFile:_statusSavePath atomically:YES];
        if (finishedDownload && _tempSaveHandle)
        {
            [_tempSaveHandle closeFile];
            self.tempSaveHandle = nil;
            [_connection cancel];
            self.connection = nil;
            _completedSizeInEachDownloadTime = 0;
        }
    }
}

- (NSString *)remoteTotalSize
{
    if (_remoteFileSize == 0)
    {
        return nil;
    }
    NSString *finalResult = nil;
    SIZE_TO_STR(_remoteFileSize, finalResult);
    return finalResult;
}

- (NSString *)downloadSpeed
{
    if(self.status == TDownloadItemStatusRequestingUrl)
    {
        return @"获取下载地址";
    }
    if (self.status != TDownloadItemStatusDownloading)
    {
        return nil;
    }
    NSString *finalResult = nil;
    SPEED_TO_STR(_speed, finalResult);
    return finalResult;
}

- (NSString *)downloadCompletedSize
{
    NSString *finalResult = nil;
    SIZE_TO_STR(_totalCompletedSize, finalResult);
    return finalResult;
}

- (NSString *)statusDescription
{
    
    switch (self.status)
    {
        case TDownloadItemStatusWaiting:
            return @"等待下载";
        case  TDownloadItemStatusRequestingUrl:
            return @"请求下载地址";
        case  TDownloadItemStatusDownloading:
            return @"正在下载";
        case TDownloadItemStatusPaused:
            return @"已暂停";
        case  TDownloadItemStatusFailed:
            return @"下载失败";
        case TDownloadItemStatusCompleted:
            return @"下载完成";
        case  TDownloadItemStatusCanceled:
            return @"下载已取消";
        default:
            break;
    }
    return nil;
}

- (unsigned int)finishedPercent
{
    if (_remoteFileSize == 0)
    {
        return 0;
    }
    return _totalCompletedSize / (_remoteFileSize / 100);
}

- (unsigned long)downloadTargetSize
{
    return _remoteFileSize;
}
#pragma mark - 获取下载地址delegate

- (void) getIpaUrlSuccessful
{
    [self retry];
//    NSLog(@"succcccc");
}
- (void) getIpaUrlFaild
{
    [self connection:nil didFailWithError:nil];
}
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    [_ipaUrlRequest clearDelegatesAndCancel];
//    self.ipaUrlRequest = nil;
//    NSString *tmp_strNowDownAppAddress = [request responseString];
//    if (nil == tmp_strNowDownAppAddress || [tmp_strNowDownAppAddress isEqualToString:@""])
//    {
//        [self connection:nil didFailWithError:nil];
//        return;
//    }
//    else
//    {
//        [_downloadItem setDownloadUrl:tmp_strNowDownAppAddress];
//        [self retry];
//    }
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    [_ipaUrlRequest clearDelegatesAndCancel];
//    self.ipaUrlRequest = nil;
//    [self connection:nil didFailWithError:nil];
//}
@end
