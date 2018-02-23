//
//  AffirmAsLowAsData.m
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 6/26/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "AffirmAsLowAsData.h"
#import "AffirmJSONifiable.h"
#import "AffirmUtils.h"

static const CGFloat ALAMaxAmount = 17500;

static NSString *defaultALATemplate = @"Buy in monthly payments with Affirm";

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
                       amount:(NSDecimalNumber *)amount
                     callback:(void (^)(AffirmLoanTerm *minLoanTerm, NSError *error, BOOL success))callback {
    NSURLRequest *request = [self getPromoConfigurationURLForId:promoId];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
        if (response.statusCode == 200 && result[@"asLowAs"]) {
            NSDictionary *asLowAsData = result[@"asLowAs"];
            AffirmLoanTerm *minLoanTerm = [self getMinLoanTermForAmount:amount fromALAData:asLowAsData];
            callback(minLoanTerm, nil, minLoanTerm != nil);
        } else {
            callback(nil, [AffirmErrorUtils errorFromInfo:result], false);
        }
    }];
}


+ (AffirmLoanTerm *)getMinLoanTermForAmount:(NSDecimalNumber *)amount fromALAData:(NSDictionary *)asLowAsData {
    NSString *pricingTemplate = asLowAsData[@"pricingTemplate"];
    NSString *defaultMessage = asLowAsData[@"defaultMessage"];

    NSArray <NSDictionary *> *loanTermIntervals = asLowAsData[@"termLengthIntervals"];
    loanTermIntervals = [[loanTermIntervals reverseObjectEnumerator] allObjects];
    for (NSDictionary *loanTermInterval in loanTermIntervals) {
        AffirmLoanTerm *loanTerm = [AffirmLoanTerm loanTermWithDictionary:loanTermInterval pricingTemplate:pricingTemplate defaultMessage:defaultMessage];
        BOOL promoPlanInRange = loanTerm.minimumLoanAmount.floatValue <= amount.floatValue && amount.floatValue < ALAMaxAmount;
        if (promoPlanInRange) {
            return loanTerm;
        }
    }
    return nil;
}

+ (NSURLRequest *)createAsLowAsRequest:(NSDecimalNumber *)amount
                                   apr:(NSDecimalNumber *)apr
                            termLength:(NSDecimalNumber *)termLength {
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

+ (void)sendPricingRequest:(NSDecimalNumber *)amount
                  loanTerm:(AffirmLoanTerm *)loanTerm
                  callback:(void (^)(AffirmPricing *pricing, NSError *error, BOOL success))callback {
    NSURLRequest *request = [self createAsLowAsRequest:amount apr:loanTerm.apr termLength:loanTerm.termLength];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
        if (response.statusCode == 200) {
            callback([AffirmPricing pricingWithDictionary:result], nil, true);
        } else {
            callback(nil, [AffirmErrorUtils errorFromInfo:result], false);
        }
    }];
}

+ (void)getALAPromoTemplateForAmount:(NSDecimalNumber *)amount
                             promoID:(NSString *)promoID
                            callback:(void (^)(NSString *promoTemplate, NSError *error, BOOL success))callback {
    [self getPromoDetailsForId:promoID amount:amount callback:^(AffirmLoanTerm *minLoanTerm, NSError *error, BOOL success) {
        NSString *promoDefaultTemplate = minLoanTerm.defaultMessage ? minLoanTerm.defaultMessage : defaultALATemplate;
        if (success) {
            [self sendPricingRequest:amount loanTerm:minLoanTerm callback:^(AffirmPricing *pricing, NSError *error, BOOL pricingSuccess) {
                NSString *template = promoDefaultTemplate;
                if (pricingSuccess) {
                    template = [minLoanTerm.pricingTemplate stringByReplacingOccurrencesOfString:@"{payment}" withString:[NSString stringWithFormat:@"$%@", pricing.paymentString]];
                    template = [template stringByReplacingOccurrencesOfString:@"{lowest_apr}" withString:[NSString stringWithFormat:@"%@", @(minLoanTerm.apr.floatValue * 100)]];
                }

                template = [template stringByReplacingOccurrencesOfString:@"{affirm_logo}" withString:@"Affirm"];
                callback(template, error, pricingSuccess);
            }];
        } else {
            callback(promoDefaultTemplate, error, success);
        }
    }];
}

+ (void) getAffirmAsLowAsForAmount:(NSDecimalNumber *)amount
                           promoId:(NSString *)promoId
                    affirmLogoType:(AffirmLogoType)affirmLogoType
                       affirmColor:(AffirmColorType)affirmColor
                          callback:(void (^)(NSString *asLowAsText, UIImage *logo, NSError *error, BOOL success))callback {
    [AffirmValidationUtils checkNotNil:promoId name:@"promoId"];
    [AffirmValidationUtils checkNotNil:amount name:@"amount"];

    [AffirmAsLowAs getALAPromoTemplateForAmount:amount promoID:promoId callback:^(NSString *promoTemplate, NSError *error, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (affirmLogoType == AffirmLogoTypeText) {
                callback(promoTemplate, nil, error, success);
            } else {
                UIImage *logo = [AffirmAsLowAs getAffirmDisplayForLogoType:affirmLogoType colorType:affirmColor];
                callback(promoTemplate, logo, error, success);
            }
        });
    }];
}


