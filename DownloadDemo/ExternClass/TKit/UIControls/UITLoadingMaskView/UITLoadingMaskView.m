//
//  UITLoadingMaskView.m
//  DownjoyCenter
//
//  Created by SOON on 13-9-6.
//  Copyright (c) 2013年 SOON. All rights reserved.

#import "UITLoadingMaskView.h"

@implementation UITLoadingMaskView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id) initWithFrameAndMessage:(CGRect)frame message:(NSString *)msg{
    self = [super initWithFrame:frame];
    if (self) {
        float labHeight = 40.0f; 
        message=[[UILabel alloc]initWithFrame:CGRectMake(0, (CGRectGetHeight(frame)-labHeight)/2.0, frame.size.width, labHeight)];
        [message setText:msg];
        [message setTextAlignment:NSTextAlignmentCenter];
        message.backgroundColor=[UIColor clearColor];
        [message setFont:[UIFont systemFontOfSize:15]];
//        message.textColor=APP_Select_TextColor;
        [self addSubview:message];
//        self.backgroundColor=APPLICATION_BG_Color;
    }
    return self;
}


-(void)hide{
    [self.superview sendSubviewToBack:self];
    self.hidden=YES;
}

-(void)show{
    self.hidden=NO;
    [self.superview bringSubviewToFront:self];
}


@end
