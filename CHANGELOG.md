# Affirm iOS SDK Changelog
All notable changes to the SDK will be documented in this file.

## Version 4.0.4 (August 1, 2017)
- Minor internal updates to checkout and error modal
- Fixed tracker domain

## Version 4.0.3 (July 17, 2017)
- Minor internal updates
- Fixed unit tests

## Version 4.0.2 (July 14, 2017)
- Minor fixes to logger
- Added Travis config
- Minor updates to SDK demo

## Version 4.0.1 (July 12, 2017)
- Added Carthage support for SDK installation
- UI Tests on SDK demo

## Version 4.0.0 (July 10, 2017)
### Added
- Calls to start the checkout process now require passing an ```AffirmCheckoutType``` (either Automatic or Manual) to specify whether the SDK should display a loading spinner and handle error notifications or that the developer will manually handle these states. The call to start the checkout process is now
``` 
[AffirmCheckoutViewController startCheckout:checkout checkoutType:AffirmCheckoutType delegate:self]; 
```
- Added AffirmAsLowAsButton that encapsulates the AffirmAsLowAs functionality in a button that handles all states and only requires the developer to add to their view and configure to implement. Tapping on the button automatically opens the appropriate promo modal
- Added AffirmErrorModal that displays error notifications in the checkout flow if the Automatic checkout type is selected

### Changed
- Developers no longer need to configure AffirmAsLowAs text onto their label manually. The ALA functionality has been wrapped into a custom AffirmAsLowAsButton that handles all states and can be implemented as follows
```
AffirmAsLowAsButton *alaButton = [AffirmAsLowAsButton createButtonWithPromoID:@"promo_id" presentingViewController:self frame:frame];
[self.view addSubview:alaButton];
[alaButton configureWithAmount:amount affirmLogoType:AffirmLogoTypeName 		affirmColor:AffirmColorTypeBlue maxFontSize:18 callback:^(BOOL alaEnabled, NSError *error) {
//alaEnabled specifies whether ALA text or a default message is being displayed
}];
```
- Tapping on the ALA button automatically opens a product/site modal depending on whether ALA is enabled on the button
- The AffirmProductModal and AffirmSiteModal classes have now been merged into the AffirmPromoModal class. This modal can still be created and shown manually outside of tapping on the AffirmALAButton as follows
```
AffirmPromoModalViewController *promoVC = [AffirmPromoModalViewController promoModalControllerWithModalId:@"promo_id" amount:amount];
[self presentViewController:promoVC animated:YES completion:nil];
```
- AffirmAsLowAs has been broken into its own class and has been refactored to use a new endpoint internally
- The SDK now uses WKWebView internally to display all web content
- Fixed bug where the checkout VC would not close after the second open

## Version 3.0.0 (June 20, 2017)
### Added
- Delegate method that notifies when checkout ready to present
- Developer environment enums that must be specified when intializing a configuration
- Activity indicator that is automatically added/dismissed to denote loading state when presenting checkout or modal VCs
- Alternate checkout flow where the checkout VC is presented only when the checkoutReadyToPresent delegate method is fired. Helps avoid weird behavior where checkout VC pops up and immediately dismisses from screen in the case where checkout creation fails
- Descriptive error messages passed to an error's localizedDescription property

### Changed
- AffirmConfiguration now only needs to be set once with a preset developer environment. As a result, all SDK methods no longer require passing a configuration object. Current implementation is as follows:
```
    AffirmConfiguration *config = [AffirmConfiguration configurationWithPublicAPIKey:@"YOUR_API_KEY" environment:AffirmEnvironmentSandbox];
    [AffirmConfiguration setSharedConfiguration:config];
```
- AffirmAsLowAs now returns the asLowAs text and an appropriately scaled logo image instead of modifying the attributed text on a passed label. 
A helper method ```appendLogo:(UIImage *)logo toText:(NSString *)text``` has been provided to generate an attributed string that inserts the logo in the asLowAs text so it can be set to your label.
- AffirmContact and AffirmAddress classes have been merged into the AffirmShippingDetail class
- Method that starts checkout process has been renamed to ```[AffirmCheckoutViewController startCheckout:checkout withDelegate:self]```
- AffirmItem object no longer requires passing an imageURL parameter
- AffirmDisplayType enum in the AffirmAsLowAs class has been renamed to AffirmLogoType
