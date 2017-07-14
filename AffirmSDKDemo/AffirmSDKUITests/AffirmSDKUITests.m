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
    [self.app.buttons[@"Promo Modal"] tap];
    XCTAssert(!self.app.buttons[@"Promo Modal"].exists);
    
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:self.app.staticTexts[@"close"] handler:nil];
    [self waitForExpectationsWithTimeout:8 handler:nil];
    
    [self.app.staticTexts[@"close"] tap];
    
    [self expectationForPredicate:existsPredicate evaluatedWithObject:self.app.buttons[@"Promo Modal"] handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testCheckout {
    [self.app.buttons[@"Buy with Affirm"] tap];
    
    XCUIElement *affirmElement = self.app.staticTexts[@"Sign in"];
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:affirmElement handler:nil];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    XCTAssert(!self.app.buttons[@"Buy with Affirm"].exists);
    
    [self.app.links[@"Sign in"] tap];
    XCTAssert(self.app.staticTexts[@"Create an account"]);
    
    [self.app.textFields[@"Your mobile number"] tap];
    [self.app typeText:@"4085100442"];
    [self.app.buttons[@"Done"] tap];
    [self.app.buttons[@"SIGN IN"] tap];
    
    XCUIElement *enterPinField = self.app.textFields[@"Enter your pin"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:enterPinField handler:nil];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
    [enterPinField tap];
    [self.app typeText:@"1234"];
    [self.app.buttons[@"SIGN IN"] tap];
    
    [self expectationForPredicate:existsPredicate evaluatedWithObject:self.app.buttons[@"$169.41 /mo for 3 months"] handler:nil];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];
    XCTAssert(!self.app.buttons[@"SIGN IN"].exists);
    
    XCTAssert(self.app.buttons[@"$169.41 /mo for 3 months"].exists);
    [self.app.buttons[@"$169.41 /mo for 3 months"] tap];
    [self.app.buttons[@"CONTINUE"] tap];
    
    XCUIElement *confirmLoanButton = self.app.buttons[@"CONFIRM LOAN"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:confirmLoanButton handler:nil];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    XCUIElement *agreementText = self.app.staticTexts[@"I have reviewed and agree to the"];
    [agreementText tap];
    
    [self expectationForPredicate:existsPredicate evaluatedWithObject:self.app.staticTexts[@"Truth in Lending Disclosure"] handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    XCTAssert(self.app.buttons[@"Close"].exists);
    [self.app.buttons[@"Close"] tap];
    
    XCUIElement *webView = self.app.webViews.element;
    XCUICoordinate *normalizedCoord = [webView coordinateWithNormalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate *coord = [normalizedCoord coordinateWithOffset:CGVectorMake(15, agreementText.frame.origin.y)];
    [coord tap];
    
    [self.app.staticTexts[@"No, not now"] tap];
    [confirmLoanButton tap];
    
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"exists == 0"] evaluatedWithObject:self.app.webViews.element handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssert(self.app.alerts[@"Affirm Checkout"].staticTexts[@"Checkout completed"].exists);
    [self.app.alerts[@"Affirm Checkout"].buttons[@"OK"] tap];
    
    XCTAssert(self.app.buttons[@"Buy with Affirm"].exists);
}

- (void)testCheckoutFailure {
    [self.app.buttons[@"Failed Checkout"] tap];
    
    XCUIElement *errorText = self.app.staticTexts[@"Checkout Error"];
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    [self expectationForPredicate:existsPredicate evaluatedWithObject:errorText handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
    XCTAssert(self.app.buttons[@"RETURN TO MERCHANT"]);
    [self.app.buttons[@"RETURN TO MERCHANT"] tap];
    
    XCTAssert(self.app.buttons[@"Buy with Affirm"].exists);
}

@end
