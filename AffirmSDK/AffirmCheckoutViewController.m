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
#import "AffirmUtils.h"
#import "AffirmLogger.h"

@implementation AffirmCheckoutViewController

- (instancetype)initWithDelegate:(id<AffirmCheckoutDelegate>)delegate
                        checkout:(AffirmCheckout *)checkout {
    [AffirmValidationUtils checkNotNil:delegate name:@"delegate"];
    [AffirmValidationUtils checkNotNil:checkout name:@"checkout"];
    
    if (self = [super init]) {
        _checkout = [checkout copy];
        _configuration = [[AffirmConfiguration sharedConfiguration] copy];
    }
    self.delegate = delegate;
    [self prepareForCheckout];
    return self;
}

+ (AffirmCheckoutViewController *)startCheckout:(AffirmCheckout *)checkout withDelegate:(id<AffirmCheckoutDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate checkout:checkout];
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
                                                     @"user_cancel_url": AFFIRM_CHECKOUT_CANCELLATION_URL
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
    NSURLRequest *request = [self createCheckoutRequest];
    [AffirmNetworkUtils performNetworkRequest:request withCompletion:^(NSDictionary *result, NSHTTPURLResponse *response, NSError *error) {
        if (response.statusCode != 200) {
            NSError *descriptiveError = [AffirmErrorUtils errorFromInfo:result];
            [self.delegate checkout:self creationFailedWithError:descriptiveError];
            [AffirmLogger logEvent:@"Checkout creation failed" info:error.userInfo];
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

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = request.URL.absoluteString;
    if ([URLString isEqualToString:AFFIRM_CHECKOUT_CONFIRMATION_URL]) {
        NSString* formString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        NSString* checkoutToken = [formString componentsSeparatedByString:@"="][1];
        [self.delegate checkout:self completedWithToken:checkoutToken];
        [AffirmLogger logEvent:@"Checkout completed" info:@{@"checkout_ari": self.checkoutARI}];
        return NO;
    }
    else if ([URLString isEqualToString:AFFIRM_CHECKOUT_CANCELLATION_URL]) {
        [self.delegate checkoutCancelled:self];
        [AffirmLogger logEvent:@"Checkout cancelled" info:@{@"checkout_ari": self.checkoutARI}];
        return NO;
    }
    else if ([self webView:webView isPopup:URLString]) {
        [self showPopup:request.URL];
        [AffirmLogger logEvent:@"External link selected from checkout" info:@{@"checkout_ari": self.checkoutARI, @"selected_link" : URLString}];
        return NO;
    }
    return YES;
}

- (BOOL)webView:(UIWebView *)webView
        isPopup:(NSString *)URLString {
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
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:JSCode];
    return [result isEqualToString:@"true"];
}

@end
