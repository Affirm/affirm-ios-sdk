//
//  AffirmBaseModalViewController.m
//  AffirmSDK
//
//  Created by Michael Blanton on 11/7/16.
//  Copyright © 2016 Affirm. All rights reserved.
//

#import "AffirmBaseModalViewController+Protected.h"
#import "AffirmUtils.h"
#import "AffirmLogger.h"

@implementation AffirmBaseModalViewController

- (instancetype)init {
    if (self = [super init]) {
        self.webView = [[WKWebView alloc] init];
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        
        self.loadingIndicator = [AffirmActivityIndicator new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self renderWebView];
}

- (void)renderWebView {
    [self.view addSubview:self.webView];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureUserAgent];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraints:@[top, bottom, left, right]];
    
    self.loadingIndicator.center = self.view.center;
    self.loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.loadingIndicator.indicatorColor = [UIColor colorWithRed:16/255.0 green:160/255.0 blue:234/255.0 alpha: 1.0];
    self.loadingIndicator.indicatorPathColor = [UIColor colorWithRed:246/255.0 green:248/255.0 blue:252/255.0 alpha:1.0];
    self.loadingIndicator.indicatorLineWidth = 1.5;
    [self.loadingIndicator startAnimatingOnView:self.view];
}

- (void)configureUserAgent {
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        if (result && ![result containsString:@"Affirm-iOS-SDK"]) {
            NSString *sdkUserAgent = [NSString stringWithFormat:@"Affirm-iOS-SDK-%@ %@", [AffirmConfiguration affirmSDKVersion], result];
            [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": sdkUserAgent}];
        }
    }];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
}

#pragma mark - Webview

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        if (self.webView.estimatedProgress >= 1.0f) {
            [self.loadingIndicator stopAnimating];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadingIndicator stopAnimating];
    [AffirmLogger logEvent:@"Web load failed" info:@{@"error_description" : error.localizedDescription}];
    NSString *url = [NSString stringWithFormat:@"https://www.affirm.com/u/#/error?main=Error&sub=%@", [error.localizedDescription stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

@end
