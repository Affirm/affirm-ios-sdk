//
//  AffirmProductModalViewController.h
//  AffirmSDK
//
//  Created by Michael Blanton on 10/25/16.
//  Copyright © 2016 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AffirmBaseModalViewController.h"
#import "AffirmCheckoutData.h"

NS_ASSUME_NONNULL_BEGIN


/// The AffirmProductModalViewController is a view controller which loads the informational modal for the Affirm promotional messaging (see https://docs.affirm.com/Integrate_Affirm/Promotional_Messaging ). The View Controller handles the closing of the modal window by closing itself.
/// To launch the modal when a button is clicked, create an AffirmConfiguration instance, then create an AffirmProductModalViewController instance, passing in the modalId (given to you by Affirm), the product amount, and the configuration. Then present the view controller.
@interface AffirmProductModalViewController : AffirmBaseModalViewController

+ (instancetype)productModalControllerWithModalId:(NSString *)modalId
                                           amount:(NSDecimalNumber *)amount
                                    configuration:(AffirmConfiguration *)configuration;


@end


NS_ASSUME_NONNULL_END
