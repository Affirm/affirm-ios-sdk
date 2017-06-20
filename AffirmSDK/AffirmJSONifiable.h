//
//  AffirmJSONifiable.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/16/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN


/// The AffirmJSONifiable protocol specifies that an object is JSONifiable.
@protocol AffirmJSONifiable <NSObject>

/// Create a JSON dictionary from the current object.
/// @return A JSON dictionary representing the current object.
- (NSMutableDictionary *)toJSONDictionary;

@end


NS_ASSUME_NONNULL_END