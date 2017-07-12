//
//  AffirmPromoModalViewController.m
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 6/29/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "AffirmPromoModalViewController.h"
#import "AffirmConfiguration+Protected.h"
#import "AffirmUtils.h"

@implementation AffirmPromoModalViewController

+ (instancetype)promoModalControllerWithModalId:(NSString *)modalId
                                         amount:(NSDecimalNumber *)amount {
    AffirmConfiguration *configuration = [AffirmConfiguration sharedConfiguration];
    [AffirmValidationUtils checkNotNil:configuration];
    
    NSBundle *sdkBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"AffirmSDK" ofType:@"bundle"]];
    NSString *filePath = [sdkBundle pathForResource:@"promo_modal_template" ofType:@"html"];
    NSString *rawContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *content = [NSString stringWithFormat:rawContent, configuration.publicAPIKey, configuration.affirmJavascriptURL.absoluteString, [AffirmNumberUtils decimalDollarsToIntegerCents:amount], modalId, AFFIRM_CHECKOUT_CANCELLATION_URL];
    
    return [[self alloc] initWithContent:content];
}

- (instancetype)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        [self.webView loadHTMLString:content baseURL:nil];
    }
    return self;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlString = navigationAction.request.URL.absoluteString;
    if ([urlString isEqualToString:AFFIRM_CHECKOUT_CANCELLATION_URL]) {
        [self dismissViewControllerAnimated:true completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    [webView evaluateJavaScript:@"document.getElementById('affirm_learn_more_splitpay').src = 'applewebdata://';" completionHandler:nil];
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
