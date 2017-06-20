//
//  AffirmCheckoutDataTests.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/24/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AffirmTestData.h"
#import "AffirmCheckoutData+Protected.h"


@interface AffirmAddressTests : XCTestCase
@end

@implementation AffirmAddressTests

- (void)testToJSONDictionary {
    NSDictionary *rendered = @{
                               @"line1": @"325 Pacific Ave.",
                               @"line2": @"",
                               @"city": @"San Francisco",
                               @"state": @"CA",
                               @"zipcode": @"94111",
                               @"country": @"USA"
                               };
    XCTAssertEqualObjects([[AffirmTestData address] toJSONDictionary], rendered);
}

@end


@interface AffirmContactTests : XCTestCase
@end

@implementation AffirmContactTests

- (void)testToJSONDictionary {
    NSDictionary *rendered = @{
                               @"name": @{@"full": @"Test Tester"},
                               @"address":
                                   @{
                                       @"line1": @"325 Pacific Ave.",
                                       @"line2": @"",
                                       @"city": @"San Francisco",
                                       @"state": @"CA",
                                       @"zipcode": @"94111",
                                       @"country": @"USA"
                                       }
                               };
    XCTAssertEqualObjects([[AffirmTestData contact] toJSONDictionary], rendered);
}

@end


@interface AffirmDiscountTests : XCTestCase
@end

@implementation AffirmDiscountTests

- (void)testToJSONDictionary {
    NSDictionary *rendered = @{
                               @"discount_display_name": @"Affirm Test Discount",
                               @"discount_amount": @300
                               };
    XCTAssertEqualObjects([[AffirmTestData discount] toJSONDictionary], rendered);
}

@end


@interface AffirmItemTests : XCTestCase
@end

@implementation AffirmItemTests

- (void)testToJSONDictionary {
    NSDictionary *rendered = @{
                               @"display_name": @"Affirm Test Item",
                               @"sku": @"test_item",
                               @"unit_price": @1500,
                               @"qty": @1,
                               @"item_url": @"http://sandbox.affirm.com/item",
                               @"item_image_url": @"http://sandbox.affirm.com/image.png"
                               };
    XCTAssertEqualObjects([[AffirmTestData item] toJSONDictionary], rendered);
}

@end


@interface AffirmCheckoutTests : XCTestCase
@end

@implementation AffirmCheckoutTests

- (void)testToJSONDictionary {
    NSDictionary *rendered = @{
                               @"items": @{
                                   @"test_item": @{
                                       @"display_name": @"Affirm Test Item",
                                       @"sku": @"test_item",
                                       @"unit_price": @1500,
                                       @"qty": @1,
                                       @"item_url": @"http://sandbox.affirm.com/item",
                                       @"item_image_url": @"http://sandbox.affirm.com/image.png"
                                       }
                                   },
                               @"discounts": @{
                                       @"Affirm Test Discount": @{
                                               @"discount_display_name": @"Affirm Test Discount",
                                               @"discount_amount": @300
                                               }
                                       },
                               @"billing": @{
                                       @"name": @{@"full": @"Test Tester"},
                                       @"address":
                                           @{
                                               @"line1": @"325 Pacific Ave.",
                                               @"line2": @"",
                                               @"city": @"San Francisco",
                                               @"state": @"CA",
                                               @"zipcode": @"94111",
                                               @"country": @"USA"
                                               }
                                       },
                               @"shipping": @{
                                       @"name": @{@"full": @"Test Tester"},
                                       @"address":
                                           @{
                                               @"line1": @"325 Pacific Ave.",
                                               @"line2": @"",
                                               @"city": @"San Francisco",
                                               @"state": @"CA",
                                               @"zipcode": @"94111",
                                               @"country": @"USA"
                                               }
                                       },
                               @"shipping_amount": @500,
                               @"tax_amount": @100,
                               @"total": @1800,
                               @"api_version": @"v2"
                               };
    XCTAssertEqualObjects([[AffirmTestData checkout] toJSONDictionary], rendered);
}

