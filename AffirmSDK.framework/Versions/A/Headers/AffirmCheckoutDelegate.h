//
//  AffirmCheckoutDelegate.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/15/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//


/// A delegate which handles checkout events.
@protocol AffirmCheckoutDelegate <NSObject>

/// This method is called when the user has completed the checkout.
/// @param checkoutToken This token represents the completed checkout.
/// It should be forwarded to your server, which should then authorize it with Affirm and create a charge.
/// For more information about the server integration, see https://docs.affirm.com/v2/api/charges
- (void)checkoutCompleteWithToken:(NSString *)checkoutToken;

/// This method is called when the user has cancelled the checkout.
- (void)checkoutCancelled;

/// This method is called when checkout creation has failed.
/// @param error The error.
- (void)checkoutCreationFailedWithError:(NSError *)error;

@end
