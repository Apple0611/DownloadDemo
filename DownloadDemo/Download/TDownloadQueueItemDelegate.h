//
// Created by thilong on 13-4-13.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class TDownloadQueueItem;

@protocol TDownloadQueueItemDelegate <NSObject>
- (void)TDownloadQueueItemStarted:(TDownloadQueueItem *)item;

- (void)TDownloadQueueItemCompleted:(TDownloadQueueItem *)item;

- (void)TDownloadQueueItemFailed:(TDownloadQueueItem *)item;
@end