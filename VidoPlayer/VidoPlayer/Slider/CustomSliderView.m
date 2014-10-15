//
//  CustomSliderView.m
//  iphoneBookShelf
//
//  Created by 友明 zhang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomSliderView.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomSliderView
@synthesize value,minimumValue,maximumValue;
//#define ff 20
//#define ff 20

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        sliderBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        sliderTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        sliderProgressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        loadProgressImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        sliderTrackImageView.userInteractionEnabled = YES;
        [self addSubview:sliderBackGroundImageView];
        [self addSubview:loadProgressImageView];
        [self addSubview:sliderProgressImageView];
        [self addSubview:sliderTrackImageView];
        self.backgroundColor = [UIColor clearColor];
        sliderTrackImageView.image = [UIImage imageNamed:@"point.png"];
        //        sliderTrackImageView.frame = CGRectMake(0, 0, sliderTrackImageView.image.size.width,  sliderTrackImageView.image.size.height);
        value = 0;
        followEnable = NO;
        maximumValue = 1;
        [self setValue:0];
        
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    //    sliderBackGroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [super setFrame:frame];
    //    sliderBackGroundImageView.backgroundColor = [UIColor redColor];
    sliderBackGroundImageView.frame =CGRectMake(20, 17, frame.size.width-40, frame.size.height-34);
    sliderBackGroundImageView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    sliderTrackImageView .frame= CGRectMake(0, 0, 40, 40);
    sliderProgressImageView .frame= CGRectMake(20, 17, 0, frame.size.height-34);
    sliderProgressImageView.backgroundColor = [UIColor colorWithRed:113/225.0 green:195/225.0 blue:244/225.0 alpha:1];
    
    
    loadProgressImageView .frame= CGRectMake(20, 17, 0, frame.size.height-34);
    loadProgressImageView.backgroundColor = [UIColor colorWithRed:200/225.0 green:200/225.0 blue:200/225.0 alpha:0.4];
    
    [self setValue:0];
}

-(id)initWithBackGroundImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, image.size.width , image.size.height);
    }
    return self;
}
-(void)setBackgroundImage:(UIImage *)image
{
    sliderBackGroundImageView.image = image;
}
-(void)setTrackImage:(UIImage *)image
{
    sliderTrackImageView.image = image;
    sliderTrackImageView.frame = CGRectMake(0, 0, image.size.width,  image.size.height);
}
-(void)setProgressImage:(UIImage *)image
{
    sliderProgressImageView.image = image;
    sliderProgressImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    sliderProgressImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}
-(void)setValue:(float)newValue
{
    if(tracking)return;
    if(newValue >maximumValue){
        newValue = maximumValue;
    }
    if(newValue <0)
    {
        
        newValue = 0;
    }
    if(isnan(newValue))
    {
        newValue = 0;
    }
    value = newValue;
    //    if(value == maximumValue -1)
    //    {
    //        float xOffset = self.frame.size.width - sliderTrackImageView.frame.size.width/2;
    //        sliderTrackImageView.center = CGPointMake(xOffset, self.frame.size.height/2);
    //        sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset, sliderProgressImageView.frame.size.height);
    //    }
    //    else
    //    {
    //        float xOffset = (float)value/maximumValue*self.frame.size.width;
    //        xOffset = xOffset<sliderTrackImageView.frame.size.width/2?sliderTrackImageView.frame.size.width/2:xOffset;
    //        xOffset = xOffset<self.frame.size.width - sliderTrackImageView.frame.size.width/2?xOffset:self.frame.size.width - sliderTrackImageView.frame.size.width/2;
    //        sliderTrackImageView.center = CGPointMake(xOffset, self.frame.size.height/2);
    //
    //        sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset, sliderProgressImageView.frame.size.height);
    //
    //    }
    
    float xOffset = (float)value/maximumValue*(sliderBackGroundImageView.frame.size.width);
    //        xOffset = xOffset<20?20:xOffset;
    //    NSLog(@"%f,%f",xOffset,(sliderBackGroundImageView.frame.size.width - sliderTrackImageView.frame.size.width/2));
    //        xOffset = xOffset<(sliderBackGroundImageView.frame.size.width - sliderTrackImageView.frame.size.width/2)?xOffset:(self.frame.size.width - sliderTrackImageView.frame.size.width/2);
    sliderTrackImageView.center = CGPointMake(xOffset+20, self.frame.size.height/2);
    
    sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset, sliderProgressImageView.frame.size.height);
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    
    if(progress >maximumValue){
        progress = maximumValue;
    }
    if(progress <0)
    {
        
        progress = 0;
    }
    if(isnan(progress))
    {
        progress = 0;
    }
    float xOffset = (float)progress/maximumValue*(sliderBackGroundImageView.frame.size.width);
    [UIView beginAnimations:nil context:nil];
    loadProgressImageView.frame = CGRectMake(loadProgressImageView.frame.origin.x, loadProgressImageView.frame.origin.y, xOffset, loadProgressImageView.frame.size.height);
    [UIView commitAnimations];
}
- (void)setProgress:(float)progress
{
    
}
-(void)setMaximumValue:(int)newMaximumValue
{
    maximumValue = 1;//newMaximumValue +1;
}
-(void)dealloc
{
    [loadProgressImageView removeFromSuperview];
    [sliderBackGroundImageView removeFromSuperview];
    [sliderTrackImageView removeFromSuperview];
    [sliderProgressImageView removeFromSuperview];

}


- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectZero;//[sliderProgressImageView convertRect:sliderProgressImageView.frame toView:self.superview];
}
-(void)panGestureRecognizer:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            
            //            UITouch *touch = [touches anyObject];
            CGPoint point = [pan locationInView:self];
            if(CGRectContainsPoint(CGRectMake(sliderTrackImageView.frame.origin.x-20, sliderTrackImageView.frame.origin.y-20, sliderTrackImageView.frame.size.width+40, sliderTrackImageView.frame.size.height+40), point))
            {
                float xOffset = point.x;
                xOffset = xOffset<sliderTrackImageView.frame.size.width/2?sliderTrackImageView.frame.size.width/2:xOffset;
                xOffset = xOffset<self.frame.size.width - sliderTrackImageView.frame.size.width/2?xOffset:self.frame.size.width - sliderTrackImageView.frame.size.width/2;
                sliderTrackImageView.center = CGPointMake(xOffset,  sliderTrackImageView.center.y);
                sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset-20, sliderProgressImageView.frame.size.height);
                value = xOffset/self.frame.size.width *maximumValue;
                
                tracking = YES;
                [self sendActionforEvent:UIControlEventTouchDown];
                
            }
            else
            {
                if(followEnable)
                {
                    tracking = YES;
                    float xOffset = point.x;
                    xOffset = xOffset<sliderTrackImageView.frame.size.width/2?sliderTrackImageView.frame.size.width/2:xOffset;
                    xOffset = xOffset<self.frame.size.width - sliderTrackImageView.frame.size.width/2?xOffset:self.frame.size.width - sliderTrackImageView.frame.size.width/2;
                    value = (xOffset-20)/sliderBackGroundImageView.frame.size.width *maximumValue;
                    [UIView animateWithDuration:0.2 animations:^(void){
                        [UIView beginAnimations:nil context:nil];
                        sliderTrackImageView.center = CGPointMake(xOffset,  sliderTrackImageView.center.y);
                        sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset-20, sliderProgressImageView.frame.size.height);
                    }completion:^(BOOL finished){
                        [self sendActionforEvent:UIControlEventTouchDown];
                        
                    }];
                    [UIView commitAnimations];
                }
                else
                {
                    tracking = NO;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if(!tracking)return;
            //            UITouch *touch = [touches anyObject];
            CGPoint point = [pan locationInView:self];
            
            float xOffset = point.x;
            xOffset = xOffset<sliderTrackImageView.frame.size.width/2?sliderTrackImageView.frame.size.width/2:xOffset;
            xOffset = xOffset<self.frame.size.width - sliderTrackImageView.frame.size.width/2?xOffset:self.frame.size.width - sliderTrackImageView.frame.size.width/2;
            //            NSLog(@"ggg 111");
            sliderTrackImageView.center = CGPointMake(xOffset,  sliderTrackImageView.center.y);
            //             NSLog(@"ggg 222");
            sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset-20, sliderProgressImageView.frame.size.height);
            value = (xOffset-20)/sliderBackGroundImageView.frame.size.width *maximumValue;
            NSLog(@"%f",value);
            [self sendActionforEvent:UIControlEventValueChanged];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if(!tracking)return;
            tracking = NO;
            [self sendActionforEvent:UIControlEventTouchCancel];
            [self removeLayer];
        }
            break;
        default:
            break;
    }
}
/*
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 UITouch *touch = [touches anyObject];
 CGPoint point = [touch locationInView:self];
 if(CGRectContainsPoint(sliderTrackImageView.frame, point))
 {
 float xOffset = point.x;
 xOffset = xOffset<sliderTrackImageView.frame.size.width/2?sliderTrackImageView.frame.size.width/2:xOffset;
 xOffset = xOffset<self.frame.size.width - sliderTrackImageView.frame.size.width/2?xOffset:self.frame.size.width - sliderTrackImageView.frame.size.width/2;
 sliderTrackImageView.center = CGPointMake(xOffset,  sliderTrackImageView.center.y);
 sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset-20, sliderProgressImageView.frame.size.height);
 value = xOffset/self.frame.size.width *maximumValue;
 
 tracking = YES;
 [self sendActionforEvent:UIControlEventTouchDown];
 if(!layer)
 {
 layer = [CALayer layer];
 layer.frame = CGRectMake(0, 0, sliderTrackImageView.frame.size.width*2, sliderTrackImageView.frame.size.height*2);
 layer.position = CGPointMake(sliderTrackImageView.frame.size.width/2, sliderTrackImageView.frame.size.height/2);
 layer.backgroundColor = [UIColor clearColor].CGColor;
 layer.contents = (id)[UIImage imageNamed:@"smoke.png"].CGImage;
 [sliderTrackImageView.layer addSublayer:layer];
 [self animation];
 }
 }
 else
 {
 if(followEnable)
 {
 tracking = YES;
 float xOffset = point.x;
 xOffset = xOffset<sliderTrackImageView.frame.size.width/2?sliderTrackImageView.frame.size.width/2:xOffset;
 xOffset = xOffset<self.frame.size.width - sliderTrackImageView.frame.size.width/2?xOffset:self.frame.size.width - sliderTrackImageView.frame.size.width/2;
 value = xOffset/self.frame.size.width *maximumValue;
 [UIView animateWithDuration:0.2 animations:^(void){
 [UIView beginAnimations:nil context:nil];
 sliderTrackImageView.center = CGPointMake(xOffset,  sliderTrackImageView.center.y);
 sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset-20, sliderProgressImageView.frame.size.height);
 }completion:^(BOOL finished){
 [self sendActionforEvent:UIControlEventTouchDown];
 if(!layer)
 {
 layer = [CALayer layer];
 layer.frame = CGRectMake(0, 0, sliderTrackImageView.frame.size.width*2, sliderTrackImageView.frame.size.height*2);
 layer.position = CGPointMake(sliderTrackImageView.frame.size.width/2, sliderTrackImageView.frame.size.height/2);
 layer.backgroundColor = [UIColor clearColor].CGColor;
 layer.contents = (id)[UIImage imageNamed:@"smoke.png"].CGImage;
 [sliderTrackImageView.layer addSublayer:layer];
 [self animation];
 }
 }];
 [UIView commitAnimations];
 }
 else
 {
 tracking = NO;
 }
 }
 }
 -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 if(!tracking)return;
 [self sendActionforEvent:UIControlEventTouchCancel];
 tracking = NO;
 [self removeLayer];
 }
 -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 if(!tracking)return;
 UITouch *touch = [touches anyObject];
 CGPoint point = [touch locationInView:self];
 float xOffset = point.x;
 xOffset = xOffset<sliderTrackImageView.frame.size.width/2?sliderTrackImageView.frame.size.width/2:xOffset;
 xOffset = xOffset<self.frame.size.width - sliderTrackImageView.frame.size.width/2?xOffset:self.frame.size.width - sliderTrackImageView.frame.size.width/2;
 sliderTrackImageView.center = CGPointMake(xOffset,  sliderTrackImageView.center.y);
 sliderProgressImageView.frame = CGRectMake(sliderProgressImageView.frame.origin.x, sliderProgressImageView.frame.origin.y, xOffset-20, sliderProgressImageView.frame.size.height);
 value = xOffset/self.frame.size.width *maximumValue;
 [self sendActionforEvent:UIControlEventValueChanged];
 }
 -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
 {
 if(!tracking)return;
 tracking = NO;
 [self sendActionforEvent:UIControlEventTouchCancel];
 [self removeLayer];
 }
 
 */
