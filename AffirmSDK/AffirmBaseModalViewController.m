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
        self.webView = [UIWebView new];
        self.webView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self renderWebView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showLoadingIndicator];
}

- (void)renderWebView {
    [self.view addSubview:self.webView];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.scrollView.bounces = NO;
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraints:@[top, bottom, left, right]];
    
    self.loadingIndicator = [AffirmActivityIndicator new];
    self.loadingIndicator.center = self.view.center;
    self.loadingIndicator.indicatorColor = [UIColor colorWithRed:16/255.0 green:160/255.0 blue:234/255.0 alpha: 1.0];
    self.loadingIndicator.indicatorPathColor = [UIColor colorWithRed:246/255.0 green:248/255.0 blue:252/255.0 alpha:1.0];
    self.loadingIndicator.indicatorLineWidth = 1.5;
}

#pragma mark - Webview

- (void) showLoadingIndicator {
    if (self.loadingCount == 0) {
        [self.loadingIndicator startAnimatingOnView:self.view];
    }
    self.loadingCount += 1;
}

- (void) hideLoadingIndicator {
    self.loadingCount -= 1;
    if (self.loadingCount <= 0) {
        [self.loadingIndicator stopAnimating];
    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadingIndicator];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoadingIndicator];
    [AffirmLogger logEvent:@"Web load failed" info:@{@"failed_url": webView.request.URL.absoluteString, @"error_description" : error.localizedDescription}];
    NSString *url = [NSString stringWithFormat:@"https://www.affirm.com/u/#/error?main=Error&sub=%@", [error.localizedDescription stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

@end
