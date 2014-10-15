//
//  UITModalView.h
//
//
//  Created by Thilong on 13-11-27.
//  Copyright (c) 2013年 tyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITModalViewProtocol.h"

@interface UITModalView : UIView


- (id)initWithContentView:(UIView <UITModalViewProtocol> *)contentView;

/**
 *  show Modal view in specified view.
 *
 *  @param parentView which view to show in.
 *  @param animated   use fade in animation to show the modal view.
 *  @param delay      dismiss delay. 0 will not dismiss.
 */
- (void)showInView:(UIView *)parentView animated:(BOOL)animated dismissAfterDelay:(NSTimeInterval)delay;

/**
 *  dismiss
 */
- (void)dismiss;

/**
 *  set if modal view will dismiss on touch.
 *
 *  @param flag dismiss flag.
 */
- (void)setDismissOnTouch:(BOOL)flag;

@end
