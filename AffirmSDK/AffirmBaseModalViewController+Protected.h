//
//  AffirmBaseModalViewControler+Protected.h
//  AffirmSDK
//
//  Created by Michael Blanton on 11/7/16.
//  Copyright © 2016 Affirm. All rights reserved.
//

#import "AffirmBaseModalViewController.h"
#import "AffirmCheckoutData.h"
#import "AffirmCheckoutDelegate.h"
#import "AffirmActivityIndicator.h"

NS_ASSUME_NONNULL_BEGIN


@interface AffirmBaseModalViewController () <UIWebViewDelegate>

/// The webview which displays the user interface for the checkuot.
@property UIWebView *webView;

// The loading indicator to be displayed while loading content.
@property AffirmActivityIndicator *loadingIndicator;

/// The loading count indicating webview progress.
@property NSInteger loadingCount;

/// The MODAL ID to be used.
@property (nonatomic, copy, readwrite) NSString *modalId;

@end


NS_ASSUME_NONNULL_END
