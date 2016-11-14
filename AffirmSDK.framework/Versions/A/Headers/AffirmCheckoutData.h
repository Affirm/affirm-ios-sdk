//
//  AffirmCheckoutData.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/16/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AffirmConfiguration.h"

NS_ASSUME_NONNULL_BEGIN


/// An AffirmAddress object represents a customer's address.
@interface AffirmAddress : NSObject

/// Address line 1. Required.
@property(nonatomic, copy, readonly) NSString *line1;

/// Address line 2. Required.
@property(nonatomic, copy, readonly) NSString *line2;

/// City. Required.
@property(nonatomic, copy, readonly) NSString *city;

/// State. Required.
@property(nonatomic, copy, readonly) NSString *state;

/// ZIP code. Required.
@property(nonatomic, copy, readonly) NSString *zipCode;

/// Country code. Required.
@property(nonatomic, copy, readonly) NSString *countryCode;

/// Convenience constructor. See properties for more details.
/// @param line1 Address line 1.
/// @param line2 Address line 2.
/// @param city City.
/// @param state State.
/// @param zipCode ZIP code.
/// @param countryCode Country code.
/// @return The newly created address.
+ (AffirmAddress *)addressWithLine1:(NSString *)line1
                              line2:(NSString *)line2
                               city:(NSString *)city
                              state:(NSString *)state
                            zipCode:(NSString *)zipCode
                        countryCode:(NSString *)countryCode;

/// Initializer. See properties for more details.
/// @param line1 Address line 1.
/// @param line2 Address line 2.
/// @param city City.
/// @param state State.
/// @param zipCode ZIP code.
/// @param countryCode Country code.
/// @return The initialized address.
- (instancetype)initWithLine1:(NSString *)line1
                        line2:(NSString *)line2
                         city:(NSString *)city
                        state:(NSString *)state
                      zipCode:(NSString *)zipCode
                  countryCode:(NSString *)countryCode;

@end


/// An AffirmContact object represents contact info for a customer.
@interface AffirmContact : NSObject

/// The customer's name. Required in shipping contact; otherwise optional. (See AffirmCheckout for more info.)
@property(nonatomic, copy, readonly, nullable) NSString *name;

/// The customer's address. Required in shipping contact; otherwise optional. (See AffirmCheckout for more info.)
@property(nonatomic, copy, readonly, nullable) AffirmAddress *address;

/// The customer's phone number. Optional.
@property(nonatomic, copy, readonly, nullable) NSString *phoneNumber;

/// The customer's email. Optional.
@property(nonatomic, copy, readonly, nullable) NSString *email;

/// Convenience constructor. See properties for more info.
/// @param name Name.
/// @param address Address.
/// @return The newly created contact.
+ (AffirmContact *)contactWithName:(nullable NSString *)name
                           address:(nullable AffirmAddress *)address;

/// Convenience constructor. See properties for more details.
/// @param name Name.
/// @param address Address.
/// @param phoneNumber Phone number.
/// @param email Email.
/// @return The newly created contact.
+ (AffirmContact *)contactWithName:(nullable NSString *)name
                           address:(nullable AffirmAddress *)address
                       phoneNumber:(nullable NSString *)phoneNumber
                             email:(nullable NSString *)email;

/// Initializer. See properties for more details.
/// @param name Name.
/// @param address Address.
/// @param phoneNumber Phone number.
/// @param email Email.
/// @return The initialized contact.
- (instancetype)initWithName:(nullable NSString *)name
                     address:(nullable AffirmAddress *)address
                 phoneNumber:(nullable NSString *)phoneNumber
                       email:(nullable NSString *)email;

@end


/// An AffirmDiscount object represents a discount applied to the Affirm purchase.
@interface AffirmDiscount : NSObject

/// The name of the discount. Required.
@property(nonatomic, copy, readonly) NSString *name;

/// The discount amount in USD. Cannot be negative. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *amount;

/// Convenience constructor. See properties for more details.
/// @param name Discount name.
/// @param amount Discount amount.
/// @return The newly created discount.
+ (AffirmDiscount *)discountWithName:(NSString *)name
                              amount:(NSDecimalNumber *)amount;

/// Initializer. See properties for more details.
/// @param name Discount name.
/// @param amount Discount amount.
/// @return The initialized discount.
- (instancetype)initWithName:(NSString *)name
                      amount:(NSDecimalNumber *)amount;

@end


/// An AffirmItem object represents an item that is purchased.
@interface AffirmItem : NSObject

/// The name of the item. Required.
@property(nonatomic, copy, readonly) NSString *name;

/// The SKU (stock keeping unit) of the item. Required.
@property(nonatomic, copy, readonly) NSString *SKU;

/// The price in USD per item. Cannot be negative. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *unitPrice;

/// The quantity of items purchased. Cannot be negative. Required.
@property(nonatomic, assign, readonly) NSUInteger quantity;

/// The URL of the item page. Required.
@property(nonatomic, copy, readonly) NSURL *URL;

/// The URL of the item image. Required.
@property(nonatomic, copy, readonly) NSURL *imageURL;

/// Convenience constructor. See properties for more details.
/// @param name Item name.
/// @param SKU Item SKU.
/// @param unitPrice Price per item.
/// @param quantity Number of items purchased.
/// @param URL URL of the item.
/// @param imageURL URL of the item image.
/// @return The newly created item.
+ (AffirmItem *)itemWithName:(NSString *)name
                         SKU:(NSString *)SKU
                   unitPrice:(NSDecimalNumber *)unitPrice
                    quantity:(NSUInteger)quantity
                         URL:(NSURL *)URL
                    imageURL:(NSURL *)imageURL;

