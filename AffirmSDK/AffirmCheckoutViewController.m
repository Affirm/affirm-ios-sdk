//
//  AffirmCheckoutViewController.m
//  Affirm-iOS-SDK
//
//  Created by Elliot Babchick on 5/21/15.
//  Copyright (c) 2015 Affirm, Inc. All rights reserved.
//

#import "AffirmCheckoutViewController+Protected.h"
#import "AffirmPopupViewController.h"
#import "AffirmCheckoutData+Protected.h"
#import "AffirmCheckoutDelegate.h"
#import "AffirmConfiguration+Protected.h"
#import "AffirmErrorModal.h"
#import "AffirmUtils.h"
#import "AffirmLogger.h"

@implementation AffirmCheckoutViewController

- (instancetype)initWithDelegate:(id<AffirmCheckoutDelegate>)delegate
                        checkout:(AffirmCheckout *)checkout
                    checkoutType:(AffirmCheckoutType)checkoutType {
    [AffirmValidationUtils checkNotNil:delegate name:@"delegate"];
    [AffirmValidationUtils checkNotNil:checkout name:@"checkout"];
    
    if (self = [super init]) {
        _checkout = [checkout copy];
        _configuration = [[AffirmConfiguration sharedConfiguration] copy];
        _checkoutType = checkoutType;
    }
    self.delegate = delegate;
    [self prepareForCheckout];
    return self;
}

+ (AffirmCheckoutViewController *)startCheckout:(AffirmCheckout *)checkout checkoutType:(AffirmCheckoutType)checkoutType delegate:(nonnull id<AffirmCheckoutDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate checkout:checkout checkoutType:checkoutType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSData *)getCheckoutData {
    NSMutableDictionary *checkoutDict = [self.checkout toJSONDictionary];
    [checkoutDict addEntriesFromDictionary:@{
                                             @"merchant": @{
                                                     @"public_api_key": self.configuration.publicAPIKey,
                                                     @"user_confirmation_url": AFFIRM_CHECKOUT_CONFIRMATION_URL,
                                                     @"user_cancel_url": AFFIRM_CHECKOUT_CANCELLATION_URL,
                                                     @"user_confirmation_url_action": @"GET"
                                                     }}];
    NSError *error;
    return [NSJSONSerialization dataWithJSONObject:@{@"checkout": checkoutDict} options:0 error:&error];;
}

- (NSURLRequest *)createCheckoutRequest {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.configuration.affirmCheckoutURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Affirm-iOS-SDK" forHTTPHeaderField:@"Affirm-User-Agent"];
    [request setValue:[AffirmConfiguration affirmSDKVersion] forHTTPHeaderField:@"Affirm-User-Agent-Version"];
    [request setHTTPBody:[self getCheckoutData]];
    return request;
}

- (void) prepareForCheckout {
    [AffirmLogger logEvent:@"Checkout initiated"];
    [self.loadingIndicator startAnimatingOnView:self.view];
    self.loadingIndicator.hidden = self.checkoutType == AffirmCheckoutTypeManual;
    NSURLRequest *request = [self createCheckoutRequest];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
        if (response.statusCode != 200) {
            NSError *descriptiveError = [AffirmErrorUtils errorFromInfo:result];
            [AffirmLogger logEvent:@"Checkout creation failed" info:descriptiveError.userInfo];
            if (self.checkoutType == AffirmCheckoutTypeAutomatic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.loadingIndicator stopAnimating];
                    [AffirmErrorModal showErrorModalWithTitle:@"Checkout Error" description:descriptiveError.localizedDescription onView:self.view withCloseBlock:^(AffirmErrorModal *errorModal) {
                        [self.delegate checkout:self creationFailedWithError:[AffirmErrorUtils errorFromInfo:result]];
                    }];
                });
            } else {
                [self.delegate checkout:self creationFailedWithError:[AffirmErrorUtils errorFromInfo:result]];
            }
        } else {
            NSString *redirect_url = [result objectForKey:@"redirect_url"];
            if (redirect_url) {
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:redirect_url]]];
                [self.delegate checkoutReadyToPresent:self];
                self.checkoutARI = [redirect_url lastPathComponent];
                [AffirmLogger logEvent:@"Checkout ready to present" info:@{@"checkout_ari": self.checkoutARI}];
            } else {
                [AffirmLogger logEvent:@"Checkout redirect missing"];
                [self.delegate checkout:self creationFailedWithError:[NSError errorWithDomain:self.configuration.affirmDomain code:-1 userInfo:result]];
            }
        }
    }];
}

- (void)showPopup:(NSURL *)URL {
    AffirmPopupViewController *vc = [[AffirmPopupViewController alloc] initWithURL:URL];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

+ (BOOL)isAffirmDomain:(NSString *)domain {
    return [domain hasSuffix:@"affirm.com"] || [domain hasSuffix:@"affirm-stage.com"] || [domain hasSuffix:@"affirm-dev.com"];
}

+ (void)logOut {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        if ([self isAffirmDomain:cookie.domain]) {
            [cookieStorage deleteCookie:cookie];
        }
    }
}

#pragma mark - Webview

- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *strippedURL = [NSString stringWithFormat:@"%@://%@%@", URL.scheme, URL.host, URL.path];
    if ([strippedURL isEqualToString:AFFIRM_CHECKOUT_CONFIRMATION_URL]) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:URL.absoluteString];
        NSString *checkoutToken;
        for(NSURLQueryItem *item in urlComponents.queryItems) {
            if([item.name isEqualToString:@"checkout_token"]) {
                checkoutToken = item.value;
                break;
            }
        }
        [self.delegate checkout:self completedWithToken:checkoutToken];
        [AffirmLogger logEvent:@"Checkout completed" info:@{@"checkout_ari": self.checkoutARI, @"checkout_token_received": checkoutToken != nil ? @"true" : @"false"}];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([strippedURL isEqualToString:AFFIRM_CHECKOUT_CANCELLATION_URL]) {
        [self.delegate checkoutCancelled:self];
        [AffirmLogger logEvent:@"Checkout cancelled" info:@{@"checkout_ari": self.checkoutARI}];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    [self webView:webView checkIfURL:URL.absoluteString isPopupWithCompletion:^(BOOL isPopup) {
        if (isPopup) {
            [self showPopup:URL];
            [AffirmLogger logEvent:@"External link selected from checkout" info:@{@"checkout_ari": self.checkoutARI, @"selected_link": URL.absoluteString}];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }];
}

- (void)webView:(WKWebView *)webView checkIfURL:(NSString *)URLString isPopupWithCompletion:(void(^)(BOOL isPopup))completion {
    NSString *JSCodeFormat = @"javascript: (function () {"
    "var anchors = document.getElementsByTagName('a');"
    "for (var i = 0; i < anchors.length; i++) {"
    "if (anchors[i].target == '_blank' && anchors[i].href == '%@') {"
    "return true;"
    "}"
    "}"
    "return false;"
    "})();"
    ;
    NSString *JSCode = [NSString stringWithFormat:JSCodeFormat, URLString];
    [webView evaluateJavaScript:JSCode completionHandler:^(id result, NSError *error) {
        completion([result boolValue]);
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(false);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(true);
                                                      }]];
    
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
