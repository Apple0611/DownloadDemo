//
//  VPAdView.m
//  VidoPlayer
//
//  Created by helfy on 14-9-2.
//  Copyright (c) 2014年 helfy . All rights reserved.
//

#import "VPAdView.h"

@implementation VPAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        closeButton.backgroundColor = [UIColor grayColor];
        [self addSubview:closeButton];
        [closeButton addTarget:self
                        action:@selector(closeAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)closeAd
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
