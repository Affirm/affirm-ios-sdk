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

- (NSDecimalNumber *)total {
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
                                   @"shipping_amount": [AffirmNumberUtils decimalDollarsToIntegerCents:self.shippingAmount],
                                   @"tax_amount": [AffirmNumberUtils decimalDollarsToIntegerCents:self.taxAmount],
                                   @"total": [AffirmNumberUtils decimalDollarsToIntegerCents:[self total]],
                                   @"api_version" :@"v2"
                                   } mutableCopy];
    
    [dict addEntriesFromDictionary:[self.shipping toJSONDictionary]];
    
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
    return [[self class] checkoutWithItems:self.items shipping:self.shipping taxAmount:self.taxAmount shippingAmount:self.shippingAmount discounts:self.discounts metadata:self.metadata financingProgram:self.financingProgram];
}

@end

@implementation AffirmPricing

- (instancetype)initWithPayment:(NSDecimalNumber *)payment
                  paymentString:(NSString *)paymentString
                     termLength:(NSDecimalNumber *)termLength
                     disclosure:(NSString *)disclosure {
    [AffirmValidationUtils checkNotNil:payment name:@"payment"];
    [AffirmValidationUtils checkNotNil:paymentString name:@"paymentString"];
    [AffirmValidationUtils checkNotNil:termLength name:@"termLength"];
    [AffirmValidationUtils checkNotNil:disclosure name:@"disclosure"];
    
    if (self = [super init]) {
        _payment = [payment copy];
        _paymentString = [paymentString copy];
        _termLength = [termLength copy];
        _disclosure = [disclosure copy];
        
    }
    return self;
}

+ (AffirmPricing *)pricingWithPayment:(NSDecimalNumber *)payment
                        paymentString:(NSString *)paymentString
                           termLength:(NSDecimalNumber *)termLength
                           disclosure:(NSString *)disclosure {
    return [[self alloc] initWithPayment:payment paymentString:paymentString termLength:termLength disclosure:disclosure];
}

+ (AffirmPricing *)pricingWithDictionary:(NSDictionary *)data {
    NSString *disclosure = [data objectForKey:@"disclosure"];
    NSDecimalNumber *termLength = [data objectForKey:@"months"];
    NSString *paymentString = [data objectForKey:@"payment_string"];
    NSDecimalNumber *payment = [data objectForKey:@"payment"];
    
    return [[self alloc] initWithPayment:payment paymentString:paymentString termLength:termLength disclosure:disclosure];
}

- (NSDictionary *)toJSONDictionary {
    return @{
             @"payment": self.payment,
             @"paymentString": self.paymentString,
             @"termLength": self.termLength,
             @"disclosure": self.disclosure
             };
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] pricingWithPayment:self.payment paymentString:self.paymentString termLength:self.termLength disclosure:self.disclosure];
}

@end

@implementation AffirmAsLowAs

+ (NSURLRequest *)getPromoConfigurationURLForId:(NSString *)promoId {
    [AffirmValidationUtils checkNotNil:[AffirmConfiguration sharedConfiguration]];
    
    NSURL *url = [[AffirmConfiguration sharedConfiguration] affirmAsLowAsURLWithPromoId:promoId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Affirm-iOS-SDK" forHTTPHeaderField:@"Affirm-User-Agent"];
    [request setValue:[AffirmConfiguration affirmSDKVersion] forHTTPHeaderField:@"Affirm-User-Agent-Version"];
    return request;
}

+ (void) getPromoDetailsForId:(NSString *)promoId
                     callback:(void (^)(NSError *error, NSDictionary *data, BOOL success))callback {
    NSURLRequest *request = [self getPromoConfigurationURLForId:promoId];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
        if (response.statusCode == 200) {
            callback(nil, result, true);
        } else {
            callback([AffirmErrorUtils errorFromInfo:result], nil, false);
        }
    }];
}

+ (NSURLRequest *)createAsLowAsRequest:(NSDecimalNumber *)amount
                                   apr:(NSString *)apr
                            termLength:(NSString *)termLength {
    [AffirmValidationUtils checkNotNil:[AffirmConfiguration sharedConfiguration]];
    
    NSURL *url = [[AffirmConfiguration sharedConfiguration] affirmAsLowAsURLWithAPR:apr termLength:termLength amount:amount];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Affirm-iOS-SDK" forHTTPHeaderField:@"Affirm-User-Agent"];
    [request setValue:[AffirmConfiguration affirmSDKVersion] forHTTPHeaderField:@"Affirm-User-Agent-Version"];
    return request;
}

