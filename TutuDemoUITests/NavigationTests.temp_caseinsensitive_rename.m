//
//  TutuDemoUITests.m
//  TutuDemoUITests
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"

@interface Navigationtests : XCTestCase

@end

@implementation Navigationtests

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    app.launchArguments = @[@"inMemoryStore"];
    
    [app launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSelectDepartureStation {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(1);
    
    [[app.tables.cells elementBoundByIndex:0] tap];
    XCUIElement *stationCell = app.tables.cells.staticTexts[@"Bavaria - 2, Edbergstarsse 200 A"];
    [stationCell tap];
    
    XCUIElement *selectedStation = [app.tables.cells elementBoundByIndex:0].staticTexts[@"Bavaria - 2, Edbergstarsse 200 A"];
    XCTAssertTrue(selectedStation.exists);
}

- (void)testSelectArrivalStation {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(1);
    
    [[app.tables.cells elementBoundByIndex:1] tap];
    XCUIElement *stationCell = app.tables.cells.staticTexts[@"International Zalzburg, Edbergstarsse 200 A"];
    [stationCell tap];
    
    XCUIElement *selectedStation = [app.tables.cells elementBoundByIndex:1].staticTexts[@"International Zalzburg, Edbergstarsse 200 A"];
    XCTAssertTrue(selectedStation.exists);
}



@end
