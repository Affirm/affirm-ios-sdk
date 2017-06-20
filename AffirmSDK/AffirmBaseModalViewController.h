//
//  AffirmBaseModalViewController.h
//  AffirmSDK
//
//  Created by Michael Blanton on 11/7/16.
//  Copyright © 2016 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AffirmCheckoutData.h"

NS_ASSUME_NONNULL_BEGIN


/// The AffirmBaseModalViewController is a view controller which loads the informational modal for the Affirm promotional messaging (see https://docs.affirm.com/Integrate_Affirm/Promotional_Messaging ). The View Controller handles the closing of the modal window by closing itself.
/// To launch the modal when a button is clicked, create an AffirmConfiguration instance, then create an AffirmSiteModalViewController instance, passing in the modalId (given to you by Affirm) and the configuration. Then present the view controller.
@interface AffirmBaseModalViewController : UIViewController

@end


NS_ASSUME_NONNULL_END
