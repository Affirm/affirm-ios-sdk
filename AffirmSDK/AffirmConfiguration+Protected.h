//
//  AffirmConfiguration+Protected.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/12/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "AffirmConfiguration.h"


NS_ASSUME_NONNULL_BEGIN

static NSString *AFFIRM_CHECKOUT_CONFIRMATION_URL = @"affirm://checkout/confirmed";
static NSString *AFFIRM_CHECKOUT_CANCELLATION_URL = @"affirm://checkout/cancelled";

static NSString *AFFIRM_PRODUCTION_DOMAIN = @"api.affirm.com";
static NSString *AFFIRM_SANDBOX_DOMAIN = @"sandbox.affirm.com";

static NSString *AFFIRM_ALA_PRODUCTION_DOMAIN = @"affirm.com";
static NSString *AFFIRM_ALA_SANDBOX_DOMAIN = @"sandbox.affirm.com";

@interface AffirmConfiguration () <NSCopying>

/// The Affirm domain which hosts the API. Points to the appropriate (production/sandbox) domain depending on the configured environment.
@property(nonatomic, copy, readonly) NSString *affirmDomain;

/// The URL for prequal
@property(readonly) NSString *affirmPrequalURL;

/// The URL for creating or viewing a checkout.
@property(readonly) NSURL *affirmCheckoutURL;

/// The URL for creating or viewing a checkout.
@property(readonly) NSURL *affirmJavascriptURL;

/// Create a URL which is prefixed by the Affirm domain.
/// @param path The URL path.
/// @return The full URL object.
- (NSURL *)affirmURLWithString:(NSString *)path;

/// The URL for loading as low as pricing.
/// @param promoId Promo ID to use in the calculation
/// @param amount Optional amount to use in calculation
/// @return URL to use to get the configuration to use to calculate the monthly payments
- (NSURL *)affirmAsLowAsURLWithPromoId:(NSString *)promoId withAmount:(NSDecimalNumber *)amount;

/// Formats string for an environment type
/// @param environment Dev environment
/// @return Formatted string from environment
- (NSString *)formatForEnvironment:(AffirmEnvironment)environment;

/// The current version of the SDK.
+ (NSString *)affirmSDKVersion;

@end


NS_ASSUME_NONNULL_END
