//
//  TTDStationDetailsViewController.m
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDStationDetailsViewController.h"
#import "TTDStation.h"
#import "TTDMapTableViewCell.h"

static NSString * const kCellIdentifiersTitle = @"title";
static NSString * const kCellIdentifiersDetail = @"detail";
static NSString * const kCellIdentifiersMap = @"map";

typedef NS_ENUM(NSInteger, TTDStationRows) {
    TTDStationRowsMap,
    TTDStationRowsStationTitle,
    TTDStationRowsCountryTitle,
    TTDStationRowsRegionTitle,
    TTDStationRowsCityTitle,
    TTDStationRowsDistrictTitle,
};


@implementation TTDStationDetailsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Info_window_title", @"Station info window title");
}


#pragma mark - Getters and Setters
- (void)setStation:(TTDStation *)station {
    _station = station;
    
    if (_station) {
        [_tableView reloadData];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath.row == TTDStationRowsMap ? 300 : 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row == TTDStationRowsMap) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiersMap];
        [(TTDMapTableViewCell*)cell showAnnotationAtLatitude:_station.latitude andLongitude:_station.longitude
                                                   withTitle:_station.stationTitle andSubtitle:_station.cityTitle];
    }
    
    else if (indexPath.row == TTDStationRowsStationTitle) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiersTitle];
        cell.textLabel.text = _station ? _station.stationTitle : @"";
    }
    
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiersDetail];
        
        switch (indexPath.row) {
            case TTDStationRowsCountryTitle:
                cell.detailTextLabel.text = _station ? _station.countryTitle : @"";
                cell.textLabel.text = NSLocalizedString(@"Country_row_title", @"Station info Country row title");
                break;
                
            case TTDStationRowsCityTitle:
                cell.detailTextLabel.text = _station ? _station.cityTitle : @"";
                cell.textLabel.text = NSLocalizedString(@"City_row_title", @"Station info City row title");
                break;
                
            case TTDStationRowsDistrictTitle:
                cell.detailTextLabel.text = _station ? _station.districtTitle : @"";
                cell.textLabel.text = NSLocalizedString(@"District_row_title", @"Station info District row title");
                break;
                
            case TTDStationRowsRegionTitle:
                cell.detailTextLabel.text = _station ? _station.regionTitle : @"";
                cell.textLabel.text = NSLocalizedString(@"Region_row_title", @"Station info Region row title");
                break;
        }
    }
    
    
    return cell;
}

/** Remove empty cell separators */
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static UIView *footer;
    if (!footer) {
        footer = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return footer;
}


@end
