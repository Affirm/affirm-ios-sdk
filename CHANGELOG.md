# Affirm iOS SDK Changelog
All notable changes to the SDK will be documented in this file.

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
