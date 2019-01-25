//
//  AffirmCheckoutData.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/16/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//:

#import "AffirmCheckoutData+Protected.h"
#import "AffirmUtils.h"

@implementation AffirmShippingDetail

+ (AffirmShippingDetail *)shippingDetailWithName:(NSString *)name
                                addressWithLine1:(NSString *)line1
                                           line2:(NSString *)line2
                                            city:(NSString *)city
                                           state:(NSString *)state
                                         zipCode:(NSString *)zipCode
                                     countryCode:(NSString *)countryCode {
    return [[self alloc] initShippingDetailWithName:name email:nil phoneNumber:nil addressWithLine1:line1 line2:line2 city:city state:state zipCode:zipCode countryCode:countryCode];
}

+ (AffirmShippingDetail *)shippingDetailWithName:(NSString *)name
                                           email:(nullable NSString *)email
                                     phoneNumber:(nullable NSString *)phoneNumber
                                addressWithLine1:(NSString *)line1
                                           line2:(NSString *)line2
                                            city:(NSString *)city
                                           state:(NSString *)state
                                         zipCode:(NSString *)zipCode
                                     countryCode:(NSString *)countryCode {
    return [[self alloc] initShippingDetailWithName:name email:email phoneNumber:phoneNumber addressWithLine1:line1 line2:line2 city:city state:state zipCode:zipCode countryCode:countryCode];
}

- (instancetype)initShippingDetailWithName:(NSString *)name
                                     email:(nullable NSString *)email
                               phoneNumber:(nullable NSString *)phoneNumber
                          addressWithLine1:(NSString *)line1
                                     line2:(NSString *)line2
                                      city:(NSString *)city
                                     state:(NSString *)state
                                   zipCode:(NSString *)zipCode
                               countryCode:(NSString *)countryCode {
    [AffirmValidationUtils checkNotNil:name name:@"name"];
    [AffirmValidationUtils checkNotNil:line1 name:@"line1"];
    [AffirmValidationUtils checkNotNil:line2 name:@"line2"];
    [AffirmValidationUtils checkNotNil:city name:@"city"];
    [AffirmValidationUtils checkNotNil:state name:@"state"];
    [AffirmValidationUtils checkNotNil:zipCode name:@"zipCode"];
    [AffirmValidationUtils checkNotNil:countryCode name:@"countryCode"];
    
    if (self = [super init]) {
        _name = [name copy];
        _email = [email copy];
        _phoneNumber = [phoneNumber copy];
        _line1 = [line1 copy];
        _line2 = [line2 copy];
        _city = [city copy];
        _state = [state copy];
        _zipCode = [zipCode copy];
        _countryCode = [countryCode copy];
    }
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSDictionary *jsonDic = @{
                              @"shipping": [self getShippingJSONDictionary],
                              @"billing": [self getBillingJSONDictionary]
                              };
    return jsonDic;
}

- (NSDictionary *)getShippingJSONDictionary {
    NSDictionary *address =  @{
                               @"line1": self.line1,
                               @"line2": self.line2,
                               @"city": self.city,
                               @"state": self.state,
                               @"zipcode": self.zipCode,
                               @"country": self.countryCode
                               };
    NSDictionary *jsonDic = @{
                              @"address": address,
                              @"name": @{@"full": self.name}
                              };
    return jsonDic;
    
}

- (NSDictionary *)getBillingJSONDictionary {
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionaryWithDictionary:[self getShippingJSONDictionary]];
    if (self.email) {
        jsonDic[@"email"] = self.email;
    }
    if (self.phoneNumber) {
        jsonDic[@"phone_number"] = self.phoneNumber;
    }
    return jsonDic;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] shippingDetailWithName:self.name email:self.email phoneNumber:self.phoneNumber addressWithLine1:self.line1 line2:self.line2 city:self.city state:self.state zipCode:self.zipCode countryCode:self.countryCode];
}

@end

@implementation AffirmDiscount

- (instancetype)initWithName:(NSString *)name
                      amount:(NSDecimalNumber *)amount {
    [AffirmValidationUtils checkNotNil:name name:@"name"];
    [AffirmValidationUtils checkNotNil:amount name:@"amount"];
    [AffirmValidationUtils checkNotNegative:amount name:@"amount"];
    
    if (self = [super init]) {
        _name = [name copy];
        _amount = [amount copy];
    }
    return self;
}

