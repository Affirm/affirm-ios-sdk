//
//  AffirmUtils.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/12/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "AffirmUtils.h"


@implementation AffirmNumberUtils

+ (NSNumber *)decimalDollarsToIntegerCents:(NSDecimalNumber *)decimalNumber {
    NSDecimalNumberHandler *round = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:0 raiseOnExactness:YES raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    return @([[decimalNumber decimalNumberByMultiplyingByPowerOf10:2 withBehavior:round] longLongValue]);
}

+ (NSDecimalNumber *)integerQuantityToDecimalNumber:(NSUInteger)quantity {
    return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithUnsignedLong:quantity] decimalValue]];
}

@end


@implementation AffirmValidationUtils

+ (void)checkNotNil:(id)value
               name:(NSString *)name {
    if (value == nil) {
        [NSException raise:NSInvalidArgumentException format:@"%@ must not be nil", name];
    }
}

+ (void)checkNotNil:(AffirmConfiguration *)config {
    if (config == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Configuration must be set before making call"];
    }
}

+ (void)checkNotNegative:(NSDecimalNumber *)value 
                    name:(NSString *)name {
    if ([value compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
        [NSException raise:NSInvalidArgumentException format:@"%@ must not be negative", name];
    }
}

@end

@implementation AffirmErrorUtils

+ (NSError *)errorFromInfo:(NSDictionary *)info {
    if (!info || !info[@"status_code"]) {
        return [NSError errorWithDomain:@"com.affirm.ios-sdk" code:-1 userInfo:nil];
    }
    NSInteger statusCode = [info[@"status_code"] integerValue];
    NSMutableDictionary *userInfoDic = [@{} mutableCopy];
    if (info[@"code"]) {
        userInfoDic[@"code"] = info[@"code"];
    }
    if (info[@"type"]) {
        userInfoDic[@"type"] = info[@"type"];
        userInfoDic[NSLocalizedFailureReasonErrorKey] = info[@"type"];
    }
    if (info[@"field"]) {
        userInfoDic[@"field"] = info[@"field"];
    }
    if (info[@"message"]) {
        userInfoDic[@"message"] = info[@"message"];
        userInfoDic[NSLocalizedDescriptionKey] = info[@"message"];
    }
    return [NSError errorWithDomain:[AffirmConfiguration sharedConfiguration].affirmDomain code:statusCode userInfo:userInfoDic];
}

@end

@implementation AffirmNetworkUtils

+ (void) performNetworkRequest:(NSURLRequest *)request withCompletion:(AffirmNetworkCompletion)completion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *_data, NSURLResponse *_response, NSError *error) {
        NSDictionary *data = _data ? [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil] : nil;
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)_response;
        completion(data, response, error);
    }];
    
    [dataTask resume];
}

@end
