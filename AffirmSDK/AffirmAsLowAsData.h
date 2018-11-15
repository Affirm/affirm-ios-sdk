//
//  AffirmAsLowAsData.h
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 6/26/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AffirmConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// An AffirmAsLowAs is complete Affirm as low as object describing the merchant and the item.
@interface AffirmAsLowAs : NSObject

typedef NS_ENUM(NSInteger, AffirmLogoType) {
    AffirmLogoTypeText = 1,
    AffirmLogoTypeName = 2,
    AffirmLogoTypeSymbol = 3,
    AffirmLogoTypeSymbolHollow = 4
};

typedef NS_ENUM(NSInteger, AffirmColorType) {
    AffirmColorTypeDefault = 1,
    AffirmColorTypeBlue = 2,
    AffirmColorTypeBlack = 3,
    AffirmColorTypeWhite = 4
};

/// Calculates the monthly price and updates the content of the Label with the proper text
/// @param amount Amount of the transaction
/// @param promoId Promo ID to use when getting terms (provided by Affirm)
/// @param affirmLogoType type of Affirm logo to display (text, name, symbol)
/// @param affirmColor color of Affirm to display (blue, black, white) - only applies to logo and symbol affirmType values
/// @param callback method that can be passed and executed once the calls are completed.
+ (void) getAffirmAsLowAsForAmount:(NSDecimalNumber *)amount
                           promoId:(NSString *)promoId
                    affirmLogoType:(AffirmLogoType)affirmLogoType
                       affirmColor:(AffirmColorType)affirmColor
                          callback:(void (^)(NSString *asLowAsText, UIImage *logo, BOOL promoPrequalEnabled, NSError *error, BOOL success))callback;

/// Inserts the Affirm logo into the asLowAs text to display in your label
/// @param logo The Affirm logo image
/// @param text The asLowAs text
/// @param fontSize font size of text to display
/// @param logoType type of Affirm logo to display (text, name, symbol)
/// @return attributed string with the Affirm logo inserted in the asLowAs text
+ (NSAttributedString *)appendLogo:(UIImage *)logo
                            toText:(NSString *)text
                              font:(CGFloat)fontSize
                          logoType:(AffirmLogoType)logoType;

@end

/// An AffirmLoanTerm object represents terms of a monthly payment option.
@interface AffirmLoanTerm: NSObject

/// Interest rate. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *apr;

/// Minimum loan amount. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *minimumLoanAmount;

/// Term length of the loan in months. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *termLength;

/// Pricing template for the ALA text. Required.
@property(nonatomic, copy, readonly) NSString *pricingTemplate;

/// Default message to display in case requested loan amount does not exceed loan term's minimum loan amount. Required.
@property(nonatomic, copy, readonly) NSString *defaultMessage;

/// Convenience constructor. Creates a loan term object with the following properties.
/// @param apr Interest rate
/// @param termLength Term length of the loan in months.
/// @param pricingTemplate ALA template.
/// @param defaultMessage Default text to display for invalid loan amount.
/// @return A Loan term object
+ (AffirmLoanTerm *)loanTermWithMinAmount:(NSNumber *)minLoanAmount
                                      apr:(NSDecimalNumber *)apr
                               termLength:(NSDecimalNumber *)termLength
                          pricingTemplate:(NSString *)pricingTemplate
                           defaultMessage:(NSString *)defaultMessage;

/// Initializer. Creates a loan term object with the following properties.
/// @param apr Interest rate
/// @param termLength Term length of the loan in months.
/// @param pricingTemplate ALA template.
/// @param defaultMessage Default text to display for invalid loan amount.
/// @return A Loan term object
- (instancetype)initWithMinLoanAmount:(NSNumber *)minLoanAmount
                                  apr:(NSDecimalNumber *)apr
                           termLength:(NSDecimalNumber *)termLength
                      pricingTemplate:(NSString *)pricingTemplate
                       defaultMessage:(NSString *)defaultMessage;

/// Constructor that creates an AffirmLoanTerm object from a dictionary containing info about an ALA term length interval.
/// @param data ALA Term length interval dictionary
/// @param pricingTemplate ALA template
/// @param defaultMessage Default text to display for invalid loan amount
+ (AffirmLoanTerm *)loanTermWithDictionary:(NSDictionary *)data
                           pricingTemplate:(NSString *)pricingTemplate
                            defaultMessage:(NSString *)defaultMessage;

@end

/// An AffirmPricing object represents a customer's possible monthly payments.
@interface AffirmPricing : NSObject

/// Disclosure text. Required.
@property(nonatomic, copy, readonly) NSString *disclosure;

/// termLength used in the calculation. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *termLength;

/// String representation of the Payment. Required.
@property(nonatomic, copy, readonly) NSString *paymentString;

/// Payment. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *payment;

/// Convenience constructor. See properties for more details.
/// @param payment Monthly payment amount
/// @param paymentString Monthly payment represented as a String
/// @param termLength Number of termLength for the payment
/// @param disclosure Disclosure that can be displayed to the consumer
/// @return The initialized Affirm Pricing
+ (AffirmPricing *)pricingWithPayment:(NSDecimalNumber *)payment
                        paymentString:(NSString *)paymentString
                           termLength:(NSDecimalNumber *)termLength
                           disclosure:(NSString *)disclosure;


/// Initializer. See properties for more details.
/// @param payment Monthly payment amount
/// @param paymentString Monthly payment represented as a String
/// @param termLength Number of termLength for the payment
/// @param disclosure Disclosure that can be displayed to the consumer
/// @return The initialized Affirm Pricing
- (instancetype)initWithPayment:(NSDecimalNumber *)payment
                  paymentString:(NSString *)paymentString
                     termLength:(NSDecimalNumber *)termLength
                     disclosure:(NSString *)disclosure;

+ (AffirmPricing *)pricingWithDictionary:(NSDictionary *)data;

- (NSDictionary *)toJSONDictionary;

@end

NS_ASSUME_NONNULL_END
