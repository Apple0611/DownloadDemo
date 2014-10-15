//
//  TDownloadQueue.m
//  GameCenter
//
//  Created by thilong on 13-4-13.
//  Copyright (c) 2013年 thilong.tao. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"
#import "TDownloadQueueItem.h"
#import "FMDB/FMDatabase.h"
#import "CodeHelper/AppStrings.h"
#import "TDownloadQueue.h"
#import "TKCodeHelper.h"
#import "TLocalAppManager.h"
#import "CodeHelper/Reachability.h"

#define MAX_DOWNLOAD_ALLOW 2

@interface TDownloadQueue ()

@property (nonatomic, retain) NSTimer            *downloadTimer;
@property (nonatomic, retain) NSMutableArray     *queueItems; //队列元素
@property (nonatomic, retain) NSMutableArray     *reachableItems;

- (void)startQueue;

- (void)addOneItem:(TDownloadItem *)item;

- (void)updateDownladStateTimer;

- (void)postDownloadStatueChangedNotification:(TDownloadQueueItem*)item;

- (void)addItem:(TDownloadItem *)item startDownload:(BOOL)start postStatus:(BOOL)post;

@end

@implementation TDownloadQueue

@synthesize delegate = _delegate;
@synthesize queueItems = _queueItems;
@synthesize reachableItems = _reachableItems;
@synthesize downloadTimer = _downloadTimer;

+ (TDownloadQueue *)sharedQueue
{
    static TDownloadQueue *_sharedQueue = nil;
    
    if (_sharedQueue == nil)
    {
        _sharedQueue = [[TDownloadQueue alloc] init];
    }
    
    return _sharedQueue;
}

#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.downloadTimer invalidate];
    
    self.delegate = nil;
    self.reachableItems = nil;
    self.downloadTimer = nil;
    self.queueItems    = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.queueItems = [NSMutableArray arrayWithCapacity:MAX_DOWNLOAD_ALLOW];
        self.reachableItems = [NSMutableArray arrayWithCapacity:MAX_DOWNLOAD_ALLOW];
        
        self.downloadTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(updateDownladStateTimer)
                                                            userInfo:nil
                                                             repeats:YES];
        
        [self.downloadTimer fire];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark -try add or remove item

- (void)tryAddDownloadItem:(TDownloadItem *)item animateIcon:(UIImageView *)animateIcon
{
    if(!_delegate) return;
//    [AppGlobal addDownloadQueueAnimate:animateIcon];
//    return;
    //是否正在下载此app
    if ([[TDownloadQueue sharedQueue] queryDownloadingItem:item])
    {
        [_delegate tDownloadQueue:self
            addDownloadItemFailed:item
                        errorCode:TDownloadQueueErrorDownloadAlreadyExist];
    }
    else
    {
#ifndef _DEB_
        if ([((LocalAppInfo *)item).hatTag rangeOfString:@"1"].length !=0 && (is64bitHardware() || IS_IOS7_1)) {
            showBTTip();
            return;
        }
#endif
        //是否已经下载过
        BOOL appDownloaded = [_delegate tDownloadQueue:self isItemDownloaded:item];
        
        if (appDownloaded)
        {
            [_delegate tDownloadQueue:self
                addDownloadItemFailed:item
                            errorCode:TDownloadQueueErrorItemAlreadyDownloaded];
        }
        else if([_delegate tDownloadQueue:self willAddItemDownload:item])
        {
            if (animateIcon) {
                [AppGlobal addDownloadQueueAnimate:animateIcon];
            } else {
                LocalAppInfo *app = (LocalAppInfo *) item;
                NSString     *msg = [NSString stringWithFormat:@"%@ 已添加到下载队列...", app.name];
                showMessageBox(msg, 1000);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"appNOTDownloaded" object:item];   //张青 2013.12.30
            [self addItem:item];
            
            [_delegate tDownloadQueue:self addDownloadItemSucceed:item];
        }
    }
}

- (void)tryAddDownloadItemWithOutCheck:(TDownloadItem *)item
{
    if(!_delegate) return;
    
    [_delegate tDownloadQueue:self removeDownloadedItem:item];
    
    if([_delegate tDownloadQueue:self willAddItemDownload:item])
    {
        [self addItem:item];
        
        [_delegate tDownloadQueue:self addDownloadItemSucceed:item];
    }
}

#pragma mark - add item

- (void)addItem:(TDownloadItem *)item
{
    [self addOneItem:item];
    
    
    if (IS_PHONE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Queue_Added object:[item getId]];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
    }
    BOOL canStart = YES;
    
    if (_delegate)
    {
        canStart = [_delegate tDownloadQueue:self canStartNewDownlaod:item];
    }
    
    if(canStart)
    {
        [self startQueue];
    }
    else
    {
        [self pause:item];
    }
}

