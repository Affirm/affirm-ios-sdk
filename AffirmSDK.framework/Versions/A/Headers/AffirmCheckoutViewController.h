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

@end