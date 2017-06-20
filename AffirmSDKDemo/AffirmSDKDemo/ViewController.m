//
//  ViewController.m
//  AffirmSDKDemo
//
//  Created by Sachin Kesiraju on 6/19/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "ViewController.h"
#import <AffirmSDK/AffirmSDK.h>

@interface ViewController () <AffirmCheckoutDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *asLowAsLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.textField.delegate = self;
    
    [self reloadAffirmAsLowAs];
}

- (void)setupView {
    UIToolbar *toolBar = [UIToolbar new];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.textField action:@selector(resignFirstResponder)];
    toolBar.items = @[ flexibleItem, doneItem ];
    [toolBar sizeToFit];
    self.textField.inputAccessoryView = toolBar;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self reloadAffirmAsLowAs];
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Affirm Checkout" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Affirm

- (void)reloadAffirmAsLowAs {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.textField.text];
    [AffirmAsLowAs getAffirmAsLowAsForAmount:price promoId:@"SFCRL4VYS0C78607" fontSize:self.asLowAsLabel.font.pointSize affirmLogoType:AffirmLogoTypeName affirmColor:AffirmColorTypeBlue callback:^(NSString *asLowAsText, UIImage *logo, NSError *error, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.asLowAsLabel.attributedText = [AffirmAsLowAs appendLogo:logo toText:asLowAsText]; //Helper method that inserts the Affirm logo into the asLowAs text
                self.asLowAsLabel.adjustsFontSizeToFitWidth = YES;
            });
        } else {
            NSLog(@"As low as error: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)checkout:(id)sender {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:@"500"];
    AffirmItem *item = [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:price quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"]];
    AffirmShippingDetail *shipping = [AffirmShippingDetail shippingDetailWithName:@"Chester Cheetah" addressWithLine1:@"633 Folsom" line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94111" countryCode:@"USA"];
    AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] shipping:shipping taxAmount:[NSDecimalNumber zero] shippingAmount:[NSDecimalNumber zero]];
    
    // Initializes a checkout view controller and starts the checkout process
    // Option to present view controller when delegate receives readyToPresent notification
    [AffirmCheckoutViewController startCheckout:checkout withDelegate:self];
    
    // Alternatively, can present view controller at this point and SDK will handle loading state
    // AffirmCheckoutViewController *checkoutVC = [AffirmCheckoutViewController startCheckout:checkout withDelegate:self];
    // [self presentViewController:checkoutVC animated:true completion:nil];
}

- (IBAction)showProductModal:(id)sender {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:@"500"];
    AffirmProductModalViewController *vc = [AffirmProductModalViewController productModalControllerWithModalId:@"0Q97G0Z4Y4TLGHGB" amount:price];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)showSiteModal:(id)sender {
    AffirmSiteModalViewController *vc = [AffirmSiteModalViewController siteModalControllerWithModalId:@"5LNMQ33SEUYHLNUC"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Affirm Checkout Delegate

- (void)checkoutReadyToPresent:(AffirmCheckoutViewController *)checkoutVC {
    // The checkout process is ready to begin
    NSLog(@"Checkout ready to present");
    [self presentViewController:checkoutVC animated:true completion:nil];
}

- (void)checkout:(AffirmCheckoutViewController *)checkoutVC completedWithToken:(NSString *)checkoutToken {
    // The user has completed the checkout and created a checkout token.
    // This token should be forwarded to your server, which should then authorize it with Affirm and create a charge.
    // For more information about the server integration, see https://docs.affirm.com/v2/api/charges
    NSLog(@"Received token %@", checkoutToken);
    [self dismissViewControllerAnimated:true completion:nil];
    [self showAlert:@"Checkout completed"];
}

- (void)checkoutCancelled:(AffirmCheckoutViewController *)checkoutVC {
    // The checkout process was cancelled
    NSLog(@"Checkout was cancelled");
    [self dismissViewControllerAnimated:true completion:nil];
    [self showAlert:@"Checkout cancelled"];
}

- (void)checkout:(AffirmCheckoutViewController *)checkoutVC creationFailedWithError:(NSError *)error {
    // The checkout process failed
    NSLog(@"Checkout failed with error: %@", error.localizedDescription);
    [self dismissViewControllerAnimated:true completion:nil];
    [self showAlert:error.localizedDescription];
}

@end
