//
//  AffirmConfiguration.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/11/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// An AffirmConfiguration is a set of merchant-specific Affirm configuration settings.
@interface AffirmConfiguration : NSObject

typedef NS_ENUM(NSInteger, AffirmEnvironment) {
    AffirmEnvironmentProduction = 0,
    AffirmEnvironmentSandbox
};

/// The merchant's public API key. Required.
@property(nonatomic, copy, readonly) NSString *publicAPIKey;

/// The development environment. Required.
@property (nonatomic, assign, readonly) AffirmEnvironment environment;

/// The merchant's financial product key. Required.
@property(nonatomic, copy, readonly) NSString *financialProductKey;


/// Convenience constructor. See properties for more details.
/// @param publicAPIKey Public API key.
/// @param environment Developer environment. (Production, Sandbox)
/// @param financialProductKey Financial product key.
/// @return The newly created configuration object.
+ (AffirmConfiguration *)configurationWithPublicAPIKey:(NSString *)publicAPIKey
                                           environment:(AffirmEnvironment)environment
                                   financialProductKey:(NSString *)financialProductKey
__attribute__((deprecated));

/// Initializer. See properties for more details.
/// @param publicAPIKey Public API key.
/// @param environment Developer environment. (Production, Sandbox)
/// @param financialProductKey Financial product key.
/// @return The initialized configuration object.
- (instancetype)initWithPublicAPIKey:(NSString *)publicAPIKey
                         environment:(AffirmEnvironment) environment
                 financialProductKey:(NSString *)financialProductKey
__attribute__((deprecated));

/// Convenience constructor. See properties for more details.
/// @param publicAPIKey Public API key.
/// @param environment Developer environment. (Production, Sandbox)
/// @return The newly created configuration object.
+ (AffirmConfiguration *)configurationWithPublicAPIKey:(NSString *)publicAPIKey
                                           environment:(AffirmEnvironment)environment;

/// Initializer. See properties for more details.
/// @param publicAPIKey Public API key.
/// @param environment Developer environment. (Production, Sandbox)
/// @return The initialized configuration object.
- (instancetype)initWithPublicAPIKey:(NSString *)publicAPIKey
                         environment:(AffirmEnvironment)environment;

/// Returns the shared configuration instance
+ (instancetype)sharedConfiguration;

/// Sets configuration to the singleton
/// @param configuration The configuration to make shared instance
+ (void)setSharedConfiguration:(AffirmConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
