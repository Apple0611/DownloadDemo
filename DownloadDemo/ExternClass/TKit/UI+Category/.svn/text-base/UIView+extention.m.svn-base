//
//  UIView+extention.m
//  GameMaster
//
//  Created by Thilong on 13-11-27.
//  Copyright (c) 2013年 tyc. All rights reserved.
//

#import "UIView+extention.h"

@implementation UIView (tk)

- (void)centerInSuperView {
	if (self.superview) {
		CGRect kFrame = self.frame;
		kFrame.origin.x = (CGRectGetWidth(self.superview.frame) - CGRectGetWidth(kFrame)) / 2;
		kFrame.origin.y = (CGRectGetHeight(self.superview.frame) - CGRectGetHeight(kFrame)) / 2;
		self.frame = kFrame;
	}
}

- (void)show {
	[self setHidden:NO];
}

- (void)hide {
	[self setHidden:YES];
}

@end
