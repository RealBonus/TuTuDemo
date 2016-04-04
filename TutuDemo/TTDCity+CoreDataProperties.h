//
//  TTDCity+CoreDataProperties.h
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TTDCity.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDCity (CoreDataProperties)

@property (nonatomic) int64_t cityId;
@property (nullable, nonatomic, retain) NSString *cityTitle;
@property (nullable, nonatomic, retain) NSString *countryTitle;
@property (nullable, nonatomic, retain) NSString *districtTitle;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, retain) NSString *regionTitle;
@property (nullable, nonatomic, retain) NSSet<TTDStation *> *stations;
@property (nullable, nonatomic, retain) TTDGroup *group;

@end

@interface TTDCity (CoreDataGeneratedAccessors)

- (void)addStationsObject:(TTDStation *)value;
- (void)removeStationsObject:(TTDStation *)value;
- (void)addStations:(NSSet<TTDStation *> *)values;
- (void)removeStations:(NSSet<TTDStation *> *)values;

@end

NS_ASSUME_NONNULL_END
