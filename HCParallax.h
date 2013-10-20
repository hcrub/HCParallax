//
//  UIView+ParallaxMotion.h
//
//  Created by Neil Burchfield on 8/25/13.
//  Copyright (c) 2013 HCRUB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HCParallax)

/**-----------------------------------------------------------------------------
 * @name Parallax Accessibilities
 * -----------------------------------------------------------------------------
 */

/** Sets the parallax offset
 *
 * By default, the parallax offset for the given view is 0.0f. 
 * Changing the offset to a positive value sets the view above 
 * the parent surface. Negative values display under the surface.
 *
 * @param parallaxOffset If `> 0`, parallax effect appears above surface. Else if `< 0`,
 * parallax effect appears below.
 */

@property (nonatomic, readwrite) CGFloat parallaxOffset;


@end
