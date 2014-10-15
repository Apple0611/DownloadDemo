//
//  UITModalViewProtocol.h
//
//  Created by thilong on 13-12-16.
//  Copyright (c) 2013年 tyc. All rights reserved.
//

#ifndef PasswordKeeper_UITModalViewProtocol_h
#define PasswordKeeper_UITModalViewProtocol_h
#import <UIKit/UIKit.h>

@class UITModalView;

@protocol UITModalViewProtocol <NSObject>

@optional

/**
 *  callback for user to hold the UITModalView container
 *
 *  @param parentContainer UITModalView container.
 */
- (void)setModalViewContainer:(UITModalView *)parentContainer;

/**
 *  method for user to init the content view;
 */
- (void)initContentView;

/**
 *  call when user touch on the  UITModalView container.
 */
- (void)touchOnParentContainer;
@end


#endif
