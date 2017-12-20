//
//  NSJSONSerialization+RemovingNulls.h
//  AffirmSDK
//
//  Created by Laurent Shala on 12/20/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (RemovingNulls)

/** Converts the data to a JSON object, with the ability to all remove NSNull values. */
+ (id)AF_JSONObjectWithData:(NSData *)data
                    options:(NSJSONReadingOptions)opt
                      error:(NSError * __autoreleasing *)error
              removingNulls:(BOOL)removingNulls
               ignoreArrays:(BOOL)ignoreArrays;

@end

@interface NSMutableDictionary (RemovingNulls)

- (void)AF_recursivelyRemoveNulls;
- (void)AF_recursivelyRemoveNullsIgnoringArrays:(BOOL)ignoringArrays;

@end

@interface NSMutableArray (RemovingNulls)

- (void)AF_recursivelyRemoveNulls;
- (void)AF_recursivelyRemoveNullsIgnoringArrays:(BOOL)ignoringArrays;

@end
