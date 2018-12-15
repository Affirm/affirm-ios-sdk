//
//  AffirmConfiguration.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/11/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "AffirmConfiguration+Protected.h"
#import "AffirmUtils.h"

@implementation AffirmConfiguration

static AffirmConfiguration *sharedInstance = nil;

+ (instancetype)sharedConfiguration {
    return sharedInstance;
}

+ (void)setSharedConfiguration:(AffirmConfiguration *)configuration {
    sharedInstance = configuration;
}

- (instancetype)initWithPublicAPIKey:(NSString *)publicAPIKey
                         environment:(AffirmEnvironment)environment
                 financialProductKey:(NSString *)financialProductKey {
    [AffirmValidationUtils checkNotNil:publicAPIKey name:@"publicAPIKey"];
    [AffirmValidationUtils checkNotNil:financialProductKey name:@"financialProductKey"];
    
    if (self = [super init]) {
        _publicAPIKey = [publicAPIKey copy];
        _environment = environment;
        _financialProductKey = [financialProductKey copy];
        _affirmDomain = [self domainForEnvironment:environment];
    }
    return self;
}

+ (AffirmConfiguration *)configurationWithPublicAPIKey:(NSString *)publicAPIKey
                                           environment:(AffirmEnvironment)environment
                                   financialProductKey:(NSString *)financialProductKey {
    return [[self alloc] initWithPublicAPIKey:publicAPIKey environment:environment financialProductKey:financialProductKey];
}

- (instancetype)initWithPublicAPIKey:(NSString *)publicAPIKey
                         environment:(AffirmEnvironment)environment {
    [AffirmValidationUtils checkNotNil:publicAPIKey name:@"publicAPIKey"];
    
    if (self = [super init]) {
        _publicAPIKey = [publicAPIKey copy];
        _environment = environment;
        _affirmDomain = [self domainForEnvironment:environment];
    }
    return self;
}

+ (AffirmConfiguration *)configurationWithPublicAPIKey:(NSString *)publicAPIKey
                                           environment:(AffirmEnvironment)environment {
    return [[self alloc] initWithPublicAPIKey:publicAPIKey environment:environment];
}

- (NSString *)domainForEnvironment:(AffirmEnvironment)environment {
    NSString *domain = nil;
    switch (environment) {
        case AffirmEnvironmentProduction:
            domain = AFFIRM_PRODUCTION_DOMAIN;
            break;
        case AffirmEnvironmentSandbox:
            domain = AFFIRM_SANDBOX_DOMAIN;
            break;
        default:
            domain = AFFIRM_SANDBOX_DOMAIN;
            break;
    }
    return domain;
}

- (NSString *)asLowAsDomainForEnvironment:(AffirmEnvironment)environment {
    NSString *alaDomain = nil;
    switch(environment) {
        case AffirmEnvironmentProduction:
            alaDomain = AFFIRM_ALA_PRODUCTION_DOMAIN;
            break;
        case AffirmEnvironmentSandbox:
            alaDomain = AFFIRM_ALA_SANDBOX_DOMAIN;
            break;
        default:
            alaDomain = AFFIRM_ALA_SANDBOX_DOMAIN;
            break;
    }
    return alaDomain;
}

- (NSString *)formatForEnvironment:(AffirmEnvironment)environment {
    NSString *env = nil;
    switch(environment) {
        case AffirmEnvironmentProduction:
            env = @"production";
            break;
        case AffirmEnvironmentSandbox:
            env = @"sandbox";
            break;
        default:
            env = @"sandbox";
            break;
    }
    return env;
}

- (NSURL *)affirmURLWithString:(NSString *)path {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"https";
    urlComponents.host = self.affirmDomain;
    urlComponents.path = @"/";
    return [NSURL URLWithString:path relativeToURL:urlComponents.URL];
}

- (NSURL *)affirmAsLowAsURLWithString:(NSString *)path {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"https";
    urlComponents.host = [self asLowAsDomainForEnvironment:self.environment];
    urlComponents.path = @"/";
    return [NSURL URLWithString:path relativeToURL:urlComponents.URL];
}

- (NSString *)affirmPrequalURL {
    return [[self affirmURLWithString:@"/apps/prequal/"] absoluteString];
}

- (NSURL *)affirmCheckoutURL {
    return [self affirmURLWithString:@"/api/v2/checkout/"];
}

- (NSURL *)affirmJavascriptURL {
    return [self affirmURLWithString:@"/js/v2/affirm.js"];
}

- (NSString *)getAPIKey {
    return self.publicAPIKey;
}

+ (NSString *)affirmSDKVersion {
    NSBundle *sdkBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"AffirmSDK" ofType:@"bundle"]];
    return [sdkBundle objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

- (NSURL *)affirmAsLowAsURLWithPromoId:(NSString *)promoId withAmount:(NSDecimalNumber *)amount {
    NSString *baseURL = [NSString stringWithFormat:@"/api/promos/v2/%@?promo_external_id=%@&is_sdk=true&field=ala", self.publicAPIKey, promoId];
    
    if (amount) {
        baseURL = [NSString stringWithFormat:[baseURL stringByAppendingString:@"&amount=%@"], amount];
    }
    
    return [self affirmAsLowAsURLWithString:baseURL];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] configurationWithPublicAPIKey:self.publicAPIKey environment:self.environment];
}

@end
