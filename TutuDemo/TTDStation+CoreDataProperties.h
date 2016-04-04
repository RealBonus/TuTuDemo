//
//  TTDStation+CoreDataProperties.h
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TTDStation.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDStation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cityTitle;
@property (nullable, nonatomic, retain) NSString *countryTitle;
@property (nullable, nonatomic, retain) NSString *districtTitle;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, retain) NSString *regionTitle;
@property (nonatomic) int64_t stationId;
@property (nullable, nonatomic, retain) NSString *stationTitle;
@property (nonatomic) int64_t cityId;
@property (nullable, nonatomic, retain) TTDCity *city;

@end

NS_ASSUME_NONNULL_END
