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
    [AffirmAsLowAs getAffirmAsLowAsForAmount:[NSDecimalNumber decimalNumberWithString:@"500"] promoId:@"promo_set_ios" affirmLogoType:AffirmLogoTypeSymbol affirmColor:AffirmColorTypeBlue callback:^(NSString *asLowAsText, UIImage *logo, NSError *error, BOOL success) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(asLowAsText, @"As low as $44/month with Affirm");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testALADefaultMessage {
    XCTestExpectation *expectation = [self expectationWithDescription:@"as low as default test"];
    [AffirmAsLowAs getAffirmAsLowAsForAmount:[NSDecimalNumber decimalNumberWithString:@"60"] promoId:@"promo_set_ios" affirmLogoType:AffirmLogoTypeText affirmColor:AffirmColorTypeBlack callback:^(NSString *asLowAsText, UIImage *logo, NSError *error, BOOL success) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(asLowAsText, @"As low as $11/month with Affirm");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testInvalidAmount {
    XCTestExpectation *expectation = [self expectationWithDescription:@"as low as invalid amount test"];
    [AffirmAsLowAs getAffirmAsLowAsForAmount:[NSDecimalNumber decimalNumberWithString:@"45"] promoId:@"promo_set_ios" affirmLogoType:AffirmLogoTypeSymbol affirmColor:AffirmColorTypeBlack callback:^(NSString *asLowAsText, UIImage *logo, NSError *error, BOOL success) {
        XCTAssertNil(error);
        XCTAssertEqualObjects(asLowAsText, @"Buy in monthly payments with Affirm");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

@end
