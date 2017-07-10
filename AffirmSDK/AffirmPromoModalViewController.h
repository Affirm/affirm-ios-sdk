//
//  AffirmPromoModalViewController.h
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 6/29/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "AffirmBaseModalViewController+Protected.h"

@interface AffirmPromoModalViewController : AffirmBaseModalViewController

+ (instancetype)promoModalControllerWithModalId:(NSString *)modalId
                                         amount:(NSDecimalNumber *)amount;

@end
