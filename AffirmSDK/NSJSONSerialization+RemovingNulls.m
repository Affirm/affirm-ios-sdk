//
//  NSJSONSerialization+RemovingNulls.m
//  AffirmSDK
//
//  Created by Laurent Shala on 12/20/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "NSJSONSerialization+RemovingNulls.h"

@implementation NSJSONSerialization (RemovingNulls)

+ (id)AF_JSONObjectWithData:(NSData *)data
                    options:(NSJSONReadingOptions)opt
                      error:(NSError * __autoreleasing *)error
              removingNulls:(BOOL)removingNulls
               ignoreArrays:(BOOL)ignoreArrays {
    // Mutable containers are required to remove nulls.
    if (removingNulls) {
        // Force add NSJSONReadingMutableContainers since the null removal depends on it.
        opt = opt | NSJSONReadingMutableContainers;
    }
    
    id jsonObject = [self JSONObjectWithData:data options:opt error:error];
    
    if ((error && *error) || !removingNulls) {
        return jsonObject;
    }
    
    if (![jsonObject isKindOfClass:[NSArray class]] && ![jsonObject isKindOfClass:[NSDictionary class]]) {
        return jsonObject;
    }
    
    [jsonObject AF_recursivelyRemoveNullsIgnoringArrays:ignoreArrays];
    
    return jsonObject;
}

@end

@implementation NSMutableDictionary (RemovingNulls)

- (void)AF_recursivelyRemoveNulls {
    [self AF_recursivelyRemoveNullsIgnoringArrays:NO];
}

- (void)AF_recursivelyRemoveNullsIgnoringArrays:(BOOL)ignoringArrays {
    // First, filter out directly stored nulls
    NSMutableArray *nullKeys = [NSMutableArray array];
    NSMutableArray *arrayKeys = [NSMutableArray array];
    NSMutableArray *dictionaryKeys = [NSMutableArray array];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            [nullKeys addObject:key];
        }
        else if ([obj isKindOfClass:[NSDictionary  class]]) {
            [dictionaryKeys addObject:key];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            [arrayKeys addObject:key];
        }
    }];
    
    // Remove all the nulls
    [self removeObjectsForKeys:nullKeys];
    
    // Recursively remove nulls from arrays
    for (id arrayKey in arrayKeys) {
        NSMutableArray *array = self[arrayKey];
        [array AF_recursivelyRemoveNullsIgnoringArrays:ignoringArrays];
    }
    
    // Cascade down the dictionaries
    for (id dictionaryKey in dictionaryKeys) {
        NSMutableDictionary *dictionary = self[dictionaryKey];
        [dictionary AF_recursivelyRemoveNullsIgnoringArrays:ignoringArrays];
    }
}

@end

@implementation NSMutableArray (RemovingNulls)

- (void)AF_recursivelyRemoveNulls {
    [self AF_recursivelyRemoveNullsIgnoringArrays:NO];
}

- (void)AF_recursivelyRemoveNullsIgnoringArrays:(BOOL)ignoringArrays {
    // First, filter out directly stored nulls if required
    if (!ignoringArrays) {
        [self filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return evaluatedObject != [NSNull null];
        }]];
    }
    
    NSMutableIndexSet *arrayIndexes = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *dictionaryIndexes = [NSMutableIndexSet indexSet];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary  class]]) {
            [dictionaryIndexes addIndex:idx];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            [arrayIndexes addIndex:idx];
        }
    }];
    
    // Recursively remove nulls from arrays
    for (NSMutableArray *containedArray in [self objectsAtIndexes:arrayIndexes]) {
        [containedArray AF_recursivelyRemoveNullsIgnoringArrays:ignoringArrays];
    }
    
    // Cascade down the dictionaries
    for (NSMutableDictionary *containedDictionary in [self objectsAtIndexes:dictionaryIndexes]) {
        [containedDictionary AF_recursivelyRemoveNullsIgnoringArrays:ignoringArrays];
    }
}

@end