+ (void) sendPricingRequest:(NSDecimalNumber *)amount
                    promoId:(NSString *)promoId
                   callback:(void (^)(NSError *error, AffirmPricing *pricing, NSString *template, BOOL success))callback {
    [AffirmAsLowAs getPromoDetailsForId:promoId callback:^(NSError *error, NSDictionary *promoData, BOOL success) {
        if (success) {
            NSURLRequest *request = [self createAsLowAsRequest:amount apr:[promoData objectForKey:@"apr"] termLength:[promoData objectForKey:@"termLength"]];
            [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
                if (response.statusCode == 200) {
                    callback(nil, [AffirmPricing pricingWithDictionary:result], [promoData objectForKey:@"pricingTemplate"], true);
                } else {
                    callback([AffirmErrorUtils errorFromInfo:result], nil, nil, false);
                }
            }];
        }
        else {
            callback(error, nil, nil, false);
        }
    }];
}

+ (void) getAffirmAsLowAsForAmount:(NSDecimalNumber *)amount
                           promoId:(NSString *)promoId
                          fontSize:(CGFloat) fontSize
                    affirmLogoType:(AffirmLogoType)affirmLogoType
                       affirmColor:(AffirmColorType)affirmColor
                          callback:(void (^)(NSString *asLowAsText, UIImage *logo, NSError *error, BOOL success))callback {
    [AffirmValidationUtils checkNotNil:promoId name:@"promoId"];
    
    [AffirmAsLowAs sendPricingRequest:amount promoId:promoId callback:^(NSError *error, AffirmPricing *pricing, NSString *pricingTemplate, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSString *template = [pricingTemplate stringByReplacingOccurrencesOfString:@"{payment}" withString:[NSString stringWithFormat:@"$%@", [pricing paymentString]]];
                template = [template stringByReplacingOccurrencesOfString:@"{affirm_logo}" withString:@"Affirm"];
                if (affirmLogoType == AffirmLogoTypeText) {
                    callback(template, nil, nil, true);
                }
                else {
                    UIImage *logo = [AffirmAsLowAs getAffirmDisplayForLogoType:affirmLogoType colorType:affirmColor];
                    logo = [AffirmAsLowAs resizedImage:logo logoType:affirmLogoType height:fontSize];
                    callback(template, logo, nil, true);
                }
            }
            else {
                callback(nil, nil, error, false);
            }
        });
    }];
}

+ (NSAttributedString *) appendLogo:(UIImage *) logo toText:(NSString *) text {
    if (!logo) {
        return [[NSAttributedString alloc] initWithString:text];
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    while ([attributedText.mutableString containsString:@"Affirm"]) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = logo;
        attachment.bounds = CGRectMake(0, -logo.size.height/5, attachment.image.size.width, attachment.image.size.height);
        NSAttributedString *attributedLogo = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedText replaceCharactersInRange:[attributedText.mutableString rangeOfString:@"Affirm"] withAttributedString:attributedLogo];
    }
    return attributedText;
}

+ (UIImage *) resizedImage:(UIImage *)logo
                  logoType:(AffirmLogoType)logoType
                    height:(float)height {
    switch(logoType) {
        case AffirmLogoTypeName:
            return [self imageWithImage:logo scaledToSize:CGSizeMake((925 * height) / 285, height)];
        case AffirmLogoTypeText:
            return nil;
        case AffirmLogoTypeSymbol:
            return [self imageWithImage:logo scaledToSize:CGSizeMake(1.25 * height, 1.25 * height)];
        case AffirmLogoTypeSymbolHollow:
            return [self imageWithImage:logo scaledToSize:CGSizeMake(1.25 * height, 1.25 * height)];
        default:
            return [self imageWithImage:logo scaledToSize:CGSizeMake((925 * height) / 285, height)];
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (NSString *) formatAffirmTypeToString:(AffirmLogoType)affirmType {
    
    NSString *result = nil;
    
    switch(affirmType) {
        case AffirmLogoTypeName:
            result = @"logo";
            break;
        case AffirmLogoTypeText:
            result = @"text";
            break;
        case AffirmLogoTypeSymbol:
            result = @"solid_circle";
            break;
        case AffirmLogoTypeSymbolHollow:
            result = @"hollow_circle";
            break;
        default:
            result = @"logo";
    }
    
    return result;
    
}

+ (NSString *)formatAffirmColorToString:(AffirmColorType)colorType {
    
    NSString *result = nil;
    
    switch(colorType) {
        case AffirmColorTypeBlue:
            result = @"blue";
            break;
        case AffirmColorTypeBlack:
            result = @"black";
            break;
        case AffirmColorTypeWhite:
            result = @"white";
            break;
        default:
            result = @"blue";
    }
    
    return result;
    
}

+ (NSString *)formatBoolToString:(BOOL)value {
    return value ? @"true" : @"false";
}

+ (UIImage *) getAffirmDisplayForLogoType:(AffirmLogoType) logoType
                                colorType:(AffirmColorType) colorType {
    NSString *file = [NSString stringWithFormat:@"%@_%@-transparent_bg", [AffirmAsLowAs formatAffirmColorToString:colorType], [AffirmAsLowAs formatAffirmTypeToString:logoType]];
    NSBundle *sdkBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"AffirmSDK" withExtension:@"bundle"]];
    UIImage *image = [UIImage imageNamed:file inBundle:sdkBundle compatibleWithTraitCollection:nil];
    return image;
}

@end
