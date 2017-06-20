//
//  AffirmTestData.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/24/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "AffirmTestData.h"


@implementation AffirmTestData

+ (AffirmAddress *)address {
    return [AffirmAddress addressWithLine1:@"325 Pacific Ave." line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94111" countryCode:@"USA"];
}

+ (AffirmContact *)contact {
    return [AffirmContact contactWithName:@"Test Tester" address:[self address]];
}

+ (AffirmDiscount *)discount {
    return [AffirmDiscount discountWithName:@"Affirm Test Discount" amount:[NSDecimalNumber decimalNumberWithString:@"3.00"]];
}

+ (AffirmItem *)item {
    return [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:[NSDecimalNumber decimalNumberWithString:@"15.00"] quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"] imageURL:[NSURL URLWithString:@"http://sandbox.affirm.com/image.png"]];
}

+ (AffirmCheckout *)checkout {
    return [AffirmCheckout checkoutWithItems:@[[self item]] shipping:[self contact] taxAmount:[NSDecimalNumber decimalNumberWithString:@"1.00"] shippingAmount:[NSDecimalNumber decimalNumberWithString:@"5.00"] billing:[self contact] discounts:@[[self discount]] metadata:nil];
}

+ (AffirmConfiguration *)configuration {
    return [AffirmConfiguration configurationWithAffirmDomain:@"sandbox.affirm.com" publicAPIKey:@"public_api_key"];
}

+ (AffirmPricing *)pricing {
    return [AffirmPricing pricingWithPayment:[NSDecimalNumber decimalNumberWithString:@"10.00"] paymentString:@"payment_string" termLength:[NSDecimalNumber decimalNumberWithString:@"12"] disclosure:@"my disclosure"];
}

@end


@implementation AffirmDummyCheckoutDelegate

- (void)checkoutCompleteWithToken:(NSString *)checkoutToken {
}

- (void)checkoutCancelled {
}

- (void)checkoutCreationFailedWithError:(NSError *)error {
}

@end
