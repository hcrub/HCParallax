//
//  HCParallax.m
//
//  Created by Neil Burchfield on 8/25/13.
//  Copyright (c) 2013 HCRUB. All rights reserved.
//

#import "HCParallax.h"
#import <objc/runtime.h>

///////////////////////////////////////////////////////////////////////
// Class Statics
///////////////////////////////////////////////////////////////////////

static void *const     kHCParallaxOffsetKey = (void *)&kHCParallaxOffsetKey;
static NSString *const kHCCenterXOffsetKey  = @"center.x";
static NSString *const kHCCenterYOffsetKey  = @"center.y";

@implementation UIView (HCParallax)

///////////////////////////////////////////////////////////////////////
// Parallax Offset Group Key if if iOS > 7
///////////////////////////////////////////////////////////////////////

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
#warning HCParallax DISABLED WITHOUT IOS 7 SDK
#else
static void *const kHCParallaxMotionEffectGroupKey = (void *)&kHCParallaxMotionEffectGroupKey;
#endif

///////////////////////////////////////////////////////////////////////
// Set Offset
///////////////////////////////////////////////////////////////////////

- (void)setParallaxOffset:(CGFloat)parallaxOffset {
    
    if (self.parallaxOffset == parallaxOffset) {
        return;
    }
    
    ///////////////////////////////////////////////////////////////////////
    // Set Offset Key
    ///////////////////////////////////////////////////////////////////////
    
    objc_setAssociatedObject(self, kHCParallaxOffsetKey, @(parallaxOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    ///////////////////////////////////////////////////////////////////////
    // Only if iOS > 7
    ///////////////////////////////////////////////////////////////////////
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    if (![UIInterpolatingMotionEffect class]) {
        return;
    }
    
    ///////////////////////////////////////////////////////////////////////
    // Reset Offset
    ///////////////////////////////////////////////////////////////////////
    
    if (parallaxOffset == 0.0) {
        [self removeMotionEffect:[self HC_parallaxMotionEffectGroup]];
        [self HC_setParallaxMotionEffectGroup:nil];
        return;
    }
    
    ///////////////////////////////////////////////////////////////////////
    // Add parallax
    ///////////////////////////////////////////////////////////////////////
    
    UIMotionEffectGroup *parallaxGroup = [self HC_parallaxMotionEffectGroup];
    
    if (!parallaxGroup) {
        parallaxGroup = [[UIMotionEffectGroup alloc] init];
        [self HC_setParallaxMotionEffectGroup:parallaxGroup];
        [self addMotionEffect:parallaxGroup];
    }
    
    ///////////////////////////////////////////////////////////////////////
    // Set KVO X Axis
    ///////////////////////////////////////////////////////////////////////
    
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:kHCCenterXOffsetKey type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    ///////////////////////////////////////////////////////////////////////
    // Set KVO Y Axis
    ///////////////////////////////////////////////////////////////////////
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:kHCCenterYOffsetKey type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    NSArray *motionEffects = @[xAxis, yAxis];
    
    ///////////////////////////////////////////////////////////////////////
    // Append Offset to as max/min
    ///////////////////////////////////////////////////////////////////////
    
    for (UIInterpolatingMotionEffect *uiMotionEffect in motionEffects) {
        uiMotionEffect.maximumRelativeValue = @(parallaxOffset);
        uiMotionEffect.minimumRelativeValue = @(-parallaxOffset);
    }
    
    ///////////////////////////////////////////////////////////////////////
    // Set Offset
    ///////////////////////////////////////////////////////////////////////
    
    parallaxGroup.motionEffects = motionEffects;
    
#endif
}

///////////////////////////////////////////////////////////////////////
// Set Parallax Offset Value
///////////////////////////////////////////////////////////////////////

- (CGFloat)parallaxOffset {
    
    NSNumber *val = objc_getAssociatedObject(self, kHCParallaxOffsetKey);
    
    if (!val) {
        return 0.0;
    }
    
    return val.doubleValue;
}

#pragma mark -

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

///////////////////////////////////////////////////////////////////////
// Get Offset Key
///////////////////////////////////////////////////////////////////////

- (UIMotionEffectGroup *)HC_parallaxMotionEffectGroup {
    return objc_getAssociatedObject(self, kHCParallaxMotionEffectGroupKey);
}

///////////////////////////////////////////////////////////////////////
// Set Offset Key Group
///////////////////////////////////////////////////////////////////////

- (void)HC_setParallaxMotionEffectGroup:(UIMotionEffectGroup *)group {
    objc_setAssociatedObject(self, kHCParallaxMotionEffectGroupKey, group, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSAssert(group == objc_getAssociatedObject(self, kHCParallaxMotionEffectGroupKey), @"Error: objc_setAssociatedObject didn't set object/value pair");
}

#endif

@end


