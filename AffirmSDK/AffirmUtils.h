//
//  AffirmUtils.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/12/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AffirmConfiguration+Protected.h"

NS_ASSUME_NONNULL_BEGIN


/// AffirmNumberUtils is a utility class to perform certain unit and class conversions.
/// It should really be a category for NSDecimalNumber, but XCode doesn't play well with categories in static frameworks.
@interface AffirmNumberUtils : NSObject {}

/// The SDK accepts prices as decimal dollars, but the HTTP API expects prices as integer cents. This utility method converts from one format to the other.
/// @param decimalNumber The price in decmial dollars.
/// @return The price in integer cents.
+ (NSNumber *)decimalDollarsToIntegerCents:(NSDecimalNumber *)decimalNumber;

/// The SDK accepts prices as dollars with integer cents, but for simplicity we convert the price to include only the dollars. This utility method converts from one format to the other.
/// @param decimalNumber The price in integer dollars with integer cents.
/// @return The price without integer cents.
+ (NSNumber *)dollarsByRemovingIntegerCents:(NSNumber *)decimalNumber;

/// Convert an integer quantity to a decimal number. This is helpful when multiplying certain quantities together.
/// @param quantity The integer quantity
/// @return The quantity converted to a decimal
+ (NSDecimalNumber *)integerQuantityToDecimalNumber:(NSUInteger)quantity;

@end


/// AffirmValidationUtils is a utility class which checks conditions and raises exceptions if those conditions are false.
@interface AffirmValidationUtils : NSObject {}

/// Check that a value is not nil.
/// @param value The value.
/// @param name The name of the value.
/// @exception NSException Throws NSInvalidArgumentException when the value is nil.
+ (void)checkNotNil:(id)value
               name:(NSString *)name;

/// Checks that a configration object exists
/// @param config The configuration
/// @exception NSException Throws NSInvalidArgumentException when the configuration is nil.
+ (void)checkNotNil:(AffirmConfiguration *)config;

/// Check that a NSDecimalNumber is nonnegative.
/// @param value The number.
/// @param name The name of the number.
/// @exception NSException Throws NSInvalidArgumentException when the number is negative.
+ (void)checkNotNegative:(NSDecimalNumber *)value
                    name:(NSString *)name;

@end

/// AffirmErrorUtils is a utility class that generates detailed errors
@interface AffirmErrorUtils : NSObject {}

/// Generates error and sets with appropriate metadata
/// @param info The info dictionary with error details
/// @return The generated error
+ (NSError *)errorFromInfo:(NSDictionary *)info;

@end

/// Completion handler for a network request
typedef void (^AffirmNetworkCompletion)(NSDictionary *result, NSHTTPURLResponse *response, NSError *error);

/// AffirmNetworkUtils is a utility class that performs network requests
@interface AffirmNetworkUtils: NSObject {}

/// Performs a network request
/// @param request The request to complete
/// @param completion Completion block with result of the network request
+ (void) performNetworkRequest:(NSURLRequest *) request withCompletion:(AffirmNetworkCompletion) completion;

@end

NS_ASSUME_NONNULL_END
