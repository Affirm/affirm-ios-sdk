## If this is your first time integrating this Affirm iOS SDK, please use the following repository:
```
github "Affirm/affirm-merchant-sdk-ios"
```
Affirm iOS SDK
==============
[![CocoaPods](https://img.shields.io/cocoapods/v/AffirmSDK.svg)](http://cocoadocs.org/docsets/AffirmSDK) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Travis](https://travis-ci.org/Affirm/affirm-ios-sdk.svg?branch=master)](https://travis-ci.org/Affirm/affirm-ios-sdk) [![license](https://img.shields.io/cocoapods/l/AffirmSDK.svg)]()

The Affirm iOS SDK allows you accept Affirm payments in your own app.

Installation
============

[CocoaPods](https://cocoapods.org/) and [Carthage](https://github.com/Carthage/Carthage) are the recommended methods for installing the Affirm SDK. 

<strong> CocoaPods </strong>

Add the following to your Podfile and run `pod install`
```ruby
pod 'AffirmSDK'
```

<strong> Carthage </strong>

Add the following to your Cartfile and follow the setup instructions [here](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).
```
github "Affirm/affirm-ios-sdk"
```
<strong> Manual </strong>

Alternatively, if you do not want to use CocoaPods or Carthage, you may clone our [GitHub repository](https://github.com/Affirm/affirm-ios-sdk) and simply drag and drop the `AffirmSDK` folder into your XCode project.

Usage Overview
==============

An Affirm integration consists of two components: checkout and promotional messaging.

Before you can use these components, you must first set the AffirmSDK with your public API key from your [Merchant Dashboard](https://sandbox.affirm.com/dashboard). You must set this key to the shared AffirmConfiguration once (preferably in your AppDelegate) as follows:
```
AffirmConfiguration *config = [AffirmConfiguration configurationWithPublicAPIKey:@"PUBLIC_API_KEY" environment:AffirmEnvironmentSandbox];
[AffirmConfiguration setSharedConfiguration:config];
```

## Checkout

### Checkout creation

Checkout creation is the process in which a customer uses Affirm to pay for a purchase in your store. This process is governed by the `AffirmCheckoutViewController` object, which requires three parameters:

- An `AffirmCheckout` object which contains details about the purchase itself
- An `AffirmCheckoutType` which determines whether the checkout flow should use the SDK's built-in loading indicator and error modal to handle loading and error states in the checkout process or if the developer will handle these states manually
- An `useVCN` which determines whether the checkout flow should use virtual card network to handle the checkout, if set YES, it will return card info from this delegate ```- (void)vcnCheckout:(AffirmCheckoutViewController *)checkoutVC completedWithCreditCard:(AffirmCreditCard *)creditCard```, if set NO, it will return token from this delegate ```- (void)checkout:(AffirmCheckoutViewController *)checkoutVC completedWithToken:(NSString *)checkoutToken```
- An `AffirmCheckoutDelegate` object which receives messages at various stages in the checkout process

Once the AffirmCheckoutViewController has been constructed from the parameters above, you may present it as with any other view controller. This initiates the flow which guides the user through the Affirm checkout process. An example of how this is implemented is provided as follows:
```
// initialize an AffirmItem with item details
AffirmItem *item = [AffirmItem itemWithName:@"Affirm Test Item" SKU:@"test_item" unitPrice:price quantity:1 URL:[NSURL URLWithString:@"http://sandbox.affirm.com/item"]];

// initialize an AffirmShippingDetail with the user's shipping address
AffirmShippingDetail *shipping = [AffirmShippingDetail shippingDetailWithName:@"Chester Cheetah" addressWithLine1:@"633 Folsom Street" line2:@"" city:@"San Francisco" state:@"CA" zipCode:@"94107" countryCode:@"USA"];

// initialize an AffirmCheckout object with the item(s), shipping details, shipping amount, and tax amount
AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] shipping:shipping taxAmount:[NSDecimalNumber zero] shippingAmount:[NSDecimalNumber zero]];

// alternatively, initialize the AffirmCheckout object with the item(s), shipping details, and total price
AffirmCheckout *checkout = [AffirmCheckout checkoutWithItems:@[item] shipping:shipping totalAmount:price];

// initialize an AffirmCheckoutViewController with the checkout object and present it
AffirmCheckoutViewController *checkoutVC = [AffirmCheckoutViewController startCheckout:checkout checkoutType:AffirmCheckoutTypeAutomatic useVCN:NO delegate:self];
[self presentViewController:checkoutVC animated:true completion:nil];
```

The flow ends once the user has successfully confirmed the checkout or vcn checkout, canceled the checkout, or encountered an error in the process. In each of these cases, Affirm will send a message to the AffirmCheckoutDelegate along with additional information about the result.

### Charge authorization

Once the checkout has been successfully confirmed by the user, the AffirmCheckoutDelegate object will receive a checkout token. This token should be forwarded to your server, which should then use the token to authorize a charge on the user's account. For more details about the server integration, see our [API documentation](https://docs.affirm.com/v2/api/charges/).

## Promotional Messaging

Affirm Promotional Messaging allows you to inform customers about the availability of installment financing. Promos consist of as-low-as (ALA) messaging, which appears directly in your app, and a modal, which is opened when the user clicks on the ALA.

To display promotional messaging, the SDK provides the `AffirmAsLowAsButton` class that encapsulates the `AffirmAsLowAs` functionality in a button that handles all states and only requires the developer to add to their view and configure to implement. The AffirmALAButton is implemented as follows:

```
AffirmAsLowAsButton *alaButton = [AffirmAsLowAsButton createButtonWithPromoID:@"promo_id" presentingViewController:self frame:frame];
[self.view addSubview:alaButton];
[alaButton configureWithAmount:amount affirmLogoType:AffirmLogoTypeName affirmColor:AffirmColorTypeBlue maxFontSize:18 callback:^(BOOL alaEnabled, NSError *error) {
    //alaEnabled specifies whether ALA text or a default message is being displayed
}];
```

Tapping on the ALA button automatically opens a modal in an `SFSafariViewController` with more information, including (if you have it configured) a button that prompts the user to prequalify for Affirm financing.

**[Note: this integration is deprecated as of SDK version 4.0.13.]** To display the AffirmPromoModal outside of tapping on the AffirmALAButton, you may initialize and display an instance of the promo modal VC as follows
```
AffirmPromoModalViewController *promoVC = [AffirmPromoModalViewController promoModalControllerWithModalId:@"promo_id" amount:amount];
[self presentViewController:promoVC animated:YES completion:nil];
```
Example
=======

A demo app that integrates Affirm is included in the repo. To run it, run `pod install` and then open `AffirmSDKDemo.xcworkspace` in Xcode.
