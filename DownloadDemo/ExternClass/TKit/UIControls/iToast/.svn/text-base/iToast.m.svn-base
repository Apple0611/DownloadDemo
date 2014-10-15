//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 (NULL). All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Hierarchy2.h"
#import "UIColor+tk.h"

#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface iToast ()
@property (nonatomic, assign) NSInteger offsetLeft;
@property (nonatomic, assign) NSInteger offsetTop;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, assign) iToastSettings *settings;

@end


@implementation iToast

- (void)dealloc {
	self.view = nil;
	self.text = nil;
	[super dealloc];
}

static NSMutableArray *toastQueue;

- (id)initWithText:(NSString *)tex {
	if (self = [super init]) {
		self.text = tex;
	}
	return self;
}

- (NSString *)getText {
	return _text;
}

- (void)show {
	[self show:self.theSettings.toastType];
}

- (void)show:(iToastType)type {
	if (toastQueue == nil)
		toastQueue = [[NSMutableArray alloc] init];
    
	iToast *toast = toastQueue.count > 0 ? [toastQueue objectAtIndex:0] : nil;
	if (toast == nil) {
		[self theSettings].toastType = type;
		[toastQueue addObject:self];
	}
	else if (![toast isEqual:self]) {
		//if text  already in queue, pass this text.
		for (iToast *queToast in toastQueue) {
			if ([queToast.text isEqualToString:_text]) {
				return;
			}
		}
		[self theSettings].toastType = type;
		[toastQueue addObject:self];
	}
	if (toastQueue.count > 1 && ![toast isEqual:self]) return;
    
	iToastSettings *theSettings = [self theSettings];
    
	UIFont *font = [UIFont systemFontOfSize:15.0f];
    
	CGSize textSize = [_text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = _text;
	label.numberOfLines = 0;
    
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
    v.layer.cornerRadius = 3;
    v.layer.masksToBounds = YES;
	v.frame = CGRectMake(0, 0, textSize.width + 20, textSize.height + 20);
	label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	[v setBackgroundColor:theSettings.backgroundColor];
//	v.layer.borderColor = [theSettings colorForType:type].CGColor;
    v.layer.borderColor = [UIColor clearColor].CGColor;
	v.layer.borderWidth = 0.5f;
	[v addSubview:label];
	[label release];
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
	CGPoint point = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
	point.x = point.x;
	UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
	switch (orientation) {
		case UIDeviceOrientationPortrait:
		{
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(window.frame.size.width / 2, 75);
			}
			else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 180);
			}
			else if (theSettings.gravity == iToastGravityCenter) {
                if (IS_iPhone5) {
                    point = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
                }else {
                    point = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2 - 30);
				}
			}
			else {
				point = theSettings.postition;
			}
            
			point = CGPointMake(point.x + _offsetLeft, point.y + _offsetTop);
			break;
		}
            
		case UIDeviceOrientationPortraitUpsideDown:
		{
			v.transform = CGAffineTransformMakeRotation(M_PI);
            
			float width = window.frame.size.width;
			float height = window.frame.size.height;
            
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(width / 2, height - 45);
			}
			else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(width / 2, 180);
			}
			else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(width / 2, height / 2);
			}
			else {
				point = theSettings.postition;
			}
            
			point = CGPointMake(point.x - _offsetLeft, point.y - _offsetTop);
			break;
		}
            
		case UIDeviceOrientationLandscapeLeft:
		{
			v.transform = CGAffineTransformMakeRotation(M_PI / 2); //rotation in radians
            
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(window.frame.size.width - 45, window.frame.size.height / 2);
			}
			else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(45, window.frame.size.height / 2);
			}
			else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
			}
			else {
				point = theSettings.postition;
			}
            
			point = CGPointMake(point.x - _offsetTop, point.y - _offsetLeft);
			break;
		}
            
		case UIDeviceOrientationLandscapeRight:
		{
			v.transform = CGAffineTransformMakeRotation(-M_PI / 2);
            
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(45, window.frame.size.height / 2);
			}
			else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(window.frame.size.width - 45, window.frame.size.height / 2);
			}
			else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
			}
			else {
				point = theSettings.postition;
			}
            
			point = CGPointMake(point.x + _offsetTop, point.y + _offsetLeft);
			break;
		}
            
		default:
			break;
	}
    
	v.center = point;
    
	[self performSelector:@selector(hideToast:) withObject:nil afterDelay:((float)theSettings.duration / 1000)];
    
	[window addSubview:v];
    
	self.view = v;
	[_view bringToFront];
	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (void)hideToast:(NSTimer *)theTimer {
	if (!self) return;
	_view.alpha = 0;
	_view.hidden = YES;
	if ([theTimer isKindOfClass:[UIButton class]]) {
		return;
	}
	[_view removeFromSuperview];
	[toastQueue removeObject:self];
	if (toastQueue.count > 0) {
		iToast *toast = [toastQueue objectAtIndex:0];
		[toast show];
	}
}

