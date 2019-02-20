//
//  AffirmPrequalModelViewController.m
//  AffirmSDK
//
//  Created by Victor Zhu on 2019/2/20.
//  Copyright © 2019 Affirm. All rights reserved.
//

#import "AffirmPrequalModelViewController.h"
#import "AffirmConfiguration+Protected.h"
#import "AffirmUtils.h"

@interface AffirmPrequalModelViewController ()

@end

@implementation AffirmPrequalModelViewController

+ (instancetype)controllerWithURL:(NSURL *)url {
    AffirmConfiguration *configuration = [AffirmConfiguration sharedConfiguration];
    [AffirmValidationUtils checkNotNil:configuration];

    return [[self alloc] initWithURL:url];
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return self;
}

#pragma mark - SFSafariViewController delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.navigationType == WKNavigationTypeOther && navigationAction.request.URL) {

    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

@end