-(void)sendActionforEvent:(UIControlEvents)event
{
    for (id tag in [[self allTargets] allObjects]) {
        if(tag != [NSNull null])
        {
            NSArray *actions = [self actionsForTarget:tag forControlEvent:event];
            for (NSString *selString in actions) {
                SEL sel= NSSelectorFromString(selString);
                if ([tag respondsToSelector:sel]) {
                    [tag performSelector:sel withObject:self];
                }
                
            }
            
        }
    }
}

-(void)animation
{
    if(layer)
    {
        CATransform3D  transform3D =CATransform3DMakeScale(1, 1, 1);
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        rotateAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DRotate(transform3D,M_PI*2, 0, 0, 1)],[NSValue valueWithCATransform3D:CATransform3DRotate(transform3D,M_PI, 0, 0, 1)],[NSValue valueWithCATransform3D:CATransform3DRotate(transform3D,0, 0, 0, 1)], nil];
        
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1], [NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1],nil];
        
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 1.5;
        group.animations = [NSArray arrayWithObjects:rotateAnimation,opacityAnimation,nil];
        group.repeatCount = 99999999;
        [layer addAnimation:group forKey:@"group"];
        [CATransaction commit];
    }
    
}
-(void)removeLayer
{
    if(layer)
    {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
        layer = nil;
    }
}
@end
