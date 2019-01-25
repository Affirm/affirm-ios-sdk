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

/// An AffirmShippingDetail object represents the shipping details for a customer.
@interface AffirmShippingDetail : NSObject

/// The customer's name. Required in shipping contact; otherwise optional. (See AffirmCheckout for more info.)
@property(nonatomic, copy, readonly, nullable) NSString *name;

/// The customer's phone number. Optional.
@property(nonatomic, copy, readonly, nullable) NSString *phoneNumber;

/// The customer's email. Optional.
@property(nonatomic, copy, readonly, nullable) NSString *email;

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

/// Convenience constructor for a shipping detail object.
/// @param name Name.
/// @param line1 Address line 1.
/// @param line2 Address line 2.
/// @param city City.
/// @param state State.
/// @param zipCode ZIP code.
/// @param countryCode Country code.
/// @return The initialized address.
+ (AffirmShippingDetail *)shippingDetailWithName:(NSString *)name
                                addressWithLine1:(NSString *)line1
                                           line2:(NSString *)line2
                                            city:(NSString *)city
                                           state:(NSString *)state
                                         zipCode:(NSString *)zipCode
                                     countryCode:(NSString *)countryCode;

/// Convenience constructor for a shipping detail object with email and phone number.
/// @param name Name.
/// @param email Email.
/// @param phoneNumber Phone number.
/// @param line1 Address line 1.
/// @param line2 Address line 2.
/// @param city City.
/// @param state State.
/// @param zipCode ZIP code.
/// @param countryCode Country code.
/// @return The initialized address.
+ (AffirmShippingDetail *)shippingDetailWithName:(NSString *)name
                                           email:(nullable NSString *)email
                                     phoneNumber:(nullable NSString *)phoneNumber
                                addressWithLine1:(NSString *)line1
                                           line2:(NSString *)line2
                                            city:(NSString *)city
                                           state:(NSString *)state
                                         zipCode:(NSString *)zipCode
                                     countryCode:(NSString *)countryCode;

/// Initializer for a shipping detail object with email and phone number.
/// @param name Name.
/// @param email Email.
/// @param phoneNumber Phone number.
/// @param line1 Address line 1.
/// @param line2 Address line 2.
/// @param city City.
/// @param state State.
/// @param zipCode ZIP code.
/// @param countryCode Country code.
/// @return The initialized address.
- (instancetype)initShippingDetailWithName:(NSString *)name
                                     email:(nullable NSString *)email
                               phoneNumber:(nullable NSString *)phoneNumber
                          addressWithLine1:(NSString *)line1
                                     line2:(NSString *)line2
                                      city:(NSString *)city
                                     state:(NSString *)state
                                   zipCode:(NSString *)zipCode
                               countryCode:(NSString *)countryCode;

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
/// @return The newly created item.
+ (AffirmItem *)itemWithName:(NSString *)name
                         SKU:(NSString *)SKU
                   unitPrice:(NSDecimalNumber *)unitPrice
                    quantity:(NSUInteger)quantity
                         URL:(NSURL *)URL;

/// Initializer. See properties for more details.
/// @param name Item name.
/// @param SKU Item SKU.
/// @param unitPrice Price per item.
/// @param quantity Number of items purchased.
/// @param URL URL of the item.
/// @return The initialized item.
- (instancetype)initWithName:(NSString *)name
                         SKU:(NSString *)SKU
                   unitPrice:(NSDecimalNumber *)unitPrice
                    quantity:(NSUInteger)quantity
                         URL:(NSURL *)URL;

@end


/// An AffirmCheckout is complete Affirm checkout object describing the customer and the purchase.
@interface AffirmCheckout : NSObject

/// A list of purchased items. Required.
@property(nonatomic, copy, readonly) NSArray <AffirmItem *>*items;

/// Shipping contact information. Required.
/// The shipping contact object must contain a non-nil name and address.
@property(nonatomic, copy, readonly) AffirmShippingDetail *shipping;

/// Tax amount in USD. Cannot be negative. Required if total amount isn't passed.
@property(nonatomic, copy, readonly) NSDecimalNumber *taxAmount;

/// Shipping amount in USD. Cannot be negative. Required if total amount isn't passed.
@property(nonatomic, copy, readonly) NSDecimalNumber *shippingAmount;

/// A list of discounts. Optional.
@property(nonatomic, copy, readonly, nullable) NSArray <AffirmDiscount *>*discounts;

/// Additional metadata for the checkout. Optional.
@property(nonatomic, copy, readonly, nullable) NSDictionary *metadata;

/// The total purchase amount. Dynamically computed from the other properties of the checkout.
@property(nonatomic, copy, readonly) NSDecimalNumber *total;

/// The total purchase amount, in cents. Can be passed in directly, instead of passing in shipping/tax/discount data.
@property(nonatomic, copy, nullable) NSNumber *totalAmount;

/// Any financing program that should be applied (see https://docs.affirm.com/Integrate_Affirm/Multiple_Financing_Programs)
@property(nonatomic, copy, readonly, nullable) NSString *financingProgram;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @param financingProgram Financing program to be applied.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                     financingProgram:(nullable NSString *)financingProgram;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @param discounts List of discounts.
/// @param metadata Additional metadata.
/// @param financingProgram Financing program to be applied.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                            discounts:(nullable NSArray <AffirmDiscount *>*)discounts
                             metadata:(nullable NSDictionary *)metadata
                     financingProgram:(nullable NSString *)financingProgram;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @param discounts List of discounts.
/// @param metadata Additional metadata.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                            discounts:(nullable NSArray <AffirmDiscount *>*)discounts
                             metadata:(nullable NSDictionary *)metadata;

// Initializer. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param taxAmount Tax amount.
/// @param shippingAmount Shipping amount.
/// @param discounts List of discounts.
/// @param metadata Additional metadata.
/// @param financingProgram Financing Program to be applied
/// @return The initialized checkout.
- (instancetype)initWithItems:(NSArray <AffirmItem *>*)items
                     shipping:(AffirmShippingDetail *)shipping
                    taxAmount:(NSDecimalNumber *)taxAmount
               shippingAmount:(NSDecimalNumber *)shippingAmount
                    discounts:(nullable NSArray <AffirmDiscount *>*)discounts
                     metadata:(nullable NSDictionary *)metadata
             financingProgram:(nullable NSString *)financingProgram;

/// Convenience constructor. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param totalAmount Total amount, in cents, of the transaction.
/// @return The newly created checkout.
+ (AffirmCheckout *)checkoutWithItems:(NSArray <AffirmItem *>*)items
                             shipping:(AffirmShippingDetail *)shipping
                          totalAmount:(NSNumber *)totalAmount;

// Initializer. See properties for more details.
/// @param items List of purchased items.
/// @param shipping Shipping contact.
/// @param discounts List of discounts.
/// @param metadata Additional metadata.
/// @param financingProgram Financing Program to be applied
/// @param totalAmount Total amount of the checkout
/// @return The initialized checkout.
- (instancetype)initWithItems:(NSArray <AffirmItem *>*)items
                     shipping:(AffirmShippingDetail *)shipping
                    discounts:(nullable NSArray <AffirmDiscount *>*)discounts
                     metadata:(nullable NSDictionary *)metadata
             financingProgram:(nullable NSString *)financingProgram
                  totalAmount:(nullable NSNumber *)totalAmount;

@end

NS_ASSUME_NONNULL_END
