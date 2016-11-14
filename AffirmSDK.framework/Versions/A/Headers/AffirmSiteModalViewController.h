//
//  AffirmSiteModalViewController.h
//  AffirmSDK
//
//  Created by Michael Blanton on 9/22/16.
//  Copyright © 2016 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AffirmCheckoutData.h"
#import "AffirmConfiguration.h"
#import "AffirmBaseModalViewController.h"

NS_ASSUME_NONNULL_BEGIN


/// The AffirmSiteModalViewController is a view controller which loads the informational modal for the Affirm promotional messaging (see https://docs.affirm.com/Integrate_Affirm/Promotional_Messaging ). The View Controller handles the closing of the modal window by closing itself.
/// To launch the modal when a button is clicked, create an AffirmConfiguration instance, then create an AffirmSiteModalViewController instance, passing in the modalId (given to you by Affirm) and the configuration. Then present the view controller.
@interface AffirmSiteModalViewController : AffirmBaseModalViewController

@end


NS_ASSUME_NONNULL_END
