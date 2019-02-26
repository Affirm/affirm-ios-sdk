//
//  AffirmCreditCard.h
//  AffirmSDK
//
//  Created by yijie on 2019/2/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AffirmCreditCardBillAddress : NSObject

/// City.
@property (nonatomic, copy, readonly, nullable) NSString *city;

/// State.
@property (nonatomic, copy, readonly, nullable) NSString *state;

/// ZIP code.
@property (nonatomic, copy, readonly, nullable) NSString *zipcode;

/// Address line 1.
@property (nonatomic, copy, readonly, nullable) NSString *line1;

/// Address line 2.
@property (nonatomic, copy, readonly, nullable) NSString *line2;

/// Initializer. See properties for more details.
/// @param dict Data dictionary.
/// @return The initialized bill address.
- (instancetype)initWithDict: (NSDictionary *)dict;

@end

@interface AffirmCreditCard : NSObject

/// Billing Address. Optional
@property (nonatomic, strong, readonly, nullable) AffirmCreditCardBillAddress *billing_address;

/// Checkout Token. Required
@property (nonatomic, copy, readonly, nonnull) NSString *checkout_token;

/// Create Date. Optional
@property (nonatomic, copy, readonly, nullable) NSString *created;

/// Card CVV. Required
@property (nonatomic, copy, readonly, nonnull) NSString *cvv;

/// Card number. Required
@property (nonatomic, copy, readonly, nonnull) NSString *number;

/// Call back id. Required
@property (nonatomic, copy, readonly, nonnull) NSString *callback_id;

/// Card holder name. Required
@property (nonatomic, copy, readonly, nonnull) NSString *cardholder_name;

/// Card expiration. Required
@property (nonatomic, copy, readonly, nonnull) NSString *expiration;

/// id. Required
@property (nonatomic, copy, readonly, nonnull) NSString *creditCard_id;

/// Convenience constructor for a credit card object with dictionary data.
/// @param dict Data dictionary.
/// @return The initialized credit card info.
+ (AffirmCreditCard *)creditCardWithDict: (NSDictionary *)dict;

/// Initializer. See properties for more details.
/// @param dict Data dictionary.
/// @return The initialized credit card info.
- (instancetype)initWithDict: (NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
