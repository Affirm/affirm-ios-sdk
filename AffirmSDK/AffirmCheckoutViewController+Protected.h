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

@property (nonatomic, assign) AffirmCheckoutType checkoutType;

/// The checkout identifier.
@property (nonatomic, strong) NSString *checkoutARI;

/// Use VCN Checkout
@property BOOL useVCN;

/// Initializer. See properties for more details.
/// @param delegate Delegate for checkout events.
/// @param checkout Checkout.
/// @param checkoutType Type of checkout opted
/// @return The initialized checkout view controller.
- (instancetype)initWithDelegate:(id<AffirmCheckoutDelegate>)delegate
                        checkout:(AffirmCheckout *)checkout
                    checkoutType:(AffirmCheckoutType)checkoutType;

/// Creates a data blob which can be sent to the Affirm API. This blob contains the checkout object, as well merchant-specific configuration information.
/// @return The checkout data blob.
- (NSData *)getCheckoutData;

/// Create an HTTP request which calls the Affirm API to create the checkout.
/// @return The HTTP request.
- (NSURLRequest *)createCheckoutRequest;

@end


NS_ASSUME_NONNULL_END
