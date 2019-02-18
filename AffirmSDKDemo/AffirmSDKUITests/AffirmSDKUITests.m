//
//  AffirmSDKUITests.m
//  AffirmSDKUITests
//
//  Created by Sachin Kesiraju on 7/12/17.
//  Copyright © 2017 Affirm. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AffirmSDKUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation AffirmSDKUITests

- (void)setUp {
    [super setUp];
    
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPromoModal {
    [self.app.buttons[@"As low as $44/month at 10% APR with Affirm"] tap];
    
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:self.app.staticTexts[@"Make easy monthly payments over 3, 6, or 12 months"] handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    [self.app.buttons[@"Done"] tap];
    
    [self expectationForPredicate:existsPredicate evaluatedWithObject:self.app.buttons[@"As low as $44/month at 10% APR with Affirm"] handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)X_testAsLowAsButton {
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    XCUIElement *alaButton = self.app.buttons[@"As low as $44/month at 10% APR with Affirm"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:alaButton handler:nil];
    [self waitForExpectationsWithTimeout:4 handler:nil];

    [self.app.textFields[@"price field"] tap];
    [self.app typeText:@"40"];
    [self.app.buttons[@"Done"] tap];

    XCUIElement *updatedALAButton = self.app.buttons[@"Buy in monthly payments with Affirm"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:updatedALAButton handler:nil];
    [self waitForExpectationsWithTimeout:2 handler:nil];
    [updatedALAButton tap];

    [self expectationForPredicate:existsPredicate evaluatedWithObject:self.app.staticTexts[@"Make easy monthly payments over 3, 6, or 12 months"] handler:nil];
    [self waitForExpectationsWithTimeout:8 handler:nil];

    XCTAssertTrue(self.app.staticTexts[@"Rates from 10–30% APR."].exists);

    [self.app.staticTexts[@"close"] tap];

    [self.app.textFields[@"price field"] tap];
    [self.app typeText:@"75"];
    [self.app.buttons[@"Done"] tap];

    updatedALAButton = self.app.buttons[@"As low as $13/month at 10% APR with Affirm"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:updatedALAButton handler:nil];
    [self waitForExpectationsWithTimeout:4 handler:nil];

    [updatedALAButton tap];

    [self expectationForPredicate:existsPredicate evaluatedWithObject:self.app.staticTexts[@"Make easy monthly payments over 3, 6, or 12 months"] handler:nil];
    [self waitForExpectationsWithTimeout:4 handler:nil];

    XCTAssertFalse(self.app.staticTexts[@"Rates from 10–30% APR."].exists);
    NSPredicate *pricingPrediacte = [NSPredicate predicateWithFormat:@"label CONTAINS 'based on a purchase price of $75.00 at 10% APR for 6 months.'"];
    XCTAssertTrue([self.app.staticTexts elementMatchingPredicate:pricingPrediacte].exists);

    [self.app.staticTexts[@"close"] tap];

    [self expectationForPredicate:existsPredicate evaluatedWithObject:updatedALAButton handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testCheckout {
    [self.app.buttons[@"Buy with Affirm"] tap];
    
    XCUIElement *affirmElement = self.app.textFields[@"Your mobile number"];
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:affirmElement handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    [affirmElement tap];
    [self.app typeText:@"3105551001"];
    [self.app.buttons[@"Done"] tap];
    [self.app.buttons[@"Continue"] tap];
    
    XCUIElement *enterPinField = self.app.textFields[@"0000"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:enterPinField handler:nil];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
    [enterPinField tap];
    [self.app typeText:@"1234"];
    
    XCUIElement *loanButtonElement = [self.app.buttons elementMatchingPredicate:[NSPredicate predicateWithFormat:@"label BEGINSWITH '$169.39 per month'"]];
    [self expectationForPredicate:existsPredicate
              evaluatedWithObject:loanButtonElement
                          handler:nil];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
    
    XCTAssert(loanButtonElement.exists);
    [loanButtonElement tap];
    
    [self.app.buttons[@"Continue"] tap];
    [self.app.buttons[@"No, not now"] tap];
    
    XCUIElement *agreementText = self.app.staticTexts[@"I have reviewed and agree to the"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:agreementText handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    [agreementText tap];
    
    [self.app.staticTexts[@"Please review the following information and confirm your loan."] swipeUp];
    
    XCUIElement *confirmLoanButton = self.app.buttons[@"Confirm loan"];
    XCTAssert(confirmLoanButton.exists);
    [confirmLoanButton tap];
    
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"exists == 0"] evaluatedWithObject:self.app.webViews.element handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssert(self.app.alerts[@"Affirm Checkout"].staticTexts[@"Checkout completed"].exists);
    [self.app.alerts[@"Affirm Checkout"].buttons[@"OK"] tap];
    
    XCTAssert(self.app.buttons[@"Buy with Affirm"].exists);
    
}

- (void)testVCNCheckout {
    [self.app.buttons[@"VCN Checkout"] tap];
    
    XCUIElement *affirmElement = self.app.textFields[@"Your mobile number"];
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:affirmElement handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    [affirmElement tap];
    [self.app typeText:@"3105551001"];
    [self.app.buttons[@"Done"] tap];
    [self.app.buttons[@"Continue"] tap];
    
    XCUIElement *enterPinField = self.app.textFields[@"0000"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:enterPinField handler:nil];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
    [enterPinField tap];
    [self.app typeText:@"1234"];
    
    [self expectationForPredicate:existsPredicate evaluatedWithObject:[self.app.buttons elementBoundByIndex:2] handler:nil];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
    
    XCTAssert([self.app.buttons elementBoundByIndex:2]);
    [[self.app.buttons elementBoundByIndex:2] tap];
    
    [self.app.buttons[@"Continue"] tap];
    [self.app.buttons[@"No, not now"] tap];
    
    XCUIElement *agreementText = self.app.staticTexts[@"I have reviewed and agree to the"];
    [agreementText tap];
    
    [self.app.staticTexts[@"Please review the following information and confirm your loan."] swipeUp];
    
    XCUIElement *confirmLoanButton = self.app.buttons[@"Confirm loan"];
    XCTAssert(confirmLoanButton.exists);
    [confirmLoanButton tap];
    
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"exists == 0"] evaluatedWithObject:self.app.webViews.element handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssert(self.app.alerts[@"Affirm Checkout"].staticTexts[@"Checkout completed"].exists);
    [self.app.alerts[@"Affirm Checkout"].buttons[@"OK"] tap];
    
    XCTAssert(self.app.buttons[@"VCN Checkout"].exists);
}

- (void)testCheckoutFailure {
    [self.app.buttons[@"Failed Checkout"] tap];
    
    XCUIElement *errorText = self.app.staticTexts[@"Checkout Error"];
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:errorText handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssert(self.app.buttons[@"Return to merchant"]);
    [self.app.buttons[@"Return to merchant"] tap];
    
    XCTAssert(self.app.buttons[@"Buy with Affirm"].exists);
}

@end
