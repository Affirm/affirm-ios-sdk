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
/// @param showCTA A boolean to use when getting terms
/// @param affirmLogoType type of Affirm logo to display (text, name, symbol)
/// @param affirmColor color of Affirm to display (blue, black, white) - only applies to logo and symbol affirmType values
/// @param callback method that can be passed and executed once the calls are completed.
+ (void) getAffirmAsLowAsForAmount:(NSDecimalNumber *)amount
                           promoId:(NSString *)promoId
                           showCTA:(BOOL)showCTA
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

NS_ASSUME_NONNULL_END
