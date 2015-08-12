Affirm iOS SDK
==============

The Affirm iOS SDK allows you accept Affirm payments in your own app.


Installation
============

[CocoaPods](https://cocoapods.org/) is the preferred method for installing the Affirm SDK. If you are using CocoaPods, you can set up Affirm by simply adding the following line to your Podfile:

```ruby
pod 'AffirmSDK'
```

Alternatively, if you do not want to use CocoaPods, you may clone our [GitHub repository](https://github.com/Affirm/affirm-ios-sdk) and simply drag and drop the `AffirmSDK.framework` folder into your XCode project.


Usage Overview
==============

An Affirm integration consists of two components: checkout creation, and charge authorization.

### Checkout creation

Checkout creation is the process in which a customer uses Affirm to pay for a purchase in your store. This process is governed by the AffirmCheckoutViewController object, which requires three parameters:

1. An AffirmCheckoutDelegate object which receives messages when the checkout creation process has succeeded or failed
2. An AffirmConfiguration object which stores merchant-specific configuration settings
3. An AffirmCheckout object which describes the purchase itself

Once the AffirmCheckoutViewController has been constructed from the parameters above, you may present it as with any other view controller. This initiates the flow which guides the user through the Affirm checkout process.

The flow ends once the user has successfully confirmed the checkout, canceled the checkout, or encountered an error in the process. In each of these cases, Affirm will send a message to the AffirmCheckoutDelegate along with additional information about the result.

### Charge authorization

Once the checkout has been successfully confirmed by the user, the AffirmCheckoutDelegate object will receive a checkout token. This token should be forwarded to your server, which should then use the token to authorize a charge on the user's account. For more details about the server integration, see our [API documentation](https://docs.affirm.com/v2/api/charges/).


Example
=======

The `AffirmSDKDemo` project in our [GitHub repository](https://github.com/Affirm/affirm-ios-sdk) is a simple example of an iOS app which integrates Affirm. (CocoaPods is required for building the example app.)
