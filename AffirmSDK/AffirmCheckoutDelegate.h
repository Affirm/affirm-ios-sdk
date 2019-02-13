//
//  AffirmCheckoutDelegate.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/15/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

@class AffirmCheckoutViewController;

NS_ASSUME_NONNULL_BEGIN


/// A delegate which handles checkout events.
@protocol AffirmCheckoutDelegate <NSObject>

/// This method is called when a checkout object has been successfully queried.
/// The checkout process is now ready to begin
/// @param checkoutVC The checkout VC to present to start the checkout process.
- (void)checkoutReadyToPresent:(AffirmCheckoutViewController *)checkoutVC;

/// This method is called when the user has completed the checkout.
/// @param checkoutVC The checkout VC that manages the checkout process.
/// @param checkoutToken This token represents the completed checkout.
/// It should be forwarded to your server, which should then authorize it with Affirm and create a charge.
/// For more information about the server integration, see https://docs.affirm.com/v2/api/charges
- (void)checkout:(AffirmCheckoutViewController *)checkoutVC completedWithToken:(NSString *)checkoutToken;

/// This method is called when the user has completed the vcn checkout.
/// @param checkoutVC The checkout VC that manages the vcn checkout process.
/// @param cardInfo This cardInfo represents the completed vcn checkout.
/// It should use the debit card information to fill out the checkout page and submit.
/// For more information about the server integration, see https://docs.affirm.com/v2/api/charges
- (void)vcnCheckout:(AffirmCheckoutViewController *)checkoutVC completedWithCardInfo:(NSString *)cardInfo;

/// This method is called when the user has cancelled the checkout.
/// @param checkoutVC The checkout VC that manages the checkout process.
- (void)checkoutCancelled:(AffirmCheckoutViewController *)checkoutVC;

/// This method is called when checkout creation has failed.
/// @param checkoutVC The checkout VC that manages the checkout process.
/// @param error The error.
- (void)checkout:(AffirmCheckoutViewController *)checkoutVC creationFailedWithError:(NSError *)error;

@end


NS_ASSUME_NONNULL_END
