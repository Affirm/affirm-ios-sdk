//
//  AffirmCheckoutViewController+Protected.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/29/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "AffirmCheckoutViewController.h"


NS_ASSUME_NONNULL_BEGIN


@interface AffirmCheckoutViewController ()

/// The Affirm configuration.
@property (nonatomic, copy, readwrite) AffirmConfiguration *configuration;

/// The delegate which handles checkout events.
@property (nonatomic, weak) id<AffirmCheckoutDelegate> delegate;

/// The checkout identifier.
@property (nonatomic, strong) NSString *checkoutARI;

/// Initializer. See properties for more details.
/// @param delegate Delegate for checkout events.
/// @param checkout Checkout.
/// @return The initialized checkout view controller.
- (instancetype)initWithDelegate:(id<AffirmCheckoutDelegate>)delegate
                        checkout:(AffirmCheckout *)checkout;

/// Creates a data blob which can be sent to the Affirm API. This blob contains the checkout object, as well merchant-specific configuration information.
/// @return The checkout data blob.
- (NSData *)getCheckoutData;

/// Create an HTTP request which calls the Affirm API to create the checkout.
/// @return The HTTP request.
- (NSURLRequest *)createCheckoutRequest;

@end


NS_ASSUME_NONNULL_END
