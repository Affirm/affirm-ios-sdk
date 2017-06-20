//
//  AffirmPopupViewController.h
//  AffirmSDK
//
//  Created by md143rbh7f on 6/15/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AffirmBaseModalViewController+Protected.h"

NS_ASSUME_NONNULL_BEGIN


/// The AffirmPopupViewController is a view controller which manages the various popups which users may see.
@interface AffirmPopupViewController : AffirmBaseModalViewController

/// Initializer.
/// @param URL The disclosure URL.
/// @return The initialized disclosure view controller.
- (instancetype)initWithURL:(NSURL *)URL;

@end


NS_ASSUME_NONNULL_END
