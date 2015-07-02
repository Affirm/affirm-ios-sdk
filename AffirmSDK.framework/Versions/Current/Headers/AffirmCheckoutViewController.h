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

@interface AffirmCheckoutViewController : UIViewController

// The view controller which initiates and manages the checkout life cycle.

// The constructor takes the following parameters:
// 1. A delegate object which responds to the checkout events created by the view controller.
// 2. An Affirm merchant configuration object.
// 3. A checkout object which contains information about the customer and the purchase.
+ (AffirmCheckoutViewController *)checkoutControllerWithDelegate:(id<AffirmCheckoutDelegate>)delegate
                                                   configuration:(AffirmConfiguration *)configuration
                                                        checkout:(AffirmCheckout *)checkout;

// This method logs the user out.
// When a checkout is initiated, the user is first asked to log in to Affirm. The user remains logged in for a period of time, allowing them to complete multiple purchases without having to log in each time.
// However, sometimes it is necessary to manually log a user out of Affirm. (For example: a user logs out of the app, and a new user logs in.) This method implements that functionality.

+ (void)logOut;

@end