+ (AffirmDiscount *)discountWithName:(NSString *)name
                              amount:(NSDecimalNumber *)amount {
    return [[self alloc] initWithName:name amount:amount];
}

- (NSDictionary *)toJSONDictionary {
    return @{
             @"discount_display_name": self.name,
             @"discount_amount": [AffirmNumberUtils decimalDollarsToIntegerCents:self.amount]
             };
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] discountWithName:self.name amount:self.amount];
}

@end

@implementation AffirmItem

- (instancetype)initWithName:(NSString *)name
                         SKU:(NSString *)SKU
                   unitPrice:(NSDecimalNumber *)unitPrice
                    quantity:(NSUInteger)quantity
                         URL:(NSURL *)URL {
    [AffirmValidationUtils checkNotNil:name name:@"name"];
    [AffirmValidationUtils checkNotNil:SKU name:@"SKU"];
    [AffirmValidationUtils checkNotNil:unitPrice name:@"unitPrice"];
    [AffirmValidationUtils checkNotNegative:unitPrice name:@"unitPrice"];
    [AffirmValidationUtils checkNotNil:URL name:@"URL"];
    
    if (self = [super init]) {
        _name = [name copy];
        _SKU = [SKU copy];
        _unitPrice = [unitPrice copy];
        _quantity = quantity;
        _URL = [URL copy];
    }
    return self;
}

+ (AffirmItem *)itemWithName:(NSString *)name
                         SKU:(NSString *)SKU
                   unitPrice:(NSDecimalNumber *)unitPrice
                    quantity:(NSUInteger)quantity
                         URL:(NSURL *)URL {
    return [[self alloc] initWithName:name SKU:SKU unitPrice:unitPrice quantity:quantity URL:URL];
}

- (NSDictionary *)toJSONDictionary {
    return @{
             @"display_name": self.name,
             @"sku": self.SKU,
             @"unit_price": [AffirmNumberUtils decimalDollarsToIntegerCents:self.unitPrice],
             @"qty": @(self.quantity),
             @"item_url": [self.URL absoluteString],
             };
}

- (id) copyWithZone:(NSZone *)zone {
    return [[self class] itemWithName:self.name SKU:self.SKU unitPrice:self.unitPrice quantity:self.quantity URL:self.URL];
}

@end


@implementation AffirmCheckout

- (instancetype)initWithItems:(NSArray <AffirmItem *>*)items
                     shipping:(AffirmShippingDetail *)shipping
                    taxAmount:(NSDecimalNumber *)taxAmount
               shippingAmount:(NSDecimalNumber *)shippingAmount
                    discounts:(NSArray <AffirmDiscount *>*)discounts
                     metadata:(NSDictionary *)metadata
             financingProgram:(NSString *)financingProgram {
    [AffirmValidationUtils checkNotNil:items name:@"items"];
    [AffirmValidationUtils checkNotNil:shipping name:@"shipping"];
    [AffirmValidationUtils checkNotNil:shipping.name name:@"shipping.name"];
    
    [AffirmValidationUtils checkNotNil:taxAmount name:@"taxAmount"];
    [AffirmValidationUtils checkNotNegative:taxAmount name:@"taxAmount"];
    [AffirmValidationUtils checkNotNil:shippingAmount name:@"shippingAmount"];
    [AffirmValidationUtils checkNotNegative:shippingAmount name:@"shippingAmount"];
    
    if (self = [super init]) {
        _items = [[NSArray alloc] initWithArray:items copyItems:YES];
        _shipping = [shipping copy];
        _taxAmount = [taxAmount copy];
        _shippingAmount = [shippingAmount copy];
        _discounts = (discounts) ? [[NSArray alloc] initWithArray:discounts copyItems:YES] : nil;
        _metadata = (metadata) ? [[NSDictionary alloc] initWithDictionary:metadata copyItems:YES] : nil;
        _financingProgram = (financingProgram) ? [financingProgram copy] : nil;
    }
    return self;
}

+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                     financingProgram:(nullable NSString *)financingProgram {
    return [self checkoutWithItems:items shipping:shipping taxAmount:taxAmount shippingAmount:shippingAmount discounts:nil metadata:nil financingProgram:financingProgram];
}

+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                            discounts:(NSArray <AffirmDiscount *>*)discounts
                             metadata:(NSDictionary *)metadata
                     financingProgram:(NSString *)financingProgram {
    return [[self alloc] initWithItems:items shipping:shipping taxAmount:taxAmount shippingAmount:shippingAmount discounts:discounts metadata:metadata financingProgram:financingProgram];
}

