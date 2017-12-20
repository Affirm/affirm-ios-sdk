//
//  NSJSONSerialization+RemovingNullsTests.m
//  AffirmSDKTests
//
//  Created by Laurent Shala on 12/20/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSJSONSerialization+RemovingNulls.h"

@interface NSJSONSerializationPlusRemovingNullsTests : XCTestCase
@end

@implementation NSJSONSerializationPlusRemovingNullsTests

- (void)testNullsWereRemoved {
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"not null": @"some value",
                                                             @"null": [NSNull null]}
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:NULL];
    
    NSDictionary *dict = [NSJSONSerialization AF_JSONObjectWithData:data options:0 error:NULL removingNulls:YES ignoreArrays:NO];
    
    XCTAssertEqualObjects(dict[@"not null"], @"some value");
    
    XCTAssertNotEqual(dict[@"null"], [NSNull null]);
    XCTAssertNil(dict[@"null"]);
}

@end
