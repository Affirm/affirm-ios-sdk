//
//  NSString+AffirmUtils.h
//  AffirmSDK
//
//  Created by Laurent Shala on 12/20/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AffirmUtils)

/** Returns nil when self is @"", otherwise returns self. */
- (instancetype)AF_nonEmptyValue;

@end
