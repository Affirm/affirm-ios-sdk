//
//  AffirmTestData.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/24/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AffirmCheckoutData+Protected.h"
#import "AffirmCheckoutDelegate.h"
#import "AffirmConfiguration+Protected.h"


@interface AffirmTestData : NSObject

+ (AffirmAddress *)address;
+ (AffirmContact *)contact;
+ (AffirmDiscount *)discount;
+ (AffirmItem *)item;
+ (AffirmCheckout *)checkout;
+ (AffirmConfiguration *)configuration;
+ (AffirmPricing *)pricing;

@end


@interface AffirmDummyCheckoutDelegate : NSObject <AffirmCheckoutDelegate>

@end
