//
//  TTDStationsFactory.m
//  TutuDemo
//
//  Created by Павел Анохов on 01.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TTDStationsFactory.h"
#import "TTDStation.h"
#import "TTDCity.h"

static NSString * const kCellIdentifiersStationCell = @"cell";

@implementation TTDStationsFactory {
    NSMutableDictionary *_fetchedCities;
}

- (instancetype)init {
    if (self = [super init]) {
        _fetchedCities = [NSMutableDictionary new];
    }
    
    return self;
}

#pragma mark Cells
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(nullable id)object inSection:(nullable NSString *)sectionName {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiersStationCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifiersStationCell];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath withObject:(nullable id)object inSection:(nullable NSString *)sectionName {
    TTDStation *station = (TTDStation*)object;
    
    if (station) {
        cell.textLabel.text = station.stationTitle;
        cell.detailTextLabel.text = station.districtTitle;
    }
}

#pragma mark Sections
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(nullable NSString *)sectionName {
    TTDCity *city = [self p_cityById:sectionName];
    
    if (city) {
        return [NSString stringWithFormat:@"%@, %@", city.cityTitle, city.countryTitle];
    }
    
    return sectionName;
}


#pragma mark - Utils
/**
 * Полученные секции кешируются в коллекции _fetchedCities
 */
- (TTDCity*)p_cityById:(NSString*)cityId {
    TTDCity *city = _fetchedCities[cityId];
    if (city) {
        return city;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TTDCity entityName]];
    request.fetchLimit = 1;
    request.predicate = [NSPredicate predicateWithFormat:@"cityId == %d", [cityId longLongValue]];
    
    city = [[self.dataController.managedObjectContext executeFetchRequest:request error:nil] firstObject];
    if (city) {
        // Если город не найден и передадим nil как ключ - программа испортится.
        [_fetchedCities setObject:city forKey:cityId];
    }
    
    return city;
}


@end
