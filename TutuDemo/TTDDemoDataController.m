//
//  TTDDemoDataController.m
//  ProsAndConsMobile
//
//  Created by Павел Анохов on 22.01.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDDemoDataController.h"
#import "TTDImportOperation.h"
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
    NSOperationQueue *_queue;
}

#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveContext) name:kHBSSaveContextNotification object:nil];
        _queue = [[NSOperationQueue alloc] init];
        [self p_setupNotification];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_queue cancelAllOperations];
}

- (void)p_setupNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification* note) {
                                                      NSManagedObjectContext *moc = _managedObjectContext;
                                                      if (note.object != moc) {
                                                          [moc performBlock:^(){
                                                              [moc mergeChangesFromContextDidSaveNotification:note];
                                                          }];
                                                      }
                                                  }];
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
    [_queue cancelAllOperations];
    
    NSManagedObjectContext* privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    privateContext.persistentStoreCoordinator = self.persistentStoreCoordinator;

    TTDImportOperation *import = [[TTDImportOperation alloc] initWithContext:privateContext source:source];
    [_queue addOperation:import];
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
