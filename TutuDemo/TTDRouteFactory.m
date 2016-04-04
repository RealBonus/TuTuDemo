//
//  TTDRouteFactory.m
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDRouteFactory.h"
#import "TTDStationFullTableViewCell.h"
#import "TTDDatePickerTableViewCell.h"
#import "TTDStation.h"
#import "TTDBuyTicketsTableViewCell.h"

static NSString * const kCellIdentifiersStationCell = @"cell";
static NSString * const kCellIdentifiersStationCellEmpty = @"empty";
static NSString * const kCellIdentifiersDatePickerCell = @"date";
static NSString * const kCellIdentifiersOrderCell = @"order";

static NSString * const kNibNamesStationCellFull = @"TTDStationFullTableViewCell";
static NSString * const kNibNamesDatePickerCell = @"TTDDatePickerTableViewCell";

@implementation TTDRouteFactory

- (void)registerReusablesForTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:kNibNamesStationCellFull bundle:nil] forCellReuseIdentifier:kCellIdentifiersStationCell];
    [tableView registerNib:[UINib nibWithNibName:kNibNamesDatePickerCell bundle:nil] forCellReuseIdentifier:kCellIdentifiersDatePickerCell];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object inSection:(NSString *)sectionName {
    UITableViewCell *cell;
    
    if (object) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiersStationCell];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiersStationCellEmpty];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifiersStationCellEmpty];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object inSection:(NSString *)sectionName {
    TTDStation *station = (TTDStation*)object;
    if (station) {
        TTDStationFullTableViewCell *sCell = (TTDStationFullTableViewCell*)cell;
        sCell.titleLabel.text = station.stationTitle;
        sCell.districtLabel.text = station.districtTitle;
        sCell.cityLabel.text = [NSString stringWithFormat:@"%@, %@", station.cityTitle, station.countryTitle];
    }
}

- (UITableViewCell*)datePickerCellForTableView:(UITableView *)tableView {
    TTDDatePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiersDatePickerCell];
    cell.datePicker.minimumDate = [NSDate date];
    return cell;
}

- (UITableViewCell*)orderCellForTableView:(UITableView *)tableView {
    TTDBuyTicketsTableViewCell *cell = (TTDBuyTicketsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifiersOrderCell];
    if (!cell) {
        cell = [[TTDBuyTicketsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifiersOrderCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setEnabled:NO animated:NO];
    }
    
    cell.textLabel.text = NSLocalizedString(@"Buy_tickets_button", @"Main window, 'Buy tickets' button");
    
    return cell;
}

@end
