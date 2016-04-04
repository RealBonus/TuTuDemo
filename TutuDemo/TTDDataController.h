//
//  TTDDataController.h
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol TTDDataController <NSObject>

- (NSManagedObjectContext*)managedObjectContext;
- (void)saveContext;

@end

/** 
 * Dependecy injection protocol.
 */
@protocol TTDDataControllerUser <NSObject>
@required
- (void)setDataController:(id<TTDDataController>)dataController;
@end


