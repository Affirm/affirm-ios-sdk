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

static const CGFloat ALAMinAmount = 50;
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
                     callback:(void (^)(NSDictionary *alaDic, NSError *error, BOOL success))callback {
    NSURLRequest *request = [self getPromoConfigurationURLForId:promoId];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
        if (response.statusCode == 200 && result[@"asLowAs"]) {
            NSDictionary *asLowAsDic = result[@"asLowAs"];
            if (asLowAsDic[@"termLengthIntervals"]) {
                NSMutableDictionary *lowestPaymentPlan = [[self getLowestPaymentPlanFromTermIntervals:asLowAsDic[@"termLengthIntervals"]] mutableCopy];
                lowestPaymentPlan[@"defaultMessage"] = asLowAsDic[@"defaultMessage"];
                lowestPaymentPlan[@"pricingTemplate"] = asLowAsDic[@"pricingTemplate"];
                callback(lowestPaymentPlan, nil, lowestPaymentPlan != nil);
            } else {
                callback(asLowAsDic, nil, true);
            }
        } else {
            callback(nil, [AffirmErrorUtils errorFromInfo:result], false);
        }
    }];
}


+ (NSDictionary *)getLowestPaymentPlanFromTermIntervals:(NSArray <NSDictionary *> *)termIntervals {
    for (NSDictionary *term in termIntervals) {
        NSInteger minLoanAmount = [term[@"minimumLoanAmount"] integerValue];
        BOOL promoPlanInRange = minLoanAmount >= ALAMinAmount && minLoanAmount < ALAMaxAmount;
        if (promoPlanInRange) {
            return term;
        }
    }
    return nil;
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

+ (void)sendPricingRequest:(NSDecimalNumber *)amount
                    promoId:(NSString *)promoId
                 promoData:(NSDictionary *)promoData
                   callback:(void (^)(NSError *error, AffirmPricing *pricing, NSString *template, BOOL success))callback {
    NSURLRequest *request = [self createAsLowAsRequest:amount apr:[promoData objectForKey:@"apr"] termLength:[promoData objectForKey:@"termLength"]];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
        if (response.statusCode == 200) {
            callback(nil, [AffirmPricing pricingWithDictionary:result], [promoData objectForKey:@"pricingTemplate"], true);
        } else {
            callback([AffirmErrorUtils errorFromInfo:result], nil, nil, false);
        }
    }];
}

+ (void)getALAPromoTemplateForAmount:(NSDecimalNumber *)amount
                             promoID:(NSString *)promoID
                            callback:(void (^)(NSString *promoTemplate, NSError *error, BOOL success))callback {
    [self getPromoDetailsForId:promoID callback:^(NSDictionary *promoData, NSError *error, BOOL success) {
        NSString *promoDefaultTemplate = promoData[@"defaultMessage"] ? promoData[@"defaultMessage"] : defaultALATemplate;
        if (success) {
            [self sendPricingRequest:amount promoId:promoID promoData:promoData callback:^(NSError *error, AffirmPricing *pricing, NSString *pricingTemplate, BOOL pricingSuccess) {
                NSString *template = (pricingSuccess) ? [pricingTemplate stringByReplacingOccurrencesOfString:@"{payment}" withString:[NSString stringWithFormat:@"$%@", [pricing paymentString]]] : promoDefaultTemplate;
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
    
    [AffirmAsLowAs getALAPromoTemplateForAmount:amount promoID:promoId callback:^(NSString *promoTemplate, NSError *error, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (affirmLogoType == AffirmLogoTypeText) {
                callback(promoTemplate, nil, error, success);
            }
            else {
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
    NSBundle *sdkBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"AffirmSDK" withExtension:@"bundle"]];
    UIImage *image = [UIImage imageNamed:file inBundle:sdkBundle compatibleWithTraitCollection:nil];
    return image;
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
