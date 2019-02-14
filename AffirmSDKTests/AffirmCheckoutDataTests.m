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
#import "AffirmAsLowAsData.h"

@interface AffirmShippingDetailTests : XCTestCase
@end

@implementation AffirmShippingDetailTests

- (void)testToJSONDictionary {
    NSDictionary *addressDetails = @{
                              @"line1": @"325 Pacific Ave.",
                              @"line2": @"",
                              @"city": @"San Francisco",
                              @"state": @"CA",
                              @"zipcode": @"94111",
                              @"country": @"USA"
                              };
    NSDictionary *shippingDetailDic = @{
                               @"billing": @{@"address": addressDetails, @"name": @{@"full": @"Test Tester"}},
                               @"shipping": @{@"address": addressDetails, @"name": @{@"full": @"Test Tester"}}
                               };

    XCTAssertEqualObjects([[AffirmTestData shippingDetails] toJSONDictionary], shippingDetailDic);
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
                               @"item_url": @"http://sandbox.affirm.com/item"
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
                               @"total": @2100,
                               @"api_version": @"v2"
                               };
    XCTAssertEqualObjects([[AffirmTestData checkout] toJSONDictionary], rendered);
}

- (void)testToJSONDictionaryWithAmount {
    NSDictionary *rendered = @{
                               @"items": @{
                                       @"test_item": @{
                                               @"display_name": @"Affirm Test Item",
                                               @"sku": @"test_item",
                                               @"unit_price": @1500,
                                               @"qty": @1,
                                               @"item_url": @"http://sandbox.affirm.com/item",
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
                               @"shipping_amount": @0,
                               @"tax_amount": @0,
                               @"total": @5000,
                               @"api_version": @"v2"
                               };
    XCTAssertEqualObjects([[AffirmTestData checkoutWithAmount] toJSONDictionary], rendered);
}

@end
