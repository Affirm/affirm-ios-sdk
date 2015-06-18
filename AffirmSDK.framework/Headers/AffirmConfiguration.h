//
//  AffirmCheckoutConfig.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/11/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AffirmConfiguration : NSObject

// An Affirm merchant configuration object.

// The Affirm domain to interface with. This should either be "www.affirm.com" or "sandbox.affirm.com". Required.
@property(nonatomic, copy, readonly) NSString *affirmDomain;

// The public API key. Required.
@property(nonatomic, copy, readonly) NSString *publicApiKey;

// The financial product key. Required.
@property(nonatomic, copy, readonly) NSString *financialProductKey;

+ (AffirmConfiguration *)configurationWithAffirmDomain:(NSString *)affirmDomain
                                          publicApiKey:(NSString *)publicApiKey
                                   financialProductKey:(NSString *)financialProductKey;

- (instancetype)initWithAffirmDomain:(NSString *)affirmDomain
                        publicApiKey:(NSString *)publicApiKey
                 financialProductKey:(NSString *)financialProductKey;

@end