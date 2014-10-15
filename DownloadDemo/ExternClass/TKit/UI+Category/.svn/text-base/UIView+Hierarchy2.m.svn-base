//
//  UIView+Hierarchy.m
//  TLibrary
//
//  Created by thilong on 12-4-5.
//  Copyright (c) 2012年 TYC. All rights reserved.
//

#import "UIView+Hierarchy2.h"

@implementation UIView (Hierarchy2)

- (NSInteger)getSubviewIndex {
	return [self.superview.subviews indexOfObject:self];
}

- (void)bringToFront {
	[self.superview bringSubviewToFront:self];
}

- (void)sendToBack {
	[self.superview sendSubviewToBack:self];
}

- (void)bringOneLevelUp {
	NSInteger currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex + 1];
}

- (void)sendOneLevelDown {
	NSInteger currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex - 1];
}

- (BOOL)isInFront {
	return ([self.superview.subviews lastObject] == self);
}

- (BOOL)isAtBack {
	return ([self.superview.subviews objectAtIndex:0] == self);
}

- (void)swapDepthsWithView:(UIView *)swapView {
	[self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}

- (void)removeAllSubviews {
	for (UIView *v  in self.subviews) {
        [v removeFromSuperview];
    }
}

@end
