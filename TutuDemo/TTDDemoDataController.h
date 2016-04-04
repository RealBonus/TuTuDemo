//
//  TTDDemoDataController.h
//  ProsAndConsMobile
//
//  Created by Павел Анохов on 22.01.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TTDDataController.h"

@interface TTDDemoDataController : NSObject <TTDDataController>

#pragma mark App paths
@property (nonatomic, copy, readonly) NSURL *storeUrl;
@property (nonatomic, copy, readonly) NSURL *modelUrl;

#pragma mark CoreData Stack
@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark CoreData
/** Opens SQL store.
 @returns YES if no error occured, otherwise NO. */
- (BOOL)openStore:(NSURL*)storeUrl withModel:(NSURL*)modelUrl error:(NSError**)error;

/** Creates InMemory store.
 @returns YES if no errors occured, otherwise NO. */
- (BOOL)createInMemoryStoreWithModel:(NSURL*)modelUrl error:(NSError**)error;

/** Reset and load data from source asynchronously. */
- (void)loadDataFrom:(NSString*)source;

- (BOOL)saveContext;

@end