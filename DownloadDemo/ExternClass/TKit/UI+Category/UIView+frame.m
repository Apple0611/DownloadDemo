//
//  UIView+frame.m
//  TUIKit
//
//  Created by thilong on 14-1-22.
//  Copyright (c) 2014年 TYC. All rights reserved.
//

#import "UIView+frame.h"



@implementation UIView (Frame)

- (void)setFrameX:(CGFloat)frameX {
	CGRect frame = self.frame;
	frame.origin.x = frameX;
    
	self.frame = frame;
}

- (void)setFrameY:(CGFloat)frameY {
	CGRect frame = self.frame;
	frame.origin.y = frameY;
    
	self.frame = frame;
}

- (void)setFrameWidth:(CGFloat)frameWidth {
	CGRect frame = self.frame;
	frame.size.width = frameWidth;
    
	self.frame = frame;
}

- (void)setFrameHeight:(CGFloat)frameHeight {
	CGRect frame = self.frame;
	frame.size.height = frameHeight;
    
	self.frame = frame;
}

- (CGFloat)frameX {
	return self.frame.origin.x;
}

- (CGFloat)frameY {
	return self.frame.origin.y;
}

- (CGFloat)frameWidth {
	return self.frame.size.width;
}

- (CGFloat)frameHeight {
	return self.frame.size.height;
}

@end
