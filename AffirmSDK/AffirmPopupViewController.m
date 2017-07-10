//
//  AffirmPopupViewController.m
//  AffirmSDK
//
//  Created by md143rbh7f on 6/15/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "AffirmPopupViewController.h"

@interface AffirmPopupViewController ()

@property(nonatomic, copy, readwrite) NSURL *startURL;

@end

@implementation AffirmPopupViewController

- (instancetype)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        _startURL = [URL copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackButton];
    [self loadPage];
}

- (void)setupBackButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSelf)];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadPage {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:self.startURL]];
}

- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"mailto"] || [url.scheme isEqualToString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
