//
//  AffirmLogger.m
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 6/8/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "AffirmLogger.h"
#import "AffirmUtils.h"
#import "AffirmConfiguration+Protected.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@implementation AffirmLogger

NSInteger logCount;

+ (void) logToTracker:(NSDictionary *)info {
    NSDictionary *infoWithContext = [self logInfoWithContext:info];
    NSData *jsonEncodedInfo = [NSJSONSerialization dataWithJSONObject:infoWithContext options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kibana_url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonEncodedInfo];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) { }];
}

+ (void) logEvent:(NSString *)title {
    [self logEvent:title info:nil];
}

+ (void) logEvent:(NSString *)title info:(NSDictionary *)info {
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] initWithDictionary:info];
    infoDic[@"event_name"] = title;
    [self logToTracker:infoDic];
}

+ (NSDictionary *) logInfoWithContext:(NSDictionary *)info {
    NSMutableDictionary *log = [[NSMutableDictionary alloc] initWithDictionary:info];
    log[@"device_type"] = [self getDeviceModel];
    log[@"release"] = [AffirmConfiguration affirmSDKVersion];
    log[@"app_name"] = [self getAppName];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    log[@"ts"] = [NSNumber numberWithLong:(long) interval];
    log[@"local_log_counter"] = [NSNumber numberWithInteger:logCount];
    logCount += 1;
    return log;
}

#pragma mark - Helpers

+ (NSString *) getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *) getAppName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFDisplayName"];
}

@end
