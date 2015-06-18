//
//  AffirmCheckoutData.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/16/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AffirmAddress : NSObject

// The customer's address.

// Address line 1. Required.
@property(nonatomic, copy, readonly) NSString *line1;

// Address line 2. Required.
@property(nonatomic, copy, readonly) NSString *line2;

// City. Required.
@property(nonatomic, copy, readonly) NSString *city;

// State. Required.
@property(nonatomic, copy, readonly) NSString *state;

// Zip code. Required.
@property(nonatomic, copy, readonly) NSString *zipCode;

// Country code. Required.
@property(nonatomic, copy, readonly) NSString *countryCode;

+ (AffirmAddress *)addressWithLine1:(NSString *)line1
                              line2:(NSString *)line2
                               city:(NSString *)city
                              state:(NSString *)state
                            zipCode:(NSString *)zipCode
                        countryCode:(NSString *)countryCode;

- (instancetype)initWithLine1:(NSString *)line1
                        line2:(NSString *)line2
                         city:(NSString *)city
                        state:(NSString *)state
                      zipCode:(NSString *)zipCode
                  countryCode:(NSString *)countryCode;

@end


@interface AffirmContact : NSObject

// Contact info for a customer.

// The customer's name. Required.
@property(nonatomic, copy, readonly) NSString *name;

// The customer's address. Required.
@property(nonatomic, copy, readonly) AffirmAddress *address;

// The customer's phone number. Optional.
@property(nonatomic, copy, readonly) NSString *phoneNumber;

// The customer's email. Optional.
@property(nonatomic, copy, readonly) NSString *email;

+ (AffirmContact *)contactWithName:(NSString *)name
                           address:(AffirmAddress *)address;

+ (AffirmContact *)contactWithName:(NSString *)name
                           address:(AffirmAddress *)address
                       phoneNumber:(NSString *)phoneNumber
                             email:(NSString *)email;

- (instancetype)initWithName:(NSString *)name
                     address:(AffirmAddress *)address
                 phoneNumber:(NSString *)phoneNumber
                       email:(NSString *)email;

@end


@interface AffirmDiscount : NSObject

// A discount applied to the Affirm purchase.

// The name of the discount. Required.
@property(nonatomic, copy, readonly) NSString *name;

// The discount amount in USD. Cannot be negative. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *amount;

+ (AffirmDiscount *)discountWithName:(NSString *)name
                              amount:(NSDecimalNumber *)amount;

- (instancetype)initWithName:(NSString *)name
                      amount:(NSDecimalNumber *)amount;

@end


@interface AffirmItem : NSObject

// An item that is purchased.

// The name of the item. Required.
@property(nonatomic, copy, readonly) NSString *name;

// The SKU (stock keeping unit) of the item. Required.
@property(nonatomic, copy, readonly) NSString *SKU;

// The price per unit of the item. Cannot be negative. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *unitPrice;

// The quantity of items purchased. Cannot be negative. Required.
@property(nonatomic, assign, readonly) NSUInteger quantity;

// The URL of the item page. Required.
@property(nonatomic, copy, readonly) NSURL *URL;

// The URL of the item image. Required.
@property(nonatomic, copy, readonly) NSURL *imageURL;

+ (AffirmItem *)itemWithName:(NSString *)name
                         SKU:(NSString *)SKU
                   unitPrice:(NSDecimalNumber *)unitPrice
                    quantity:(NSUInteger)quantity
                         URL:(NSURL *)URL
                    imageURL:(NSURL *)imageURL;

- (instancetype)initWithName:(NSString *)name
                         SKU:(NSString *)SKU
                   unitPrice:(NSDecimalNumber *)unitPrice
                    quantity:(NSUInteger)quantity
                         URL:(NSURL *)URL
                    imageURL:(NSURL *)imageURL;

@end


@interface AffirmCheckout : NSObject

// A complete Affirm checkout object describing the customer and the purchase.

// A list of items purchased. Required.
@property(nonatomic, copy, readonly) NSArray *items;

// Billing contact information. Required.
@property(nonatomic, copy, readonly) AffirmContact *billing;

// Shipping contact information. Required.
@property(nonatomic, copy, readonly) AffirmContact *shipping;

// Tax amount. Cannot be negative. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *taxAmount;

// Shipping amount. Cannot be negative. Required.
@property(nonatomic, copy, readonly) NSDecimalNumber *shippingAmount;

// A list of discounts. Optional.
@property(nonatomic, copy, readonly) NSArray *discounts;

// Additional metadata for the checkout. Optional.
@property(nonatomic, copy, readonly) NSDictionary *metadata;

// The total purchase amount. Dynamically computed from the other properties of the checkout.
@property(nonatomic, copy, readonly) NSDecimalNumber *total;


+ (AffirmCheckout *)checkoutWithItems:(NSArray *)items
                              billing:(AffirmContact *)billing
                             shipping:(AffirmContact *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount;

+ (AffirmCheckout *)checkoutWithItems:(NSArray *)items
                              billing:(AffirmContact *)billing
                             shipping:(AffirmContact *)shipping
                            taxAmount:(NSDecimalNumber *)taxAmount
                       shippingAmount:(NSDecimalNumber *)shippingAmount
                            discounts:(NSArray *)discounts
                             metadata:(NSDictionary *)metadata;

- (instancetype)initWithItems:(NSArray *)items
                      billing:(AffirmContact *)billing
                     shipping:(AffirmContact *)shipping
                    taxAmount:(NSDecimalNumber *)taxAmount
               shippingAmount:(NSDecimalNumber *)shippingAmount
                    discounts:(NSArray *)discounts
                     metadata:(NSDictionary *)metadata;

@end