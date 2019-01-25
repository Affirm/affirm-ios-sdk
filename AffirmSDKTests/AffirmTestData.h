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
#import "AffirmAsLowAsData.h"

@interface AffirmTestData : NSObject

+ (AffirmShippingDetail *)shippingDetails;
+ (AffirmDiscount *)discount;
+ (AffirmItem *)item;
+ (AffirmCheckout *)checkout;
+ (AffirmCheckout *)checkoutWithAmount;
+ (AffirmConfiguration *)configuration;

@end


@interface AffirmDummyCheckoutDelegate : NSObject <AffirmCheckoutDelegate>

@end
