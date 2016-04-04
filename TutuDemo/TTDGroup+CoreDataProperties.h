//
//  TTDGroup+CoreDataProperties.h
//  TutuDemo
//
//  Created by Павел Анохов on 03.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TTDGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDGroup (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nonatomic) int64_t version;
@property (nullable, nonatomic, retain) NSSet<TTDCity *> *cities;
@property (nullable, nonatomic, retain) TTDRoot *root;

@end

@interface TTDGroup (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(TTDCity *)value;
- (void)removeCitiesObject:(TTDCity *)value;
- (void)addCities:(NSSet<TTDCity *> *)values;
- (void)removeCities:(NSSet<TTDCity *> *)values;

@end

NS_ASSUME_NONNULL_END
