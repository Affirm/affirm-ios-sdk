//
//  AffirmAsLowAsButton.h
//  AffirmSDK
//
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AffirmAsLowAsData.h"

NS_ASSUME_NONNULL_BEGIN

/// An AffirmAsLowAsButton displays the contents of an Affirm as low as object which describes the merchant and the item.
@interface AffirmAsLowAsButton : UIButton

@property (nonatomic, weak) id presentingViewController;
@property (nonatomic, strong) NSString *promoID;

/// Convenience constructor that creates an as low as button
/// @param promoID Promo ID to use when getting terms (provided by Affirm)
/// @param presentingViewController view controller that button is displayed on
/// @param frame frame to initialize the button
/// @return an initialized AffirmAsLowAsButton
+ (instancetype)createButtonWithPromoID:(NSString *)promoID
               presentingViewController:(id)presentingViewController
                                  frame:(CGRect)frame;

/// Configures an AffirmAsLowAsButton with the appropriate details
/// @param amount Amount of the transaction
/// @param affirmLogoType type of Affirm logo to display (text, name, symbol)
/// @param affirmColor color of Affirm to display (blue, black, white) - only applies to logo and symbol affirmType values
/// @param maxFontSize max font size of the ALA text - the button autoshrinks text to fit its dimensions and the final font size will never exceed this max font size
/// @param callback method that can be passed and executed once the calls are completed.
- (void)configureWithAmount:(NSDecimalNumber *)amount
             affirmLogoType:(AffirmLogoType)affirmLogoType
                affirmColor:(AffirmColorType)affirmColor
                maxFontSize:(CGFloat)maxFontSize
                   callback:(void(^)(BOOL alaEnabled, NSError *error))callback;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
