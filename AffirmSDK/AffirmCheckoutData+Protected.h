//
//  AffirmCheckoutData+Protected.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/16/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "AffirmCheckoutData.h"

#import "AffirmJSONifiable.h"
#import "AffirmConfiguration+Protected.h"


NS_ASSUME_NONNULL_BEGIN


@interface AffirmShippingDetail () <AffirmJSONifiable, NSCopying>
@end


@interface AffirmDiscount () <AffirmJSONifiable, NSCopying>
@end


@interface AffirmItem () <AffirmJSONifiable, NSCopying>
@end


@interface AffirmCheckout () <AffirmJSONifiable, NSCopying>
@end

@interface AffirmPricing () <AffirmJSONifiable, NSCopying>
@end

@interface AffirmAsLowAs () <NSObject>
@end


NS_ASSUME_NONNULL_END
