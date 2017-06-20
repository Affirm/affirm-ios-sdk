//
//  AffirmUtilsTests.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/24/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AffirmUtils.h"


@interface AffirmNumberUtilsTests : XCTestCase
@end

@implementation AffirmNumberUtilsTests

- (void)testDecimalDollarsToIntegerCents {
    XCTAssertEqualObjects([AffirmNumberUtils decimalDollarsToIntegerCents:[NSDecimalNumber decimalNumberWithString:@"12345.67"]], @1234567);

    // NSDecimalNumber, unfortunately, doesn't work very well with floats. We need to explicitly test that it does the sane thing in most cases.
    XCTAssertEqualObjects([AffirmNumberUtils decimalDollarsToIntegerCents:[[[NSDecimalNumber alloc] initWithFloat:20] decimalNumberBySubtracting:[[NSDecimalNumber alloc] initWithFloat:0.7f]] ], @1930);
    XCTAssertEqualObjects([AffirmNumberUtils decimalDollarsToIntegerCents:[[NSDecimalNumber alloc] initWithFloat:0.03f]], @3);
}

- (void)testIntegerQuantityToDecimalNumber {
    XCTAssertEqualObjects([AffirmNumberUtils integerQuantityToDecimalNumber:7654321], [NSDecimalNumber decimalNumberWithString:@"7654321"]);
}

@end


@interface AffirmValidationUtilsTests : XCTestCase
@end

@implementation AffirmValidationUtilsTests

- (void)testCheckNotNil {
    XCTAssertNoThrow([AffirmValidationUtils checkNotNil:@"Not nil!" name:@"var name"]);
    XCTAssertThrowsSpecificNamed([AffirmValidationUtils checkNotNil:nil name:@"var name"], NSException, NSInvalidArgumentException);
}

- (void)testCheckNotNegative {
    XCTAssertNoThrow([AffirmValidationUtils checkNotNegative:[NSDecimalNumber decimalNumberWithString:@"1.00"] name:@"var name"]);
    XCTAssertNoThrow([AffirmValidationUtils checkNotNegative:[NSDecimalNumber decimalNumberWithString:@"0.00"] name:@"var name"]);
    XCTAssertThrowsSpecificNamed([AffirmValidationUtils checkNotNegative:[NSDecimalNumber decimalNumberWithString:@"-1.00"] name:@"var name"], NSException, NSInvalidArgumentException);
}

@end
