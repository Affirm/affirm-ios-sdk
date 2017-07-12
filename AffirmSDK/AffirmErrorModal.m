//
//  AffirmErrorModal.m
//  AffirmSDK
//
//  Created by Sachin Kesiraju on 6/28/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "AffirmErrorModal.h"
#import <CoreText/CoreText.h>

static const CGFloat ERROR_MODAL_WIDTH = 240;
static const CGFloat ERROR_MODAL_HEIGHT = 170;

@interface AffirmErrorModal ()

@property (nonatomic, strong) NSString *errorTitle;
@property (nonatomic, strong) NSString *errorDescription;

@property (nonatomic, strong) UIView *translucentBackgroundView;
@property (nonatomic, copy) AffirmErrorCloseBlock closeBlock;

@end

@implementation AffirmErrorModal

+ (instancetype)showErrorModalWithTitle:(NSString *)title description:(NSString *)errorDescription onView:(UIView *)baseView withCloseBlock:(AffirmErrorCloseBlock)closeBlock {
    return [[self alloc] initErrorWithTitle:title description:errorDescription onView:baseView withCloseBlock:closeBlock];
}

- (instancetype)initErrorWithTitle:(NSString *)title description:(NSString *)errorDescription onView:(UIView *)baseView withCloseBlock:(AffirmErrorCloseBlock)closeBlock {
    self = [super initWithFrame:CGRectMake(0, 0, ERROR_MODAL_WIDTH, ERROR_MODAL_HEIGHT)];
    if (self) {
        _errorTitle = [title copy];
        _errorDescription = [errorDescription copy];
        _closeBlock = closeBlock;
        [self _showErrorModalOnView:baseView];
    }
    return self;
}

- (void)_showErrorModalOnView:(UIView *)baseView {
    [self _setupErrorScreen];
    self.translucentBackgroundView = [[UIView alloc] initWithFrame:baseView.frame];
    self.translucentBackgroundView.backgroundColor = [UIColor blackColor];
    self.translucentBackgroundView.alpha = 0.3;
    [baseView addSubview:self.translucentBackgroundView];
    
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.center = baseView.center;
    [baseView addSubview:self];
    [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)_setupErrorScreen {
    CGFloat labelPadding = 6.0f;
    CGFloat currentY = 2 * labelPadding;
    [self _loadCustomFont];
    
    self.layer.cornerRadius = 7.0f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    UILabel *errorTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, currentY, 210, 40)];
    errorTitleLabel.numberOfLines = 2;
    errorTitleLabel.text = self.errorTitle;
    errorTitleLabel.textAlignment = NSTextAlignmentCenter;
    errorTitleLabel.textColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1];
    errorTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    errorTitleLabel.center = CGPointMake(self.center.x, errorTitleLabel.center.y);
    [errorTitleLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:errorTitleLabel];
    
    currentY += errorTitleLabel.frame.size.height + 4;
    
    UILabel *errorDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, currentY, 210, 65)];
    errorDescriptionLabel.numberOfLines = 0;
    errorDescriptionLabel.text = self.errorDescription;
    errorDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    errorDescriptionLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:14];
    errorDescriptionLabel.textColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:157/255.0 alpha:1];
    errorDescriptionLabel.center = CGPointMake(self.center.x, errorDescriptionLabel.center.y);
    [errorDescriptionLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:errorDescriptionLabel];
    
    currentY += errorDescriptionLabel.frame.size.height + labelPadding;
    
    UIButton *errorCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(labelPadding, currentY, 210, 30)];
    [errorCloseButton addTarget:self action:@selector(_closeErrorModal) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *closeButtonTitle = [[NSAttributedString alloc] initWithString:@"RETURN TO MERCHANT" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:10]}];
    [errorCloseButton setAttributedTitle:closeButtonTitle forState:UIControlStateNormal];
    [errorCloseButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:200/255.0 blue:229/255.0 alpha: 1.0]];
    errorCloseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    errorCloseButton.titleLabel.textColor = [UIColor whiteColor];
    errorCloseButton.layer.cornerRadius = 14.0f;
    errorCloseButton.layer.masksToBounds = YES;
    errorCloseButton.center = CGPointMake(self.center.x, errorCloseButton.center.y);
    [self addSubview:errorCloseButton];
}

- (void)_closeErrorModal {
    [UIView animateWithDuration:0.3 animations:^{
        self.translucentBackgroundView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (self.closeBlock) {
        self.closeBlock(self);
        self.closeBlock = nil;
    }
}

- (void)_loadCustomFont {
    NSBundle *sdkBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"AffirmSDK" ofType:@"bundle"]];
    NSString *fontPath = [sdkBundle pathForResource:@"Proxima Nova Light" ofType:@"ttf"];
    NSData *inData = [NSData dataWithContentsOfFile:fontPath];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}

@end
