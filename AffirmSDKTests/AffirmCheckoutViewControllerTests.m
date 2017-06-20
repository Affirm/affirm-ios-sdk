//
//  AffirmCheckoutViewControllerTests.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/24/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AffirmTestData.h"
#import "AffirmCheckoutViewController+Protected.h"
#import "AffirmSDKConfiguration.h"


@interface AffirmCheckoutViewControllerTests : XCTestCase

@property AffirmCheckoutViewController *viewController;

@end

@implementation AffirmCheckoutViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [AffirmCheckoutViewController checkoutControllerWithDelegate:[AffirmDummyCheckoutDelegate alloc] configuration:[AffirmTestData configuration] checkout:[AffirmTestData checkout]];
}

- (void)testCheckoutData {
    NSError *error;
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:[self.viewController getCheckoutData] options:kNilOptions error:&error];
    
    NSDictionary *rendered = @{
                               @"merchant": @{
                                       @"public_api_key": @"public_api_key",
                                       @"user_confirmation_url": @"affirm://checkout/confirmed",
                                       @"user_cancel_url": @"affirm://checkout/cancelled"
                                       },
                               @"config": @{
                                       @"financial_product_key": @"financial_product_key"
                                       },
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
    XCTAssertEqualObjects(dataDict, @{@"checkout": rendered});
}

- (void)testCreateCheckoutRequest {
    NSURLRequest *request = [self.viewController createCheckoutRequest];
    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Accept"], @"application/json");
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Content-Type"], @"application/json");
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Affirm-User-Agent"], @"Affirm-iOS-SDK");
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Affirm-User-Agent-Version"], [AffirmSDKConfiguration sharedInstance].versionNumber);
    XCTAssertEqualObjects(request.HTTPBody, [self.viewController getCheckoutData]);
}

@end
