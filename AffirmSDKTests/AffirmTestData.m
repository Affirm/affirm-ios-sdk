//
//  AffirmTestData.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/24/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "AffirmTestData.h"


@implementation AffirmTestData

+ (AffirmShippingDetail *)shippingDetails {
    return [AffirmShippingDetail shippingDetailWithName:@"Test Tester" addressWithLine1:@"325 Pacific Ave." line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94111" countryCode:@"USA"];
}

+ (AffirmDiscount *)discount {
    return [AffirmDiscount discountWithName:@"Affirm Test Discount" amount:[NSDecimalNumber decimalNumberWithString:@"3.00"]];
}

+ (AffirmItem *)item {
    return [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:[NSDecimalNumber decimalNumberWithString:@"15.00"] quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"]];
}

+ (AffirmCheckout *)checkout {
    return [AffirmCheckout checkoutWithItems:@[[self item]] shipping:[self shippingDetails] taxAmount:[NSDecimalNumber decimalNumberWithString:@"1.00"] shippingAmount:[NSDecimalNumber decimalNumberWithString:@"5.00"]];
}

+ (AffirmCheckout *)checkoutWithAmount {
    return [AffirmCheckout checkoutWithItems:@[[self item]] shipping:[self shippingDetails] totalAmount:[NSDecimalNumber decimalNumberWithString:@"5000"]];
}

+ (AffirmConfiguration *)configuration {
    return [AffirmConfiguration configurationWithPublicAPIKey:@"public_api_key" environment:AffirmEnvironmentSandbox];
}

@end

@implementation AffirmDummyCheckoutDelegate

- (void)checkoutReadyToPresent:(AffirmCheckoutViewController *)checkoutVC {
}

- (void)checkout:(AffirmCheckoutViewController *)checkoutVC completedWithToken:(NSString *)checkoutToken {
}

- (void)checkoutCancelled:(AffirmCheckoutViewController *)checkoutVC {
}

- (void)checkout:(AffirmCheckoutViewController *)checkoutVC creationFailedWithError:(NSError *)error {
}

@end
