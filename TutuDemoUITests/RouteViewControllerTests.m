//
//  RouteViewControllerTests.m
//  TutuDemo
//
//  Created by Павел Анохов on 03.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface RouteViewControllerTests : XCTestCase

@end

@implementation RouteViewControllerTests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    app.launchArguments = @[@"inMemoryStore", @"testJson"];
    
    [app launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBuyTicketsButtonEnabledStatus {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(1);
    
    XCUIElement *buyCell = [app.tables.cells elementBoundByIndex:3];
    
    // Go to From...
    [[app.tables.cells elementBoundByIndex:0] tap];
    // Select first
    [[app.tables.cells elementBoundByIndex:0] tap];
    
    // Try buy
    [buyCell tap];
    XCTAssertFalse(app.alerts.element.exists);
    
    // Go to Next...
    [[app.tables.cells elementBoundByIndex:1] tap];
    // Select First
    [[app.tables.cells elementBoundByIndex:0] tap];
    
    // Try buy
    [buyCell tap];
    XCTAssertTrue(app.alerts.element.exists);
    
    [app.alerts.element.buttons[@"Ok"] tap];
    
    // Remove From...
    XCUIElement *from = [app.tables.cells elementBoundByIndex:0];
    [from swipeLeft];
    [from.buttons[@"Clear"] tap];
    
    // Try buy
    [buyCell tap];
    XCTAssertFalse(app.alerts.element.exists);
    
    // Add From and remove To
    [[app.tables.cells elementBoundByIndex:0] tap];
    [[app.tables.cells elementBoundByIndex:0] tap];
    XCUIElement *to = [app.tables.cells elementBoundByIndex:1];
    [to swipeLeft];
    [to.buttons[@"Clear"] tap];
    
    // Try buy
    [buyCell tap];
    XCTAssertFalse(app.alerts.element.exists);
    
    // Add To and try again
    [[app.tables.cells elementBoundByIndex:1] tap];
    [[app.tables.cells elementBoundByIndex:0] tap];
    [buyCell tap];
    XCTAssertTrue(app.alerts.element.exists);
    
    [app.alerts.element.buttons[@"Ok"] tap];
}

@end
