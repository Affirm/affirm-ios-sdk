//
//  AffirmErrorModal.h
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 6/28/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <UIKit/UIKit.h>

/// An AffirmErrorModal represents an error by displaying a alert modal on the screen.
@interface AffirmErrorModal : UIView

/// Completion handler that notifies when alert was triggered to close
typedef void (^AffirmErrorCloseBlock)(AffirmErrorModal *errorModal);

/// Creates and displays an error modal on the screen
/// @param title The title of the alert describing the type of error
/// @param errorDescription The description of the error to be displayed on the alert
/// @param baseView The view to display the alert on
/// @param closeBlock Completion block that calls when alert triggered to close
/// @return An AffirmErrorModal instance
+ (instancetype)showErrorModalWithTitle:(NSString *)title description:(NSString *)errorDescription onView:(UIView *)baseView withCloseBlock:(AffirmErrorCloseBlock)closeBlock;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
