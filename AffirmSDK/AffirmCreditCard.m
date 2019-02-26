//
//  AffirmCreditCard.m
//  AffirmSDK
//
//  Created by yijie on 2019/2/15.
//

#import "AffirmCreditCard.h"
#import "AffirmUtils.h"

@implementation AffirmCreditCardBillAddress

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _city               =       dict[@"city"];
        _state              =       dict[@"state"];
        _zipcode            =       dict[@"zipcode"];
        _line1              =       dict[@"line1"];
        _line2              =       dict[@"line2"];
    }
    return self;
}

@end

@implementation AffirmCreditCard

+ (AffirmCreditCard *)creditCardWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        if (dict[@"billing_address"] != nil
            && [dict[@"billing_address"] isKindOfClass:[NSDictionary class]]) {
            _billing_address = [[AffirmCreditCardBillAddress alloc] initWithDict:dict[@"billing_address"]];
        }
        
        [AffirmValidationUtils checkNotNil:dict[@"checkout_token"] name:@"checkout_token"];
        [AffirmValidationUtils checkNotNil:dict[@"cvv"] name:@"cvv"];
        [AffirmValidationUtils checkNotNil:dict[@"number"] name:@"number"];
        [AffirmValidationUtils checkNotNil:dict[@"cardholder_name"] name:@"cardholder_name"];
        [AffirmValidationUtils checkNotNil:dict[@"callback_id"] name:@"callback_id"];
        [AffirmValidationUtils checkNotNil:dict[@"expiration"] name:@"expiration"];
        [AffirmValidationUtils checkNotNil:dict[@"id"] name:@"creditCard_id"];
        
        _checkout_token     =       dict[@"checkout_token"];
        _created            =       dict[@"created"];
        _cvv                =       dict[@"cvv"];
        _number             =       dict[@"number"];
        _callback_id        =       dict[@"callback_id"];
        _cardholder_name    =       dict[@"cardholder_name"];
        _expiration         =       dict[@"expiration"];
        _creditCard_id      =       dict[@"id"];
    }
    return self;
}

@end
