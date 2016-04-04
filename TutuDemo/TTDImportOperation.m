//
//  TTDImportOperation.m
//  TutuDemo
//
//  Created by Павел Анохов on 04.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDImportOperation.h"
#import "TTDCity.h"
#import "TTDRoot.h"
#import "TTDGroup.h"
#import "TTDStation.h"

@implementation TTDImportOperation {
    NSManagedObjectContext *_context;
    NSString *_source;
}

- (instancetype)initWithContext:(NSManagedObjectContext *)context source:(NSString *)source {
    if (self = [super init]) {
        _context = context;
        _source = [source copy];
        _updateRate = 250;
    }
    
    return self;
}


- (void)main {
    [_context performBlockAndWait:^
    {
        [self import];
    }];
}


#pragma mark - Main
- (void)import
{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:_source options:0 error:&error];
    if (error) {
        NSLog(@"Error loading data from source: %@", error);
        return;
    }
    
    NSDictionary *rootRaw = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"Error reading json: %@", error);
        return;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TTDRoot entityName]];
    request.fetchLimit = 1;
    TTDRoot *root = [[_context executeFetchRequest:request error:nil] firstObject];
    long version = rootRaw[@"version"] ? [rootRaw[@"version"] longLongValue] : 0;
    
    // Проверяем версию полученных данных.
    // Если загруженных ранее данных нет, или данные новее загруженных - сбрасываем всё и загружаем новые.
    if (root) {
        if (root.version >= version) {
            return;
        }
        
        for (TTDGroup *group in root.groups) {
            [NSFetchedResultsController deleteCacheWithName:group.title];
        }
        
        [_context deleteObject:root];
        [_context save:nil];
    }

    // Парсим
    root = [NSEntityDescription insertNewObjectForEntityForName:[TTDRoot entityName] inManagedObjectContext:_context];
    
    NSArray<NSString*>* keys = @[@"citiesFrom", @"citiesTo"];
    for (NSString *key in keys) {
        NSDictionary *groupRaw = rootRaw[key];
        if (groupRaw) {
            if (self.isCancelled) {
                return;
            }
            
            TTDGroup *group = [self p_parseJsonGroup:groupRaw withContext:_context];
            group.title = key;
            [root addGroupsObject:group];
        }
    }
    
    root.version = version;
    [_context save:nil];
}


#pragma mark - Parsing
- (TTDGroup*)p_parseJsonGroup:(NSDictionary*)groupRaw withContext:(NSManagedObjectContext*)context {
    TTDGroup *group = [NSEntityDescription insertNewObjectForEntityForName:[TTDGroup entityName] inManagedObjectContext:context];
    
    int imported = 0;
    
    for (NSDictionary *cityRaw in groupRaw) {
        if (self.isCancelled)
            return group;
        
        TTDCity *city = [self p_parseJsonCity:cityRaw withContext:context];
        [group addCitiesObject:city];
        
        if (++imported > _updateRate) {
            imported = 0;
            [_context save:nil];
        }
    }
    
    return group;
}

- (TTDCity*)p_parseJsonCity:(NSDictionary*)cityRaw withContext:(NSManagedObjectContext*)context {
    TTDCity *city = [NSEntityDescription insertNewObjectForEntityForName:[TTDCity entityName] inManagedObjectContext:context];
    
    city.countryTitle = cityRaw[@"countryTitle"];
    city.districtTitle = cityRaw[@"districtTitle"];
    city.cityId = [cityRaw[@"cityId"] longLongValue];
    city.cityTitle = cityRaw[@"cityTitle"];
    city.regionTitle = cityRaw[@"regionTitle"];
    
    NSDictionary *cityPointRaw = cityRaw[@"point"];
    if (cityPointRaw) {
        city.longitude = [cityPointRaw[@"longitude"] doubleValue];
        city.latitude = [cityPointRaw[@"latitude"] doubleValue];
    }
    
    for (NSDictionary *stationRaw in cityRaw[@"stations"]) {
        if (self.isCancelled)
            return city;
        
        TTDStation *station = [self p_parseJsonStation:stationRaw withContext:context];
        [city addStationsObject:station];
    }
    
    return city;
}

- (TTDStation*)p_parseJsonStation:(NSDictionary*)stationRaw withContext:(NSManagedObjectContext*)context {
    TTDStation *station = [NSEntityDescription insertNewObjectForEntityForName:[TTDStation entityName] inManagedObjectContext:context];
    
    station.countryTitle = stationRaw[@"countryTitle"];
    station.districtTitle = stationRaw[@"districtTitle"];
    station.cityTitle = stationRaw[@"cityTitle"];
    station.regionTitle = stationRaw[@"regionTitle"];
    station.stationId = [stationRaw[@"stationId"] longLongValue];
    station.stationTitle = stationRaw[@"stationTitle"];
    station.cityId = [stationRaw[@"cityId"] longLongValue];
    
    NSDictionary *stationPointRaw = stationRaw[@"point"];
    if (stationPointRaw) {
        station.longitude = [stationPointRaw[@"longitude"] doubleValue];
        station.latitude = [stationPointRaw[@"latitude"] doubleValue];
    }
    
    return station;
}

@end
