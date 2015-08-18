//
//  AffirmCheckoutViewController.h
//  Affirm-iOS-SDK
//
//  Created by Elliot Babchick on 5/21/15.
//  Copyright (c) 2015 Affirm, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AffirmCheckoutData.h"
#import "AffirmCheckoutDelegate.h"
#import "AffirmConfiguration.h"


NS_ASSUME_NONNULL_BEGIN


/// The AffirmCheckoutViewController is the main view controller which initiates and manages the life cycle of an Affirm checkout.
@interface AffirmCheckoutViewController : UIViewController

/// Convenience constructor which creates a view controller for a new Affirm checkout.
/// @param delegate A delegate object which responds to the checkout events created by the view controller.
/// @param configuration An Affirm merchant configuration object.
/// @param checkout A checkout object which contains information about the customer and the purchase.
/// @return The newly created checkout view controller.
+ (AffirmCheckoutViewController *)checkoutControllerWithDelegate:(id<AffirmCheckoutDelegate>)delegate
                                                   configuration:(AffirmConfiguration *)configuration
                                                        checkout:(AffirmCheckout *)checkout;

/// This method logs the current user out.
/// When a user logs in and creates a checkout through Affirm, the SDK creates and stores a session which allows the user to complete multiple purchases without having to log in again each time.
/// However, it is often necessary to manually log a user out of Affirm. One common case is when the current user logs out of the app, and a new user logs in.
/// This method removes the current user session so that a new user can log in.
+ (void)logOut;


@end


NS_ASSUME_NONNULL_END