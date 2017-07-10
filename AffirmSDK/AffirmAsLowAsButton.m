//
//  AffirmAsLowAsButton.m
//  AffirmSDK
//
//  Copyright © 2017 Affirm. All rights reserved.
//

#import "AffirmAsLowAsButton.h"
#import "AffirmPromoModalViewController.h"

@interface AffirmAsLowAsButton()

@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSString *promoID;

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
    self.amount = [amount copy];
    
    [AffirmAsLowAs getAffirmAsLowAsForAmount:amount promoId:self.promoID affirmLogoType:affirmLogoType affirmColor:affirmColor callback:^(NSString *asLowAsText, UIImage *logo, NSError *error, BOOL success) {
        [self setAttributedTitle:[AffirmAsLowAs appendLogo:logo toText:asLowAsText font:maxFontSize logoType:affirmLogoType] forState:UIControlStateNormal];
        [self layoutIfNeeded];
        callback(success, error);
    }];
}

- (void)_showALAModal {
    AffirmPromoModalViewController *promoModal = [AffirmPromoModalViewController promoModalControllerWithModalId:self.promoID amount:self.amount];
    [self.presentingViewController presentViewController:promoModal animated:true completion:nil];
}

@end