@end

@interface AffirmPricingTests : XCTestCase
@end

@implementation AffirmPricingTests
- (void) testToJSONDictionary {
    NSDictionary *rendered = @{
                               @"payment": @10.00,
                               @"paymentString": @"payment_string",
                               @"termLength": @12,
                               @"disclosure": @"my disclosure"
                               };
    XCTAssertEqualObjects([[AffirmTestData pricing] toJSONDictionary], rendered);
}
@end

@interface AffirmAsLowAsTests : XCTestCase
@end

@implementation AffirmAsLowAsTests

- (void) testAsLowAsWithPromoId {
    AffirmConfiguration *config = [AffirmConfiguration configurationWithAffirmDomain:@"cdn1.affirm.com" publicAPIKey:@"G0IWVIM1N4U785G1"];
    AffirmAsLowAs *affirmALA = [AffirmAsLowAs asLowAsWithPromoId:@"A1A7H0XHUV9JTEHJ" affirmType:AffirmDisplayTypeText affirmColor:AffirmColorTypeDefault showLearnMore:NO configuration:config];
    
    XCTAssertEqual([affirmALA affirmColor], AffirmColorTypeDefault);
    XCTAssertEqual([affirmALA affirmType], AffirmDisplayTypeText);
    XCTAssertEqualObjects([affirmALA apr], [NSDecimalNumber decimalNumberWithString:@"0.000000"]);
    XCTAssertEqualObjects([affirmALA pricingTemplate], @"As low as {payment}/month at 0% APR with {affirm_logo}");
    XCTAssertEqual([affirmALA promoId], @"A1A7H0XHUV9JTEHJ");
    XCTAssertEqual([affirmALA showLearnMore], NO);
    XCTAssertEqualObjects([affirmALA termLength], [NSDecimalNumber decimalNumberWithString:@"12"]);
}

- (void) testCalculatePrice {
    AffirmConfiguration *config = [AffirmConfiguration configurationWithAffirmDomain:@"cdn1.affirm.com" publicAPIKey:@"G0IWVIM1N4U785G1"];
    AffirmAsLowAs *affirmALA = [AffirmAsLowAs asLowAsWithPromoId:@"A1A7H0XHUV9JTEHJ" affirmType:AffirmDisplayTypeText affirmColor:AffirmColorTypeDefault showLearnMore:NO configuration:config];
    AffirmPricing *pricing = [affirmALA calculatePrice:[NSDecimalNumber decimalNumberWithString:@"100.00"]];
    
    XCTAssertEqualObjects([pricing payment], [NSDecimalNumber decimalNumberWithString:@"833"]);
    XCTAssertEqualObjects([pricing paymentString], @"9");
}

- (void) testFormatAffirmTypeToString {
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmTypeToString:AffirmDisplayTypeText], @"text");
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmTypeToString:AffirmDisplayTypeLogo], @"logo");
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmTypeToString:AffirmDisplayTypeSymbol], @"solid");
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmTypeToString:AffirmDisplayTypeSymbolHollow], @"hollow");
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmTypeToString:AffirmDisplayTypeDefault], @"logo");
}

- (void) testFormatAffirmColorToString {
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmColorToString:AffirmColorTypeDefault], @"blue");
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmColorToString:AffirmColorTypeBlue], @"blue");
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmColorToString:AffirmColorTypeWhite], @"white");
    XCTAssertEqualObjects([AffirmAsLowAs formatAffirmColorToString:AffirmColorTypeBlack], @"black");
}

- (void) testFormatBoolToString {
    XCTAssertEqualObjects([AffirmAsLowAs formatBoolToString:YES], @"true");
    XCTAssertEqualObjects([AffirmAsLowAs formatBoolToString:NO], @"false");
}

@end