/// Initializer. See properties for more details.
/// @param name Item name.
/// @param SKU Item SKU.
/// @param unitPrice Price per item.
/// @param quantity Number of items purchased.
/// @param URL URL of the item.
/// @param imageURL URL of the item image.
/// @return The initialized item.
- (instancetype)initWithName:(NSString *)name
                         SKU:(NSString *)SKU
                   unitPrice:(NSDecimalNumber *)unitPrice
                    quantity:(NSUInteger)quantity
                         URL:(NSURL *)URL
                    imageURL:(NSURL *)imageURL;

@end


/// An AffirmCheckout is complete Affirm checkout object describing the customer and the purchase.
@interface AffirmCheckout : NSObject

/// A list of purchased items. Required.
@property(nonatomic, copy, readonly) NSArray *items;

/// Shipping contact information. Required.
/// The shipping contact object must contain a non-nil name and address.
@property(nonatomic, copy, readonly) AffirmContact *shipping;

/// Tax amount in USD. Cannot be negative. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *taxAmount;

/// Shipping amount in USD. Cannot be negative. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *shippingAmount;

/// Billing contact information. Optional.
/// If provided, the billing name and email will be automatically loaded into the Affirm account creation screen.
@property(nonatomic, copy, readonly) AffirmContact *billing;

/// A list of discounts. Optional.
@property(nonatomic, copy, readonly, nullable) NSArray *discounts;

/// Additional metadata for the checkout. Optional.
@property(nonatomic, copy, readonly, nullable) NSDictionary *metadata;

/// The total purchase amount. Dynamically computed from the other properties of the checkout.
@property(nonatomic, copy, readonly) NSDecimalNumber *total;

/// Any financing program that should be applied (see https://docs.affirm.com/Integrate_Affirm/Multiple_Financing_Programs)
@property(nonatomic, copy, readonly, nullable) NSString *financingProgram;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @param financingProgram Financing program to be applied.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray *)items
                             shipping:(AffirmContact *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                     financingProgram:(nullable NSString *)financingProgram;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @param billing Billing contact.
/// @param discounts List of discounts.
/// @param metadata Additional metadata.
/// @param financingProgram Financing program to be applied.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray *)items
                             shipping:(AffirmContact *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                              billing:(nullable AffirmContact *)billing
                            discounts:(nullable NSArray *)discounts
                             metadata:(nullable NSDictionary *)metadata
                     financingProgram:(nullable NSString *)financingProgram;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray *)items
                             shipping:(AffirmContact *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @param billing Billing contact.
/// @param discounts List of discounts.
/// @param metadata Additional metadata.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray *)items
                             shipping:(AffirmContact *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                              billing:(nullable AffirmContact *)billing
                            discounts:(nullable NSArray *)discounts
                             metadata:(nullable NSDictionary *)metadata;

// Initializer. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @param billing Billing contact.
/// @param discounts List of discounts.
/// @param metadata Additional metadata.
/// @param financingProgram Financing Program to be applied
/// @return The initialized checkout.
- (instancetype)initWithItems:(NSArray *)items
                     shipping:(AffirmContact *)shipping
                    taxAmount:(NSDecimalNumber *)taxAmount
               shippingAmount:(NSDecimalNumber *)shippingAmount
                      billing:(nullable AffirmContact *)billing
                    discounts:(nullable NSArray *)discounts
                     metadata:(nullable NSDictionary *)metadata
             financingProgram:(nullable NSString *)financingProgram;

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

- (NSDictionary *)toJSONDictionary;

@end


/// An AffirmAsLowAs is complete Affirm as low as object describing the merchant and the item.
@interface AffirmAsLowAs : NSObject

typedef NS_ENUM(NSInteger, AffirmDisplayType) {
    AffirmDisplayTypeDefault = 1,
    AffirmDisplayTypeText = 2,
    AffirmDisplayTypeLogo = 3,
    AffirmDisplayTypeSymbol = 4,
    AffirmDisplayTypeSymbolHollow = 5
};

typedef NS_ENUM(NSInteger, AffirmColorType) {
    AffirmColorTypeDefault = 1,
    AffirmColorTypeBlue = 2,
    AffirmColorTypeBlack = 3,
    AffirmColorTypeWhite = 4
};

/// Calculates the monthly price and updates the content of the Label with the proper text
/// @param label Label to write to
/// @param amount Amount of the transaction
/// @param promoId Promo ID to use when getting terms (provided by Affirm)
/// @param affirmType type of Affirm to display (text, logo, symbol)
/// @param affirmColor color of Affirm to display (blue, black, white) - only applies to logo and symbol affirmType values
/// @param configuration AffirmConfiguration instance to use
/// @param callback method that can be passed and executed once the calls are completed.
+ (void) writeAffirmAsLowAsToLabel:(UILabel *)label
                            amount:(NSDecimalNumber *)amount
                           promoId:(NSString *)promoId
                        affirmType:(AffirmDisplayType)affirmType
                       affirmColor:(AffirmColorType)affirmColor
                     configuration:(AffirmConfiguration *)configuration
                          callback:(void (^)(NSError *error, BOOL success))callback;

@end


NS_ASSUME_NONNULL_END
