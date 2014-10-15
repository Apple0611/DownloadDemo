//
//  iToast.h
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 (NULL). All rights reserved.
//

#ifndef __H__ITOAST__
#define __H__ITOAST__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum iToastGravity {
	iToastGravityTop = 1000001,
	iToastGravityBottom,
	iToastGravityCenter,
    iToastGravityNone
}iToastGravity;

typedef enum iToastDuration {
	iToastDurationLong = 10000,
	iToastDurationShort = 1000,
	iToastDurationNormal = 3000
} iToastDuration;

typedef enum iToastType {
	iToastTypeNone = 0,
	iToastTypeInfo = 1,
	iToastTypeNotice = 2,
	iToastTypeWarning = 3,
	iToastTypeError = 4,
}iToastType;


@class iToastSettings;

@interface iToast : NSObject

- (NSString *)getText;

- (void)show;

- (void)show:(iToastType)type;

- (iToast *)setDuration:(NSInteger)duration;

- (iToast *)setGravity:(iToastGravity)gravity
            offsetLeft:(NSInteger)left
             offsetTop:(NSInteger)top;

- (iToast *)setGravity:(iToastGravity)gravity;

- (iToast *)setPostion:(CGPoint)position;

+ (iToast *)makeText:(NSString *)text;

- (iToastSettings *)theSettings;

@end


/**
 *  global iToast setting.
 */
@interface iToastSettings : NSObject <NSCopying>

@property (nonatomic, strong) UIColor *backgroundColor;
@property (assign) NSInteger duration;
@property (assign) iToastGravity gravity;
@property (assign) CGPoint postition;
@property (assign) iToastType toastType;

- (void)setColor:(UIColor *)color forType:(iToastType)type;
- (UIColor *)colorForType:(iToastType)type;
+ (iToastSettings *)getSharedSettings;

@end


#endif