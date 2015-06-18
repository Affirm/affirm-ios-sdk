//
//  AffirmCheckoutDelegate.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/15/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

@protocol AffirmCheckoutDelegate <NSObject>

// A delegate which responds to checkout events.

// Called when the user has completed the checkout and created a checkout token.
// This token should be forwarded to your server, which should then authorize it with Affirm and create a charge.
// For more information about the server integration, see https://docs.affirm.com/v2/api/charges
- (void)checkoutCompleteWithToken:(NSString *)checkoutToken;

// Called when the user has cancelled the checkout.
- (void)checkoutCancelled;

// Called when checkout creation has failed.
- (void)checkoutCreationFailedWithError:(NSError *)error;

@end