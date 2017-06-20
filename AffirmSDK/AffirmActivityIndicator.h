//
//  AffirmActivityIndicator.h
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 5/31/17.
//  Copyright © 2017 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>

/// An AffirmActivityIndicator represents a loading state by displaying a loading spinner on the screen.
@interface AffirmActivityIndicator : UIView

/// The color of the spinning loading indicator
@property (strong, nonatomic) UIColor *indicatorColor;

/// The color of the path below the spinning loading indicator
@property (strong, nonatomic) UIColor *indicatorPathColor;

/// The line width of the indicator
@property (nonatomic) CGFloat indicatorLineWidth;

/// Adds the indicator to the screen and begins animating
/// @param view The view to present the loading indicator on
- (void)startAnimatingOnView:(UIView *) view;

/// Stops the loading animation and removes the indicator from the screen
- (void)stopAnimating;

@end