- (void)removeToast:(NSTimer *)theTimer {
	[_view removeFromSuperview];
	[toastQueue removeObject:self];
	if (toastQueue.count > 0) {
		iToast *toast = [toastQueue objectAtIndex:0];
		[toast show];
	}
}

+ (iToast *)makeText:(NSString *)_text {
	iToast *toast = [[[iToast alloc] initWithText:_text] autorelease];
	return toast;
}

- (iToast *)setDuration:(NSInteger)duration {
	[self theSettings].duration = duration;
	return self;
}

- (iToast *)setGravity:(iToastGravity)gravity
            offsetLeft:(NSInteger)left
             offsetTop:(NSInteger)top {
	[self theSettings].gravity = gravity;
	_offsetLeft = left;
	_offsetTop = top;
	return self;
}

- (iToast *)setGravity:(iToastGravity)gravity {
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *)setPostion:(CGPoint)_position {
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	return self;
}

- (iToastSettings *)theSettings {
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copyWithZone:nil];
	}
	return _settings;
}

@end

@interface iToastSettings ()

@property (strong) NSMutableArray *colors;

@end

@implementation iToastSettings
{
	BOOL positionIsSet;
}

- (void)dealloc {
	[_colors release];
	[_backgroundColor release];
	[super dealloc];
}

- (id)init {
	self = [super init];
	if (self) {
		_colors = [[NSMutableArray alloc] initWithCapacity:5];
//		_colors[iToastTypeNone] = [UIColor blackColor];
//		_colors[iToastTypeInfo] = [UIColor greenColor];
//		_colors[iToastTypeNotice] = [UIColor grayColor];
//		_colors[iToastTypeWarning] = [UIColor yellowColor];
//		_colors[iToastTypeError] = [UIColor redColor];
        _colors[iToastTypeNone] = [UIColor clearColor];
		_colors[iToastTypeInfo] = [UIColor clearColor];
		_colors[iToastTypeNotice] = [UIColor clearColor];
		_colors[iToastTypeWarning] = [UIColor clearColor];
		_colors[iToastTypeError] = [UIColor clearColor];
	}
	return self;
}

- (void)setColor:(UIColor *)color forType:(iToastType)type {
	_colors[type] = color;
}

- (UIColor *)colorForType:(iToastType)type {
	return _colors[type];
}

+ (iToastSettings *)getSharedSettings {
	static iToastSettings *sharedSettings = nil;
    
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityCenter;
		sharedSettings.duration = iToastDurationShort;
		sharedSettings.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
	}
	return sharedSettings;
}

- (id)copyWithZone:(NSZone *)zone {
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	copy.toastType = self.toastType;
	copy.backgroundColor = self.backgroundColor;
	for (int i = 0; i < 5; i++) {
		[copy setColor:[self colorForType:i] forType:i];
	}
	return copy;
}

@end