- (void)addItem:(TDownloadItem *)item startDownload:(BOOL)start  postStatus:(BOOL)post
{
    if( ![self queryDownloadingItem:item] ) return;
    
    [self addOneItem:item];
    
    if (post)
    {
        if (IS_PHONE) {
            [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Queue_Added object:[item getId]];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
        }
    }
    
    if (start)
    {
        [self startQueue];
    }

}

- (void)addItems:(NSArray *)items __unused
{
    for (TDownloadItem *item in items)
    {
        [self addOneItem:item];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Queue_Changed object:nil];
    
    [self startQueue];
    [self saveDownloadingState];
}

#pragma mark - item actions

- (void)resume:(TDownloadItem *)item
{
    @synchronized (self)
    {
        __block NSUInteger curDownloadingCount = [self currentDownloadingCount];
        
        [_queueItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            TDownloadQueueItem *download = (TDownloadQueueItem *)obj;
            
            if ([download isDownloadingItem:item])
            {
                if (curDownloadingCount < MAX_DOWNLOAD_ALLOW)
                {
                    [download start];
                }
                else
                {
                    [download setWait];
                }
                
                *stop = YES;
            }
        }];
    }
}

- (void)cancel:(TDownloadItem *)item
{
    @synchronized (self)
    {
        [_queueItems enumerateObjectsUsingBlock:^(TDownloadQueueItem *download, NSUInteger idx, BOOL *stop) {
            if ([download isDownloadingItem:item])
            {
                NSString *str = [NSString stringWithFormat:@"%@_%@", ((LocalAppInfo *) download.targetDownloadItem).bundleID, ((LocalAppInfo *) download.targetDownloadItem).version];
                [download cancelAndDeleteFile];
                
                @synchronized(_queueItems)
                {
                    [_queueItems removeObject:download];
                }
                
                @synchronized(_reachableItems)
                {
                    if([_reachableItems containsObject:download])
                    {
                        [_reachableItems removeObject:download];
                    }
                }
                if (IS_PHONE) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Queue_Removed object:[item getId]];
                }
                else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:str];
                }
                
                [self startQueue];
                
                *stop = YES;
            }
        }];
    }
}

- (void)pause:(TDownloadItem *)item
{
    @synchronized (self)
    {
        [_queueItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TDownloadQueueItem *download = (TDownloadQueueItem*)obj;
            
            *stop = [download isDownloadingItem:item];
            
            if(*stop)
            {
                [download pause];
            }
        }];
    }
    
    [self startQueue];
    
    [self postDownloadStatueChangedNotification:nil];
}

#pragma mark - all items actions

- (void)cancelAll
{
    @synchronized (self)
    {
        for (TDownloadQueueItem *download in _queueItems)
        {
            [download cancelAndDeleteFile];
        }
        [self.queueItems removeAllObjects];
    }
    if (IS_PHONE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Queue_Changed object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
    }
    
    
}


- (void)pauseAll
{
    @synchronized (self)
    {
        for (TDownloadQueueItem *download in _queueItems)
        {
            [download pause];
        }
    }
}

- (void)resumeAll
{
    @synchronized (self)
    {
        for (TDownloadQueueItem *download in _queueItems)
        {
            if (download.status != TDownloadItemStatusDownloading) {
                [download setWait];
            }
        }
    }
    [self startQueue];
}

#pragma mark - query TDownloadQueueItem

- (NSArray *)downloadingItems
{
    NSMutableArray          *array = [[[NSMutableArray alloc] init] autorelease];
    for (TDownloadQueueItem *item in _queueItems)
    {
        [array addObject:[item targetDownloadItem]];
    }
    return array;
}

//- (BOOL) isDownloadingWithBundleID:(NSString *)bundleID
//{
//    
//}

- (TDownloadQueueItem *)queryDownloadingItem:(TDownloadItem *)item
{
    TDownloadQueueItem *result = nil;
    @synchronized (self)
    {
        for (TDownloadQueueItem *item1 in self.queueItems)
        {
            if ([item1 isDownloadingItem:item])
            {
                result = item1;
            }
        }
    }
    return result;
}

#pragma mark - downloading state

//保存程序状态(保存正在下载列表)
- (void)saveDownloadingState
{
    @synchronized (self)
    {
        for (TDownloadQueueItem *item1 in _queueItems)
        {
            TDownloadItem *item = [item1 targetDownloadItem];
            [item saveDownloadingState];
        }
    }
}