+ (NSAttributedString *) appendLogo:(UIImage *)logo toText:(NSString *) text font:(CGFloat)fontSize logoType:(AffirmLogoType)logoType {
    if (!logo) {
        return [[NSAttributedString alloc] initWithString:text];
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
    while ([attributedText.mutableString containsString:@"Affirm"]) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = logo;
        CGSize logoSize = [self sizeForLogoType:logoType height:fontSize];
        attachment.bounds = CGRectMake(0, -logoSize.height/5, logoSize.width, logoSize.height);
        NSAttributedString *attributedLogo = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedText replaceCharactersInRange:[attributedText.mutableString rangeOfString:@"Affirm"] withAttributedString:attributedLogo];
    }
    return attributedText;
}

+ (CGSize)sizeForLogoType:(AffirmLogoType)logoType
                   height:(float)height {
    switch(logoType) {
        case AffirmLogoTypeName:
            return CGSizeMake((925 * height) / 285, height);
        case AffirmLogoTypeText:
            return CGSizeZero;
        case AffirmLogoTypeSymbol:
            return CGSizeMake(1.25 * height, 1.25 * height);
        case AffirmLogoTypeSymbolHollow:
            return CGSizeMake(1.25 * height, 1.25 * height);
        default:
            return CGSizeMake((925 * height) / 285, height);
    }
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
    NSBundle *sdkBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"AffirmSDK" ofType:@"bundle"]];
    UIImage *image = [UIImage imageNamed:file inBundle:sdkBundle compatibleWithTraitCollection:nil];
    return image;
}

@end

@interface AffirmLoanTerm() <AffirmJSONifiable, NSCopying>
@end

@implementation AffirmLoanTerm

+ (AffirmLoanTerm *)loanTermWithMinAmount:(NSDecimalNumber *)minLoanAmount
                                      apr:(NSDecimalNumber *)apr
                               termLength:(NSDecimalNumber *)termLength
                          pricingTemplate:(NSString *)pricingTemplate
                           defaultMessage:(NSString *)defaultMessage {
    return [[self alloc] initWithMinLoanAmount:minLoanAmount apr:apr termLength:termLength pricingTemplate:pricingTemplate defaultMessage:defaultMessage];
}

- (instancetype)initWithMinLoanAmount:(NSDecimalNumber *)minLoanAmount
                                  apr:(NSDecimalNumber *)apr
                           termLength:(NSDecimalNumber *)termLength
                      pricingTemplate:(NSString *)pricingTemplate
                       defaultMessage:(NSString *)defaultMessage {
    [AffirmValidationUtils checkNotNil:minLoanAmount name:@"minimumLoanAmount"];
    [AffirmValidationUtils checkNotNil:apr name:@"apr"];
    [AffirmValidationUtils checkNotNil:termLength name:@"termLength"];

    if (self = [super init]) {
        _minimumLoanAmount = minLoanAmount;
        _apr = apr;
        _termLength = termLength;
        _pricingTemplate = pricingTemplate;
        _defaultMessage = defaultMessage;
    }
    return self;
}

+ (AffirmLoanTerm *)loanTermWithDictionary:(NSDictionary *)data
                           pricingTemplate:(NSString *)pricingTemplate
                            defaultMessage:(NSString *)defaultMessage {
    NSDecimalNumber *apr = data[@"apr"];
    NSNumber *minAmt = data[@"minimumLoanAmount"];
    NSDecimalNumber *formattedMinAmount = [NSDecimalNumber decimalNumberWithDecimal:[[AffirmNumberUtils dollarsByRemovingIntegerCents:minAmt] decimalValue]];
    NSDecimalNumber *termLength = data[@"termLength"];
    return [self loanTermWithMinAmount:formattedMinAmount apr:apr termLength:termLength pricingTemplate:pricingTemplate defaultMessage:defaultMessage];
}

- (NSDictionary *)toJSONDictionary {
    return @{
             @"apr": self.apr,
             @"minimumLoanAmount": self.minimumLoanAmount,
             @"termLength": self.termLength,
             @"pricingTemplate": self.pricingTemplate,
             @"defaultMessage": self.defaultMessage
             };
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] loanTermWithMinAmount:self.minimumLoanAmount apr:self.apr termLength:self.termLength pricingTemplate:self.pricingTemplate defaultMessage:self.defaultMessage];
}

@end

@interface AffirmPricing() <AffirmJSONifiable, NSCopying>
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
