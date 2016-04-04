//
//  SearchUITests.m
//  TutuDemo
//
//  Created by Павел Анохов on 03.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SearchUITests : XCTestCase

@end

@implementation SearchUITests

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

- (void)testSearch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(1);
    [[app.tables.cells elementBoundByIndex:0] tap];
    
    XCUIElement *searchField = app.searchFields.element;
    XCTAssertTrue(searchField.exists);
    
    [searchField tap];
    [app.keys[@"R"] tap];
    [app.keys[@"s"] tap];
    [app.keys[@"c"] tap];
    [app.keys[@"h"] tap];
    
    XCUIElement *table = app.tables[@"Search results"];
    XCTAssertTrue(table.exists);
    XCTAssertEqual(table.cells.count, 1);
    [[table.cells elementBoundByIndex:0] tap];
    
    XCTAssertTrue(app.staticTexts[@"Route"].exists);
    XCUIElement *cell = app.tables.cells.staticTexts[@"Salzburg Parsch"];
    XCTAssertTrue(cell.exists);
}

- (void)testSearchTableAccessoryButton {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    sleep(1);
    [[app.tables.cells elementBoundByIndex:0] tap];
    
    sleep(1);
    XCUIElement *searchField = app.searchFields.element;
    [searchField tap];
    
    [app.keys[@"B"] tap];
    [app.keys[@"u"] tap];
    [app.keys[@"r"] tap];
    [app.keys[@"g"] tap];
    
    XCUIElementQuery *cells = app.tables[@"Search results"].cells;
    XCTAssertEqual(cells.count, 2);
    
    XCUIElement *button = [cells elementBoundByIndex:0].buttons.element;
    
    XCTAssertTrue(button.exists);
    [button tap];
    
    XCTAssertTrue(app.staticTexts[@"Info"].exists);
}

@end
