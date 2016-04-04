//
//  TTDDemoDataController.m
//  ProsAndConsMobile
//
//  Created by Павел Анохов on 22.01.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDDemoDataController.h"

#import "TTDCity.h"
#import "TTDStation.h"
#import "TTDGroup.h"
#import "TTDRoot.h"

NSString *const kHBSSaveContextNotification = @"SaveContext";

@interface TTDDemoDataController()
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readwrite) NSManagedObjectContext* managedObjectContext;
@end


@implementation TTDDemoDataController {
    BOOL _inMemoryStore;
}

#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveContext) name:kHBSSaveContextNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - CoreData
- (BOOL)openStore:(NSURL *)storeUrl withModel:(NSURL *)modelUrl error:(NSError**)error {
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *innerError;
    BOOL success = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:storeUrl
                                                   options:@{ NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                                              NSInferMappingModelAutomaticallyOption: @(YES) }
                                                     error:&innerError];
    
    if (!success) {
        if (error) {
            *error = innerError;
        }
        return NO;
    }
    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    _managedObjectModel = managedObjectModel;
    _managedObjectContext = managedObjectContext;
    _persistentStoreCoordinator = persistentStoreCoordinator;
    
    _inMemoryStore = NO;
    return YES;
}

- (BOOL)createInMemoryStoreWithModel:(NSURL*)modelUrl error:(NSError *__autoreleasing *)error {
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *innerError;
    BOOL success = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&innerError];
    
    if (!success) {
        if (error) {
            *error = innerError;
        }
        return NO;
    }
    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    _managedObjectModel = managedObjectModel;
    _managedObjectContext = managedObjectContext;
    _persistentStoreCoordinator = persistentStoreCoordinator;
    
    _inMemoryStore = YES;
    return YES;
}


#pragma mark - Saving
- (BOOL)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext.hasChanges)
    {
        NSError *error = nil;
        [managedObjectContext save:&error];
        
        if(error) {
            NSLog(@"Error saving managed context %@", error);
            return NO;
        }
    }
    return YES;
}


#pragma mark - Background load data
- (void)loadDataFrom:(NSString*)source {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:source options:0 error:&error];
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
    TTDRoot *root = [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
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
        
        [_managedObjectContext deleteObject:root];
    }
    
    root = [NSEntityDescription insertNewObjectForEntityForName:[TTDRoot entityName] inManagedObjectContext:_managedObjectContext];
    root.version = version;
    
    NSArray<NSString*>* keys = @[@"citiesFrom", @"citiesTo"];
    for (NSString *key in keys) {
        NSDictionary *groupRaw = rootRaw[key];
        if (groupRaw) {
            TTDGroup *group = [self p_parseJsonGroup:groupRaw withContext:_managedObjectContext];
            group.title = key;
            [root addGroupsObject:group];
        }
    }
    
    [_managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error saving data: %@", error);
    }
}


#pragma mark - Parsing
- (TTDGroup*)p_parseJsonGroup:(NSDictionary*)groupRaw withContext:(NSManagedObjectContext*)context {
    TTDGroup *group = [NSEntityDescription insertNewObjectForEntityForName:[TTDGroup entityName] inManagedObjectContext:context];
    
    for (NSDictionary *cityRaw in groupRaw) {
        TTDCity *city = [self p_parseJsonCity:cityRaw withContext:context];
        [group addCitiesObject:city];
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


#pragma mark - Utils
- (NSString*)description {
    NSDictionary *description = nil;
    
    if (_inMemoryStore) {
        description = @{ @"Store type": @"InMemoryStore",
                         @"Has changes": _managedObjectContext.hasChanges ? @"Yes" : @"No"};
    } else {
        description = @{ @"Store type": @"SQL",
                         @"Has changes": _managedObjectContext.hasChanges ? @"Yes" : @"No",
                         @"StoreURL": _storeUrl,
                         @"ModelURL": _modelUrl };
    }
    
    return [NSString stringWithFormat:@"<%@: %p>, %@", [self class], self, description];
}

@end
