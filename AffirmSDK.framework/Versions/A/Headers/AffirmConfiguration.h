//
//  AffirmCheckoutConfig.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/11/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


/// An AffirmConfiguration is a set of merchant-specific Affirm configuration settings.
@interface AffirmConfiguration : NSObject

/// The Affirm domain which hosts the API. This should either be "www.affirm.com" or "sandbox.affirm.com". Required.
@property(nonatomic, copy, readonly) NSString *affirmDomain;

/// The merchant's public API key. Required.
@property(nonatomic, copy, readonly) NSString *publicAPIKey;

/// The merchant's financial product key. Required.
@property(nonatomic, copy, readonly) NSString *financialProductKey;

/// Convenience constructor. See properties for more details.
/// @param affirmDomain Affirm domain.
/// @param publicAPIKey Public API key.
/// @param financialProductKey Financial product key.
/// @return The newly created configuration object.
+ (AffirmConfiguration *)configurationWithAffirmDomain:(NSString *)affirmDomain
                                          publicAPIKey:(NSString *)publicAPIKey
                                   financialProductKey:(NSString *)financialProductKey;

/// Initializer. See properties for more details.
/// @param affirmDomain Affirm domain.
/// @param publicAPIKey Public API key.
/// @param financialProductKey Financial product key.
/// @return The initialized configuration object.
- (instancetype)initWithAffirmDomain:(NSString *)affirmDomain
                        publicAPIKey:(NSString *)publicAPIKey
                 financialProductKey:(NSString *)financialProductKey;

@end


NS_ASSUME_NONNULL_END