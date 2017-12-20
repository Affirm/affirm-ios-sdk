//
//  NSString+AffirmUtils.m
//  AffirmSDK
//
//  Created by Laurent Shala on 12/20/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "NSString+AffirmUtils.h"

@implementation NSString (AffirmUtils)

- (instancetype)AF_nonEmptyValue {
    return self.length > 0 ? self : nil;
}

@end
