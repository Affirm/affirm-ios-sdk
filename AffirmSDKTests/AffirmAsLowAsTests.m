//
//  AffirmAsLowAsTests.m
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 8/3/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AffirmTestData.h"
#import "AffirmAsLowAsData.h"

@interface AffirmAsLowAsTests : XCTestCase
@end

@implementation AffirmAsLowAsTests

- (void)setUp {
    AffirmConfiguration *config = [AffirmConfiguration configurationWithPublicAPIKey:@"PKNCHBIVYOT8JSOZ" environment:AffirmEnvironmentSandbox];
    [AffirmConfiguration setSharedConfiguration:config];
}

- (void)testCalculatePrice {
    XCTestExpectation *expectation = [self expectationWithDescription:@"as low as test"];
    [AffirmAsLowAs getAffirmAsLowAsForAmount:[NSDecimalNumber decimalNumberWithString:@"50000"] promoId:@"promo_set_ios" affirmLogoType:AffirmLogoTypeSymbol affirmColor:AffirmColorTypeBlue callback:^(NSString *asLowAsText, UIImage *logo, BOOL promoPrequalEnabled, NSError *error, BOOL success) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(asLowAsText, @"Starting at $44/month with Affirm. Learn more");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testALADefaultMessage {
    XCTestExpectation *expectation = [self expectationWithDescription:@"as low as default test"];
    [AffirmAsLowAs getAffirmAsLowAsForAmount:[NSDecimalNumber decimalNumberWithString:@"6000"] promoId:@"promo_set_ios" affirmLogoType:AffirmLogoTypeText affirmColor:AffirmColorTypeBlack callback:^(NSString *asLowAsText, UIImage *logo, BOOL promoPrequalEnabled, NSError *error, BOOL success) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(asLowAsText, @"Starting at $11/month with Affirm. Learn more");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testInvalidAmount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"as low as invalid amount test"];
    [AffirmAsLowAs getAffirmAsLowAsForAmount:[NSDecimalNumber decimalNumberWithString:@"4500"] promoId:@"promo_set_ios" affirmLogoType:AffirmLogoTypeSymbol affirmColor:AffirmColorTypeBlack callback:^(NSString *asLowAsText, UIImage *logo, BOOL promoPrequalEnabled, NSError *error, BOOL success) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(asLowAsText, @"Buy in monthly payments with Affirm on orders over $50. Learn more");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

@end
