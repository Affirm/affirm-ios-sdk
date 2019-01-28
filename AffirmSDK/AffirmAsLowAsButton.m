//
//  AffirmAsLowAsButton.m
//  AffirmSDK
//
//  Copyright © 2017 Affirm. All rights reserved.
//

@import SafariServices;

#import "AffirmAsLowAsButton.h"
#import "AffirmPromoModalViewController.h"
#import "AffirmConfiguration+Protected.h"
#import "AffirmUtils.h"

@interface AffirmAsLowAsButton()

@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, assign) BOOL showPrequal;
@end

@implementation AffirmAsLowAsButton

+ (instancetype)createButtonWithPromoID:(NSString *)promoID presentingViewController:(id)presentingViewController frame:(CGRect)frame {
    return [[self alloc] initWithPromoID:promoID presentingViewController:presentingViewController frame:frame];
}

- (instancetype)initWithPromoID:(NSString *)promoID presentingViewController:(id)presentingViewController frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.promoID = [promoID copy];
        self.presentingViewController = presentingViewController;
        
        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self addTarget:self action:@selector(_showALAModal) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)configureWithAmount:(NSDecimalNumber *)amount
             affirmLogoType:(AffirmLogoType)affirmLogoType
                affirmColor:(AffirmColorType)affirmColor
                maxFontSize:(CGFloat)maxFontSize
                   callback:(void(^)(BOOL alaEnabled, NSError *error))callback {
    if (amount && ![[NSDecimalNumber notANumber] isEqualToNumber:amount]) {
        self.amount = [NSDecimalNumber decimalNumberWithDecimal:[[AffirmNumberUtils decimalDollarsToIntegerCents:amount] decimalValue]];
    } else {
        self.amount = nil;
    }

    [AffirmAsLowAs getAffirmAsLowAsForAmount:self.amount promoId:self.promoID affirmLogoType:affirmLogoType affirmColor:affirmColor callback:^(NSString *ala, UIImage *logo, BOOL showPrequal, NSError *error, BOOL success) {
        [self setAttributedTitle:[AffirmAsLowAs appendLogo:logo toText:ala font:maxFontSize logoType:affirmLogoType] forState:UIControlStateNormal];
        [self setAccessibilityLabel:ala];
        [self layoutIfNeeded];
        self.showPrequal = showPrequal;
        callback(success, error);
    }];
}

- (void)_showALAModal {
    if (self.showPrequal) {
        NSString *prequalURL = [AffirmConfiguration sharedConfiguration].affirmPrequalURL;
        NSString *url = [NSString stringWithFormat:@"%@?public_api_key=%@&unit_price=%@&promo_external_id=%@&isSDK=true&use_promo=True", prequalURL, [AffirmConfiguration sharedConfiguration].publicAPIKey, self.amount, self.promoID];
        SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        [self.presentingViewController presentViewController:vc animated:true completion:nil];
    } else {
        AffirmPromoModalViewController *promoModal = [AffirmPromoModalViewController promoModalControllerWithModalId:self.promoID amount:self.amount];
        [self.presentingViewController presentViewController:promoModal animated:true completion:nil];
    }
}

@end
