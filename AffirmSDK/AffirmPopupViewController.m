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
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:self.startURL]];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"mailto"] || [request.URL.scheme isEqualToString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
        return NO;
    }
    return YES;
}

@end
