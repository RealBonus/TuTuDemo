//
//  TutuDemoTests.m
//  TutuDemoTests
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "TTDDemoDataController.h"
#import "AppDelegate.h"

#import "TTDRoot.h"
#import "TTDGroup.h"
#import "TTDCity.h"
#import "TTDStation.h"

@interface DataControllerTests : XCTestCase

@end

@implementation DataControllerTests {
    TTDDemoDataController *_controller;
}

- (void)setUp {
    [super setUp];
    _controller = [[TTDDemoDataController alloc] init];
    NSError *error = nil;
    [_controller createInMemoryStoreWithModel:[AppDelegate modelURL] error:&error];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDataControllerLoadingAndParsing {
    NSString *testPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test1" ofType:@"json"];
    [_controller loadDataFrom:testPath];
    
    NSFetchRequest *requestRoot = [NSFetchRequest fetchRequestWithEntityName:[TTDRoot entityName]];
    NSFetchRequest *requestGroup = [NSFetchRequest fetchRequestWithEntityName:[TTDGroup entityName]];
    NSFetchRequest *requestCity = [NSFetchRequest fetchRequestWithEntityName:[TTDCity entityName]];
    NSFetchRequest *requestStation = [NSFetchRequest fetchRequestWithEntityName:[TTDStation entityName]];
    
    NSArray *roots = [_controller.managedObjectContext executeFetchRequest:requestRoot error:nil];
    NSArray *groups = [_controller.managedObjectContext executeFetchRequest:requestGroup error:nil];
    NSArray *cities = [_controller.managedObjectContext executeFetchRequest:requestCity error:nil];
    NSArray *stations = [_controller.managedObjectContext executeFetchRequest:requestStation error:nil];
    
    XCTAssertEqual(roots.count, 1);
    XCTAssertEqual(groups.count, 2);
    XCTAssertEqual(cities.count, 2);
    XCTAssertEqual(stations.count, 2);
    
    for (TTDGroup *group in groups) {
        XCTAssertEqual(group.root, roots[0]);
        XCTAssertEqual(group.cities.count, 1);
        
        TTDCity *city = [group.cities anyObject];
        TTDStation *station = [city.stations anyObject];
        
        NSEntityDescription *cityDescription = [NSEntityDescription entityForName:[TTDCity entityName]
                                                           inManagedObjectContext:_controller.managedObjectContext];
        TTDCity *citySample = [[TTDCity alloc] initWithEntity:cityDescription
                           insertIntoManagedObjectContext:nil];
        
        NSEntityDescription *stationDescription = [NSEntityDescription entityForName:[TTDStation entityName]
                                                              inManagedObjectContext:_controller.managedObjectContext];
        TTDStation *stationSample = [[TTDStation alloc] initWithEntity:stationDescription
                                        insertIntoManagedObjectContext:nil];
        
        if ([group.title isEqualToString:@"citiesFrom"]) {
            citySample.countryTitle = @"Австрия";
            citySample.longitude = 22;
            citySample.latitude = 33;
            citySample.districtTitle = @"Район Вены";
            citySample.cityId = 2352;
            citySample.cityTitle = @"Вена";
            citySample.regionTitle = @"Регион Вены";
            
            stationSample.countryTitle = @"Австрия";
            stationSample.longitude = 44;
            stationSample.latitude = 55;
            stationSample.districtTitle = @"Район Вены";
            stationSample.cityId = 2352;
            stationSample.cityTitle = @"Вена";
            stationSample.regionTitle = @"Регион Вены";
            stationSample.stationId = 10154;
            stationSample.stationTitle = @"Станция такая-то.";
        }
        else if ([group.title isEqualToString:@"citiesTo"]) {
            citySample.countryTitle = @"Германия";
            citySample.longitude = 11;
            citySample.latitude = 12;
            citySample.districtTitle = @"Баварские окрестности";
            citySample.cityId = 2355;
            citySample.cityTitle = @"Бавария";
            citySample.regionTitle = @"Регион Баварский";
            
            stationSample.countryTitle = @"Германия";
            stationSample.longitude = 13;
            stationSample.latitude = 14;
            stationSample.districtTitle = @"Баварские окрестности";
            stationSample.cityId = 2355;
            stationSample.cityTitle = @"Бавария";
            stationSample.regionTitle = @"Регион Баварский";
            stationSample.stationId = 10159;
            stationSample.stationTitle = @"Дер гуттен Станция";
        }
        else
            XCTFail(@"Unknown group: %@", group.title);
        
        XCTAssertTrue([self p_city:city isEqualToCity:citySample]);
        XCTAssertTrue([self p_station:station isEqualToStation:stationSample]);
    }
}

- (void)testDataControllerReloadingNewVersion {
    NSString *testPath1 = [[NSBundle bundleForClass:[self class]] pathForResource:@"test1" ofType:@"json"];
    [_controller loadDataFrom:testPath1];
    
    NSString *testPath2 = [[NSBundle bundleForClass:[self class]] pathForResource:@"test2" ofType:@"json"];
    [_controller loadDataFrom:testPath2];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TTDGroup entityName]];
    request.fetchLimit = 1;
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"citiesFrom"];
    TTDGroup *group = [[_controller.managedObjectContext executeFetchRequest:request error:nil] firstObject];
    XCTAssertEqual(group.root.version, 2);
    XCTAssertNotNil(group);
    XCTAssertEqual(group.cities.count, 1);
    TTDCity *city = group.cities.anyObject;
    XCTAssertTrue([city.countryTitle isEqualToString:@"Австро-Венгрия"]);
    XCTAssertEqual(city.stations.count, 1);
    XCTAssertTrue([city.stations.anyObject.countryTitle isEqualToString:@"Австро-Венгрия"]);
}



#pragma mark - Utils
- (BOOL)p_city:(TTDCity*)city isEqualToCity:(TTDCity*)other {
    double e = 0.000001;
    
    if (city.cityId != other.cityId) return NO;
    if (fabs(city.latitude - other.latitude) > e) return NO;
    if (fabs(city.longitude - other.longitude) > e) return NO;
    if (![city.cityTitle isEqualToString:other.cityTitle]) return NO;
    if (![city.countryTitle isEqualToString:other.countryTitle]) return NO;
    if (![city.regionTitle isEqualToString:other.regionTitle]) return NO;
    
    return YES;
}

- (BOOL)p_station:(TTDStation*)station isEqualToStation:(TTDStation*)other {
    double e = 0.000001;
    
    if (station.stationId != other.stationId) return NO;
    if (station.cityId != other.cityId) return NO;
    if (fabs(station.latitude - other.latitude) > e) return NO;
    if (fabs(station.longitude - other.longitude) > e) return NO;
    if (![station.cityTitle isEqualToString:other.cityTitle]) return NO;
    if (![station.countryTitle isEqualToString:other.countryTitle]) return NO;
    if (![station.districtTitle isEqualToString:other.districtTitle]) return NO;
    if (![station.regionTitle isEqualToString:other.regionTitle]) return NO;
    if (![station.stationTitle isEqualToString:other.stationTitle]) return NO;
    
    return YES;
}

@end
