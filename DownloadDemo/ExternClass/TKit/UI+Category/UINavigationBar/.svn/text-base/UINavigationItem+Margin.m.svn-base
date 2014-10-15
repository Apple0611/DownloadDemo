//
//  UINavigationItem+Margin.m
//  TUIKit
//
//  Created by Soon on 14-3-18.
//  Copyright (c) 2014年 TYC. All rights reserved.
//

#import "UINavigationItem+Margin.h"
#import "TKMicro.h"

@implementation UINavigationItem (Margin)


- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if (IS_IOS7) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -16;
        
        if (_leftBarButtonItem)
        {
            [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
        }
        else
        {
            [self setLeftBarButtonItems:@[spaceButtonItem]];
        }
        [spaceButtonItem release];
    } else {
        if (_leftBarButtonItem) {
            [self setLeftBarButtonItems:@[_leftBarButtonItem]];
        } else {
            [self setLeftBarButtonItems:nil];
        }
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if (IS_IOS7) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -16;
        
        if (_rightBarButtonItem)
        {
            [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];
        }
        else
        {
            [self setRightBarButtonItems:@[spaceButtonItem]];
        }
        [spaceButtonItem release];
    } else {
        if (_rightBarButtonItem) {
            [self setRightBarButtonItems:@[_rightBarButtonItem]];
        } else {
            [self setRightBarButtonItems:nil];
        }
    }
}

@end
