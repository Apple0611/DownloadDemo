//
//  UITModalView.m
//
//
//  Created by Thilong on 13-11-27.
//  Copyright (c) 2013年 tyc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UITModalView.h"
#import "UIColor+tk.h"

@interface UITModalView ()
@property (nonatomic, assign) UIView <UITModalViewProtocol> *content;

@end

@implementation UITModalView
{
	bool _dismissed;
	BOOL _dismissOnTouch;
}

- (id)initWithContentView:(UIView <UITModalViewProtocol> *)contentView {
	self = [super init];
	_dismissOnTouch = false;
	self.content = contentView;
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self setAutoresizesSubviews:YES];
	[self addSubview:contentView];
	CGRect frame = contentView.frame;
	frame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) / 2;
	frame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) / 2;
	contentView.frame = frame;
	self.alpha = 0;
	self.hidden = YES;
    //content view won't be resizeable. set resizeable in "initContentView".
	[contentView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin)];
	[self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    if ([contentView respondsToSelector:@selector(initContentView)]) {
		[contentView initContentView];
	}
	if ([contentView respondsToSelector:@selector(setModalViewContainer:)]) {
		[contentView setModalViewContainer:self];
	}
	return self;
}

- (void)showInView:(UIView *)parentView animated:(BOOL)animated dismissAfterDelay:(NSTimeInterval)delay {
	_dismissed = false;
	if (!parentView) {
		parentView = [[UIApplication sharedApplication] windows][0];
	}
	self.frame = parentView.bounds;
	[parentView addSubview:self];
	self.hidden = NO;
	__block __weak typeof(self) weakSelf = self;
    
	[UIView animateWithDuration:0.3 animations: ^{
	    typeof(self) strongSelf = weakSelf;
	    if (strongSelf) {
	        strongSelf.alpha = 1.0f;
		}
	}  completion: ^(BOOL finished) {
	    typeof(self) strongSelf = weakSelf;
	    if (strongSelf && delay > 0 && !_dismissed) {
	        [strongSelf performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
		}
	}];
}

- (void)dismiss {
	__block __weak typeof(self) weakSelf = self;
    
	[UIView animateWithDuration:0.3 animations: ^{
	    typeof(self) strongSelf = weakSelf;
	    if (strongSelf) {
	        strongSelf.alpha = 0.0f;
		}
	} completion: ^(BOOL finished) {
	    typeof(self) strongSelf = weakSelf;
	    [strongSelf removeFromSuperview];
	    _dismissed = true;
	}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_dismissOnTouch)
		[self dismiss];
	else if (_content && [_content respondsToSelector:@selector(touchOnParentContainer)]) {
		[_content touchOnParentContainer];
	}
}

- (void)setDismissOnTouch:(BOOL)flag {
	_dismissOnTouch = flag;
}

@end
