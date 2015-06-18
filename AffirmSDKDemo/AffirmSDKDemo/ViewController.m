//
//  ViewController.m
//  AffirmSDKDemo
//
//  Created by md143rbh7f on 6/10/15.
//  Copyright (c) 2015 Affirm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Affirm Checkout" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)checkoutCompleteWithToken:(NSString *)checkoutToken {
    // The user has completed the checkout and created a checkout token.
    // This token should be forwarded to your server, which should then authorize it with Affirm and create a charge.
    // For more information about the server integration, see https://docs.affirm.com/v2/api/charges
    [self dismissViewControllerAnimated:true completion:nil];
    [self showAlert:@"Checkout completed."];
}

- (void)checkoutCancelled {
    // The user has cancelled the checkout.
    [self dismissViewControllerAnimated:true completion:nil];
    [self showAlert:@"Checkout cancelled."];
}

- (void)checkoutCreationFailedWithError:(NSError *)error {
    // Checkout creation has failed for some reason.
    [self dismissViewControllerAnimated:true completion:nil];
    NSString *message = error.userInfo ? [NSString stringWithFormat:@"There was an error creating the checkout: %@", error.userInfo] : @"There was an unknown error creating the checkout.";
    [self showAlert:message];
}

- (IBAction)startCheckout:(id)sender {
    // Create the Affirm configuration.
    AffirmConfiguration *configuration = [AffirmConfiguration configurationWithAffirmDomain:@"sandbox.affirm.com" publicApiKey:@"Y8CQXFF044903JC0" financialProductKey:@"WWJ4P04080S6CFDS"];
    
    // Create the checkout object.
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.textField.text];
    AffirmItem *item = [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:price quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"] imageURL:[NSURL URLWithString:@"http://sandbox.affirm.com/image.png"]];
    AffirmAddress *address = [AffirmAddress addressWithLine1:@"325 Pacific Ave." line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94111" countryCode:@"USA"];
    AffirmContact *contact = [AffirmContact contactWithName:@"Test tester" address:address];
    AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] billing:contact shipping:contact taxAmount:[NSDecimalNumber zero] shippingAmount:[NSDecimalNumber zero]];
    
    // Initialize the view controller, which creates the checkout on Affirm and starts the user checkout flow.
    AffirmCheckoutViewController *vc = [AffirmCheckoutViewController checkoutControllerWithDelegate:self configuration:configuration checkout:checkout];
    [self presentViewController:vc animated:YES completion:nil];
}

@end