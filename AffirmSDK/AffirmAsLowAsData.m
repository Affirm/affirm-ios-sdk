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

static NSString *defaultALATemplate = @"Buy in monthly payments with Affirm";

@implementation AffirmAsLowAs

+ (NSURLRequest *)getPromoRequest:(NSString *)promoId withAmount:(NSDecimalNumber *)amount {
    [AffirmValidationUtils checkNotNil:[AffirmConfiguration sharedConfiguration]];

    NSURL *url = [[AffirmConfiguration sharedConfiguration] affirmAsLowAsURLWithPromoId:promoId withAmount:amount];
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
                     callback:(void (^)(NSDictionary *result, NSError *error, BOOL success))callback {
    NSURLRequest *request = [self getPromoRequest:promoId withAmount:amount];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
        if (response.statusCode == 200 && result[@"promo"] && result[@"promo"] != (id)[NSNull null]) {
            callback(result, nil, YES);
        } else {
            callback(nil, [AffirmErrorUtils errorFromInfo:result], false);
        }
    }];
}

+ (void)getALAPromoTemplateForAmount:(NSDecimalNumber *)amount
                             promoID:(NSString *)promoID
                            callback:(void (^)(NSString *ala, BOOL showPrequal, NSError *error, BOOL success))callback {
    [self getPromoDetailsForId:promoID amount:amount callback:^(NSDictionary *result, NSError *error, BOOL success) {
        if (success) {
            NSString *ala = [result[@"promo"][@"ala"] copy];
            ala = [ala stringByReplacingOccurrencesOfString:@"{affirm_logo}" withString:@"Affirm"];
            
            NSString *style = [result[@"promo"][@"config"][@"promo_style"] copy];
            callback(ala, [style isEqualToString:@"fast"], error, success);
        } else {
            callback(defaultALATemplate, YES, error, success);
        }
    }];
}

+ (void) getAffirmAsLowAsForAmount:(NSDecimalNumber *)amount
                           promoId:(NSString *)promoId
                    affirmLogoType:(AffirmLogoType)affirmLogoType
                       affirmColor:(AffirmColorType)affirmColor
                          callback:(void (^)(NSString *asLowAsText, UIImage *logo, BOOL promoPrequalEnabled, NSError *error, BOOL success))callback {
    [AffirmValidationUtils checkNotNil:promoId name:@"promoId"];
    [AffirmValidationUtils checkNotNil:amount name:@"amount"];

    [AffirmAsLowAs getALAPromoTemplateForAmount:amount promoID:promoId callback:^(NSString *ala, BOOL showPrequal, NSError *error, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (affirmLogoType == AffirmLogoTypeText) {
                callback(ala, nil, showPrequal, error, success);
            } else {
                UIImage *logo = [AffirmAsLowAs getAffirmDisplayForLogoType:affirmLogoType colorType:affirmColor];
                callback(ala, logo, showPrequal, error, success);
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

+ (UIImage *) getAffirmDisplayForLogoType:(AffirmLogoType) logoType
                                colorType:(AffirmColorType) colorType {
    NSString *file = [NSString stringWithFormat:@"%@_%@-transparent_bg", [AffirmAsLowAs formatAffirmColorToString:colorType], [AffirmAsLowAs formatAffirmTypeToString:logoType]];
    NSBundle *sdkBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"AffirmSDK" ofType:@"bundle"]];
    UIImage *image = [UIImage imageNamed:file inBundle:sdkBundle compatibleWithTraitCollection:nil];
    return image;
}

@end
