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
#import "AffirmBaseModalViewController+Protected.h"

NS_ASSUME_NONNULL_BEGIN


/// The AffirmCheckoutViewController is the main view controller which initiates and manages the life cycle of an Affirm checkout.
@interface AffirmCheckoutViewController : AffirmBaseModalViewController

typedef NS_ENUM(NSInteger, AffirmCheckoutType) {
    AffirmCheckoutTypeAutomatic = 0,
    AffirmCheckoutTypeManual
};

/// The checkout object used to start the checkout process.
@property (nonatomic, copy, readwrite) AffirmCheckout *checkout;

/// Convenience constructor starts the checkout process and notifies delegate regarding checkout events, useVCN is NO as default
/// @param checkout A checkout object which contains information about the customer and the purchase.
/// @param checkoutType Specifies whether loading and error displays for the checkout process should be provided by the SDK (Automatic) or will be handled by the developer (Manual)
/// @param delegate A delegate object which responds to the checkout events created by the view controller.
/// @return The newly created checkout view controller.
+ (AffirmCheckoutViewController *)startCheckout:(AffirmCheckout *)checkout
                                   checkoutType:(AffirmCheckoutType)checkoutType
                                       delegate:(id<AffirmCheckoutDelegate>)delegate;

/// Convenience constructor starts the checkout process and notifies delegate regarding checkout events
/// @param checkout A checkout object which contains information about the customer and the purchase.
/// @param checkoutType Specifies whether loading and error displays for the checkout process should be provided by the SDK (Automatic) or will be handled by the developer (Manual)
/// @param useVCN A boolean which determines whether the checkout flow should use virtual card network to handle the checkout
/// @param delegate A delegate object which responds to the checkout events created by the view controller.
/// @return The newly created checkout view controller.
+ (AffirmCheckoutViewController *)startCheckout:(AffirmCheckout *)checkout
                                   checkoutType:(AffirmCheckoutType)checkoutType
                                         useVCN:(BOOL)useVCN
                                       delegate:(id<AffirmCheckoutDelegate>)delegate;

/// This method logs the current user out.
/// When a user logs in and creates a checkout through Affirm, the SDK creates and stores a session which allows the user to complete multiple purchases without having to log in again each time.
/// However, it is often necessary to manually log a user out of Affirm. One common case is when the current user logs out of the app, and a new user logs in.
/// This method removes the current user session so that a new user can log in.
+ (void)logOut;

@end


NS_ASSUME_NONNULL_END
