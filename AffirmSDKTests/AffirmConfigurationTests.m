//
//  AffirmConfigurationTests.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/29/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AffirmTestData.h"
#import "AffirmConfiguration+Protected.h"

@interface AffirmConfigurationTests : XCTestCase

@end

@implementation AffirmConfigurationTests

- (void)testURLs {
    AffirmConfiguration *config = [AffirmTestData configuration];
    XCTAssertEqualObjects([[config affirmURLWithString:@"/api/v2/checkout"] absoluteString], @"https://sandbox.affirm.com/api/v2/checkout");
    XCTAssertEqualObjects([[config affirmURLWithString:@"/argle-bargle"] absoluteString], @"https://sandbox.affirm.com/argle-bargle");
    XCTAssertEqualObjects([[config affirmURLWithString:@"/api/some_page?some_query_arg=10"] absoluteString], @"https://sandbox.affirm.com/api/some_page?some_query_arg=10");
}

@end
