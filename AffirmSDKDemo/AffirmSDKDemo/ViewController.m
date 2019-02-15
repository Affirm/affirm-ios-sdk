//
//  ViewController.m
//  AffirmSDKDemo
//
//  Created by Sachin Kesiraju on 6/19/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#define AMOUNT_FIELD_TAG 1
#define PROMO_ID_FIELD_TAG 2
#define PUBLIC_API_KEY_FIELD_TAG 3

#import "ViewController.h"
#import <AffirmSDK/AffirmSDK.h>

@interface ViewController () <AffirmCheckoutDelegate>

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *promoIDField;
@property (weak, nonatomic) IBOutlet UITextField *publicAPIKeyField;
@property (nonatomic, strong) AffirmAsLowAsButton *alaButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultValues];
    [self setAPIKey];
    [self setupView];
    [self reloadAffirmAsLowAs];
}

- (void)setupView {
    [self configureTextField:self.amountField withLabel:@"price input" andTag:AMOUNT_FIELD_TAG];
    [self configureTextField:self.promoIDField withLabel:@"promo ID input" andTag:PROMO_ID_FIELD_TAG];
    [self configureTextField:self.publicAPIKeyField withLabel:@"public API key input" andTag:PUBLIC_API_KEY_FIELD_TAG];

    self.alaButton = [AffirmAsLowAsButton createButtonWithPromoID:self.promoIDField.text showCTA:true presentingViewController:self frame:CGRectMake(0, 0, self.view.frame.size.width - 40, 40)];
    [self.stackView insertArrangedSubview:self.alaButton atIndex:0];
}

- (void)setDefaultValues {
    self.amountField.text = @"500";
    self.promoIDField.text = PROMO_ID;
    self.publicAPIKeyField.text = PUBLIC_API_KEY;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case AMOUNT_FIELD_TAG:
            break;
        case PROMO_ID_FIELD_TAG:
            self.alaButton.promoID = [textField.text copy];
            break;
        case PUBLIC_API_KEY_FIELD_TAG:
            [self setAPIKey];
            break;
    }
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

- (void)configureTextField:(UITextField *)target withLabel:(NSString *)label andTag:(NSInteger)tag {
    UIToolbar *amountToolBar = [UIToolbar new];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:@selector(resignFirstResponder)];
    amountToolBar.items = @[ flexibleItem, doneItem ];
    [amountToolBar sizeToFit];
    target.inputAccessoryView = amountToolBar;

    target.tag = tag;
    target.accessibilityLabel = label;
    target.delegate = self;
}

- (void)reloadAffirmAsLowAs {
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.amountField.text];
    [self.alaButton configureWithAmount:price affirmLogoType:AffirmLogoTypeName affirmColor:AffirmColorTypeBlue maxFontSize:18 callback:^(BOOL alaEnabled, NSError *error) {
        //alaButton successfully configured
    }];
}

- (void)setAPIKey {
    AffirmConfiguration *config = [AffirmConfiguration configurationWithPublicAPIKey:self.publicAPIKeyField.text environment:AffirmEnvironmentSandbox];
    //set the configuration as the shared configuration to be used across your app
    [AffirmConfiguration setSharedConfiguration:config];
}

- (IBAction)checkout:(id)sender {
    NSDecimalNumber *dollarPrice = [NSDecimalNumber decimalNumberWithString:self.amountField.text];
    NSNumber *centsPrice = [AffirmNumberUtils decimalDollarsToIntegerCents:dollarPrice];
    AffirmItem *item = [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:dollarPrice quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"]];
    AffirmShippingDetail *shipping = [AffirmShippingDetail shippingDetailWithName:@"Chester Cheetah" addressWithLine1:@"633 Folsom Street" line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94107" countryCode:@"USA"];
    AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] shipping:shipping totalAmount:centsPrice];
    
    // Initializes a checkout view controller and starts the checkout process
    AffirmCheckoutViewController *checkoutVC = [AffirmCheckoutViewController startCheckout:checkout checkoutType:AffirmCheckoutTypeAutomatic useVCN:NO delegate:self];
    [self presentViewController:checkoutVC animated:true completion:nil];
}

- (IBAction)showFailedCheckout:(id)sender {
    NSDecimalNumber *dollarPrice = [NSDecimalNumber decimalNumberWithString:self.amountField.text];
    NSNumber *centsPrice = [AffirmNumberUtils decimalDollarsToIntegerCents:dollarPrice];
    AffirmItem *item = [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:dollarPrice quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"]];
    AffirmShippingDetail *shipping = [AffirmShippingDetail shippingDetailWithName:@"Test Tester" email:@"testtester@test.com" phoneNumber:@"1111111111" addressWithLine1:@"633 Folsom Street" line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94107" countryCode:@"USA"];
    AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] shipping:shipping totalAmount:centsPrice];
    
    // Initializes a checkout view controller and starts the checkout process
    AffirmCheckoutViewController *checkoutVC = [AffirmCheckoutViewController startCheckout:checkout checkoutType:AffirmCheckoutTypeAutomatic useVCN:NO delegate:self];
    [self presentViewController:checkoutVC animated:true completion:nil];
}

- (IBAction)vcnCheckout:(UIButton *)sender {
    NSDecimalNumber *dollarPrice = [NSDecimalNumber decimalNumberWithString:self.amountField.text];
    NSNumber *centsPrice = [AffirmNumberUtils decimalDollarsToIntegerCents:dollarPrice];
    AffirmItem *item = [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:dollarPrice quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"]];
    AffirmShippingDetail *shipping = [AffirmShippingDetail shippingDetailWithName:@"Chester Cheetah" addressWithLine1:@"633 Folsom Street" line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94107" countryCode:@"USA"];
    AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] shipping:shipping totalAmount:centsPrice];
    
    // Initializes a checkout view controller and starts the checkout process
    AffirmCheckoutViewController *checkoutVC = [AffirmCheckoutViewController startCheckout:checkout checkoutType:AffirmCheckoutTypeAutomatic useVCN:YES delegate:self];
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
    NSLog(@"Received token %@", checkoutToken);
    [self dismissViewControllerAnimated:true completion:nil];
    [self showAlert:@"Checkout completed"];
}

- (void)vcnCheckout:(AffirmCheckoutViewController *)checkoutVC completedWithCardInfo:(NSString *)cardInfo {
    // The user has completed the checkout and returned card details.
    // All charge actions are done using your existing payment gateway and debit card processor
    NSLog(@"Received card info %@", cardInfo);
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