- (void)loadDownloadingState
{
    if (_delegate == nil)
    {
        return;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:AppDatabasePath()];
    
    [db open];
    
    FMResultSet    *rs        = [db executeQuery:IDS_DATABASE_Query_Downloading_Cache];
    
    NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
    if (rs != nil)
    {
        while ([rs next])
        {
            TDownloadItem *downloadItem = [_delegate tDownloadQueue:self parseDownloadItem:rs];
            [tempArray addObject:downloadItem];
        }
    }
    
    [db close];
    
    @synchronized (self)
    {
        NSMutableArray *notAdded = [[NSMutableArray new] autorelease];
        for (TDownloadItem *item in tempArray)
        {
            if ([item isDownloading])
            {
                TDownloadQueueItem *item1 = [[[TDownloadQueueItem alloc] initWithDownloadItem:item] autorelease];
                [item1 restoreCorrespondingStatus];
                item1.manager = self;
                [self.queueItems addObject:item1];
            }
            else
            {
                [notAdded addObject:item];
            }
        }
        
        for (TDownloadItem *item in notAdded)
        {
            TDownloadQueueItem *item1 = [[[TDownloadQueueItem alloc] initWithDownloadItem:item] autorelease];
            [item1 restoreCorrespondingStatus];
            item1.manager = self;
            [self.queueItems addObject:item1];
        }
        
        [self startQueue];
    }
    
    if (IS_PHONE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Queue_Changed object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
    }
    

}

#pragma mark - download queue manager

- (void)startQueue
{
    //只启动处于等待的下载
    @synchronized (self)
    {
        for (TDownloadQueueItem *download in _queueItems)
        {
            int curDownloadingCount = [self currentDownloadingCount];
            if (download.status == TDownloadItemStatusWaiting && (curDownloadingCount < MAX_DOWNLOAD_ALLOW))
            {
                [download start];
            }
        }
    }
}

- (void)addOneItem:(TDownloadItem *)item
{
    @synchronized (self)
    {
        TDownloadQueueItem *item1 = [[[TDownloadQueueItem alloc] initWithDownloadItem:item] autorelease];
        item1.manager = self;
        [self.queueItems addObject:item1];
    }
}

#pragma mark - update speed timer

- (void)updateDownladStateTimer
{
    @synchronized (self)
    {
        [_queueItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(TDownloadQueueItem *)obj calcState];
        }];
    }
    
    dispatch_async(
       dispatch_get_main_queue(), ^
       {
           [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Status_Changed
                                                               object:nil];
       });
}

- (void) postDownloadStatueChangedNotification:(TDownloadQueueItem*)item
{
    [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Status_Changed
                                                        object:item ? [[item targetDownloadItem] getId] : nil];
    
}

- (NSUInteger) currentDownloadingCount
{
    __block NSUInteger count = 0;
    
    [_queueItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([(TDownloadQueueItem *)obj isDownloading])
        {
            count ++;
        }
    }];
    
    return count;
}

- (NSUInteger)currentDownloadingSpeed:(unsigned int *)speed
{
    *speed = 0;
    
    __block NSUInteger count = 0;
    
    [_queueItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([(TDownloadQueueItem *)obj isDownloading])
        {
            count ++;
            
            *speed += ((TDownloadQueueItem *)obj).speed;
        }
    }];
    
    return count;
}

#pragma mark - kReachabilityChangedNotification

- (void)reachabilityChanged:(NSNotification *)note
{
    if(_delegate && [_delegate respondsToSelector:@selector(tDownloadQueue:canContinueDownload:)])
    {
        @synchronized(_reachableItems)
        {
            BOOL canContinueDownload = [_delegate tDownloadQueue:self canContinueDownload:nil];
            
            if(canContinueDownload)
            {
                [_reachableItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [(TDownloadQueueItem*)obj start];
                }];
                
                [_reachableItems removeAllObjects];
            }
            else
            {
                [_reachableItems removeAllObjects];
                
                [_queueItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if([(TDownloadQueueItem*)obj isDownloading])
                    {
                        [(TDownloadQueueItem*)obj pause];
                        
                        [_reachableItems addObject:obj];
                    }
                }];
            }
            
            [self postDownloadStatueChangedNotification:nil];
        }
    }
}

#pragma mark - TDownloadQueueItemDelegate

- (void)TDownloadQueueItemStarted:(TDownloadQueueItem *)item
{
    [self postDownloadStatueChangedNotification:item];
}

- (void)TDownloadQueueItemCompleted:(TDownloadQueueItem *)item
{
    @synchronized (self)
    {
        TDownloadItem *targetDownloadingItem = [item targetDownloadItem];
        if (_delegate)
        {
            [_delegate tDownloadQueue:self downloadItemComplete:targetDownloadingItem];
        }
        
        [self.queueItems removeObject:item];
        if (IS_PHONE) {            
            [[NSNotificationCenter defaultCenter] postNotificationName:IDS_DOWNLOAD_Queue_Complete
                                                                object:item ? [[item targetDownloadItem] getId] : nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:IDN_DOWNLOAD_QUEUE_CHANGED object:nil];
        }
        
        
    }
    
    [self startQueue];
}

- (void)TDownloadQueueItemFailed:(TDownloadQueueItem *)item
{
    [self postDownloadStatueChangedNotification:item];
    
    [self startQueue];
}

@end
