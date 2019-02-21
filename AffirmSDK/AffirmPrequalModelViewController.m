//
//  AffirmPrequalModelViewController.m
//  AffirmSDK
//
//  Created by Victor Zhu on 2019/2/20.
//  Copyright © 2019 Affirm. All rights reserved.
//

#import "AffirmPrequalModelViewController.h"
#import "AffirmAsLowAsButton+Protected.h"
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
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.webView.contentMode = UIViewContentModeScaleAspectFit;
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSelf)];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SFSafariViewController delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = navigationAction.request.URL.absoluteString;
    if ([urlString isEqualToString:AFFIRM_PREQUAL_REFERRING_URL]) {
        [self dismissSelf];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

@end
