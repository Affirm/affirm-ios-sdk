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
@property (nonatomic, strong) AffirmAsLowAsButton *alaButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.textField.accessibilityLabel = @"price field";
    self.textField.delegate = self;
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width - 40, 40);
    self.alaButton = [AffirmAsLowAsButton createButtonWithPromoID:@"promo_set_ios" presentingViewController:self frame:frame];
    self.alaButton.center = CGPointMake(self.view.center.x, self.textField.frame.origin.y - 70);
    [self.view addSubview:self.alaButton];
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textField.text = @"";
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
    NSDecimalNumber *price = [[NSDecimalNumber decimalNumberWithString:self.textField.text] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    [self.alaButton configureWithAmount:price affirmLogoType:AffirmLogoTypeName affirmColor:AffirmColorTypeBlue maxFontSize:18 callback:^(BOOL alaEnabled, NSError *error) {
        //alaButton successfully configured
    }];
}

- (IBAction)checkout:(id)sender {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.textField.text];
    AffirmItem *item = [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:price quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"]];
    AffirmShippingDetail *shipping = [AffirmShippingDetail shippingDetailWithName:@"Chester Cheetah" addressWithLine1:@"633 Folsom Street" line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94107" countryCode:@"USA"];
    AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] shipping:shipping taxAmount:[NSDecimalNumber zero] shippingAmount:[NSDecimalNumber zero]];
    
    // Initializes a checkout view controller and starts the checkout process
    AffirmCheckoutViewController *checkoutVC = [AffirmCheckoutViewController startCheckout:checkout checkoutType:AffirmCheckoutTypeAutomatic delegate:self];
    [self presentViewController:checkoutVC animated:true completion:nil];
}

- (IBAction)showPromoModal:(id)sender {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.textField.text];
    AffirmPromoModalViewController *vc = [AffirmPromoModalViewController promoModalControllerWithModalId:@"promo_set_ios" amount:price];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)showFailedCheckout:(id)sender {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.textField.text];
    AffirmItem *item = [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:price quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"]];
    AffirmShippingDetail *shipping = [AffirmShippingDetail shippingDetailWithName:@"Test Tester" email:@"testtester@test.com" phoneNumber:@"1111111111" addressWithLine1:@"633 Folsom Street" line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94107" countryCode:@"USA"];
    AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] shipping:shipping taxAmount:[NSDecimalNumber zero] shippingAmount:[NSDecimalNumber zero]];
    
    // Initializes a checkout view controller and starts the checkout process
    AffirmCheckoutViewController *checkoutVC = [AffirmCheckoutViewController startCheckout:checkout checkoutType:AffirmCheckoutTypeAutomatic delegate:self];
    [self presentViewController:checkoutVC animated:true completion:nil];
}

#pragma mark - Affirm Checkout Delegate

- (void)checkoutReadyToPresent:(AffirmCheckoutViewController *)checkoutVC {
    // The checkout process is ready to begin
    NSLog(@"Checkout ready to present");
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
}

@end
