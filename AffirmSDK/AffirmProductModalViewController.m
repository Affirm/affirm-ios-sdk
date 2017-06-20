//
//  AffirmProductModalViewController.m
//  AffirmSDK
//
//  Created by Michael Blanton on 10/25/16.
//  Copyright © 2016 Affirm. All rights reserved.
//

#import "AffirmProductModalViewController+Protected.h"
#import "AffirmConfiguration+Protected.h"
#import "AffirmUtils.h"

@implementation AffirmProductModalViewController

+ (instancetype)productModalControllerWithModalId:(NSString *)modalId
                                           amount:(NSDecimalNumber *)amount {
    AffirmConfiguration *configuration = [AffirmConfiguration sharedConfiguration];
    [AffirmValidationUtils checkNotNil:configuration];
    
    NSBundle *sdkBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"AffirmSDK" withExtension:@"bundle"]];
    NSString *filePath = [sdkBundle pathForResource:@"product_modal_template" ofType:@"html"];
    NSString *rawContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *content = [NSString stringWithFormat:rawContent, [AffirmNumberUtils decimalDollarsToIntegerCents:amount], modalId, configuration.publicAPIKey, configuration.affirmJavascriptURL.absoluteString, AFFIRM_CHECKOUT_CANCELLATION_URL];

    return [[self alloc] initWithContent:content];
}

- (instancetype)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        [self.webView loadHTMLString:content baseURL:nil];
    }
    return self;
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = request.URL.absoluteString;
    if ([URLString isEqualToString:AFFIRM_CHECKOUT_CANCELLATION_URL]) {
        [self dismissViewControllerAnimated:true completion:nil];
        return NO;
    }
    return YES;
}

@end
