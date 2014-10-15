//
//  CustomSliderView.h
//  ;
//
//  Created by 友明 zhang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSliderView : UIControl
{
    int maximumValue;
    int minimumValue;
    float value;
    // UISlider
    
    UIImageView *sliderBackGroundImageView;
    UIImageView *sliderTrackImageView;
    
    UIImageView *sliderProgressImageView;
    UIImageView *loadProgressImageView;
    
    BOOL tracking;
    BOOL followEnable;
    CALayer *layer;
    
}
@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) int minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) int maximumValue;                          // default 1.0. the current value may change if outside new max value
-(void)setBackgroundImage:(UIImage *)image;
-(void)setTrackImage:(UIImage *)image;
-(void)setProgressImage:(UIImage *)image;
-(void)sendActionforEvent:(UIControlEvents)event;
-(void)removeLayer;
-(void)animation;

- (CGRect)trackRectForBounds:(CGRect)bounds;
- (void)setProgress:(float)progress animated:(BOOL)animated;
- (void)setProgress:(float)progress ;
@end
