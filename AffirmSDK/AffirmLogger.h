//
//  AffirmLogger.h
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 6/8/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kibana_url = @"https://tracker.affirm-stage.com/collect";

@interface AffirmLogger : NSObject

+ (void) logToTracker:(NSDictionary *)info;
+ (void) logEvent:(NSString *)title;
+ (void) logEvent:(NSString *)title info:(NSDictionary *)info;

@end