+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount {
    return [self checkoutWithItems:items shipping:shipping taxAmount:taxAmount shippingAmount:shippingAmount discounts:nil metadata:nil financingProgram:nil];
}

+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                            discounts:(NSArray <AffirmDiscount *>*)discounts
                             metadata:(NSDictionary *)metadata {
    return [[self alloc] initWithItems:items shipping:shipping taxAmount:taxAmount shippingAmount:shippingAmount discounts:discounts metadata:metadata financingProgram:nil];
}

+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                          totalAmount:(NSNumber *)totalAmount {
    return [[self alloc] initWithItems:items shipping:shipping discounts:nil metadata:nil financingProgram:nil totalAmount:totalAmount];
}

- (instancetype)initWithItems:(NSArray <AffirmItem *>*)items
                     shipping:(AffirmShippingDetail *)shipping
                    discounts:(NSArray <AffirmDiscount *>*)discounts
                     metadata:(NSDictionary *)metadata
             financingProgram:(NSString *)financingProgram
                  totalAmount:(nullable NSNumber *)totalAmount {
    self = [self initWithItems:items shipping:shipping taxAmount:nil shippingAmount:nil discounts:discounts metadata:metadata financingProgram:financingProgram];
    if (self) {
        [AffirmValidationUtils checkNotNil:totalAmount name:@"totalAmount"];
        [AffirmValidationUtils checkNotNegative:[NSDecimalNumber decimalNumberWithDecimal:[totalAmount decimalValue]] name:@"totalAmount"];
        self.totalAmount = totalAmount;
    }
    return self;
}

- (NSDecimalNumber *)total {
    [AffirmValidationUtils checkNotNil:self.taxAmount name:@"taxAmount"];
    [AffirmValidationUtils checkNotNil:self.shippingAmount name:@"shippingAmount"];
    
    NSDecimalNumber *total = [self.taxAmount decimalNumberByAdding:self.shippingAmount];
    for (AffirmItem *item in self.items) {
        total = [total decimalNumberByAdding:[item.unitPrice decimalNumberByMultiplyingBy:[AffirmNumberUtils integerQuantityToDecimalNumber:item.quantity]]];
    }
    for (AffirmDiscount *discount in self.discounts) {
        total = [total decimalNumberBySubtracting:discount.amount];
    }
    return total;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
    for (AffirmItem *item in self.items) {
        [items setObject:[item toJSONDictionary] forKey:item.SKU];
    }
    
    NSMutableDictionary *dict = [@{
                                   @"items": items,
                                   @"total": (self.totalAmount) ? self.totalAmount : [AffirmNumberUtils decimalDollarsToIntegerCents:[self total]],
                                   @"api_version" :@"v2"
                                   } mutableCopy];
    
    [dict addEntriesFromDictionary:[self.shipping toJSONDictionary]];
    
    if (self.shippingAmount != nil) {
        [dict setValue:[AffirmNumberUtils decimalDollarsToIntegerCents:self.shippingAmount] forKey:@"shipping_amount"];
    }
    
    if (self.taxAmount != nil) {
        [dict setValue:[AffirmNumberUtils decimalDollarsToIntegerCents:self.taxAmount] forKey:@"tax_amount"];
    }
    
    if (self.discounts != nil) {
        NSMutableDictionary *discounts = [[NSMutableDictionary alloc] init];
        for (AffirmDiscount *discount in self.discounts) {
            [discounts setObject:[discount toJSONDictionary] forKey:discount.name];
        }
        [dict setObject:discounts forKey:@"discounts"];
    }
    
    if (self.metadata != nil) {
        [dict setObject:self.metadata forKey:@"metadata"];
    }
    
    if (self.financingProgram != nil) {
        [dict setObject:self.financingProgram forKey:@"financing_program"];
    }
    
    return dict;
}

- (id) copyWithZone:(NSZone *)zone {
    AffirmCheckout *output = [[self class] checkoutWithItems:self.items shipping:self.shipping taxAmount:self.taxAmount shippingAmount:self.shippingAmount discounts:self.discounts metadata:self.metadata financingProgram:self.financingProgram];

    if (self.totalAmount) {
        output.totalAmount = self.totalAmount;
    }
    
    return output;
}

@end
