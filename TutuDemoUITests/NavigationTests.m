//
//  TutuDemoUITests.m
//  TutuDemoUITests
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"

@interface NavigationTests : XCTestCase

@end

/*
 * Переодически xcode отправляет тапы слишком рано, из-за чего тесты валятся.
 * Особенно это заметно при тестах на устройстве.
 * Для обхода этих причуд мы просто добавляем задержку перед тапом.
 */
@implementation NavigationTests

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
    
    XCUIElement *stationCell = app.tables.cells.staticTexts[@"Salzburg Parsch"];
    
    [stationCell tap];
    
    XCUIElement *selectedStation = [app.tables.cells elementBoundByIndex:0].staticTexts[@"Salzburg Parsch"];
    XCTAssertTrue(selectedStation.exists);
}

- (void)testSelectArrivalStation {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(1);
    [[app.tables.cells elementBoundByIndex:1] tap];
    XCUIElement *stationCell = app.tables.cells.staticTexts[@"Bergen"];
    
    [stationCell tap];
    
    XCUIElement *selectedStation = [app.tables.cells elementBoundByIndex:1].staticTexts[@"Bergen"];
    XCTAssertTrue(selectedStation.exists);
}

- (void)testStationDetailsButton {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(1);
    [[app.tables.cells elementBoundByIndex:0] tap];
    
    XCUIElement *cell = [app.tables.cells elementBoundByIndex:0];
    XCUIElement *button = [cell.buttons elementBoundByIndex:0];
    
    XCTAssertTrue(button.exists);
    [button tap];
    
    XCTAssertTrue(app.staticTexts[@"Info"].exists);
}

@end
