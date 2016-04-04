//
//  TTDRoot+CoreDataProperties.h
//  TutuDemo
//
//  Created by Павел Анохов on 03.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TTDRoot.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDRoot (CoreDataProperties)

@property (nonatomic) int64_t version;
@property (nullable, nonatomic, retain) NSSet<TTDGroup *> *groups;

@end

@interface TTDRoot (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(TTDGroup *)value;
- (void)removeGroupsObject:(TTDGroup *)value;
- (void)addGroups:(NSSet<TTDGroup *> *)values;
- (void)removeGroups:(NSSet<TTDGroup *> *)values;

@end

NS_ASSUME_NONNULL_END
