//
//  TTDRouteViewController.m
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDRouteViewController.h"
#import "TTDStationsViewController.h"
#import "TTDStationDetailsViewController.h"
#import "TTDRouteFactory.h"
#import "TTDBuyTicketsTableViewCell.h"
#import "TTDGroup.h"

static NSString * const kSegueIdentifiersSelectStation = @"selectStation";
static NSString * const kSegueIdentifiersShowStation = @"showStation";

static NSString * const kGroupTitleFrom = @"citiesFrom";
static NSString * const kGroupTitleTo = @"citiesTo";

typedef NS_ENUM(NSInteger, TTDRouteViewControllerSections) {
    TTDRouteViewControllerSectionFrom,
    TTDRouteViewControllerSectionTo,
    TTDRouteViewControllerSectionDate,
    TTDRouteViewControllerSectionOrder,
};


@interface TTDRouteViewController () <UITableViewDelegate, UITableViewDataSource, TTDStationsViewControllerDelegate>

@end


@implementation TTDRouteViewController {
    TTDRouteFactory *_factory;
    
    TTDStation *_stationFrom;
    TTDStation *_stationTo;
    
    // Ссылка на представленный контроллер. По ней потом определяем, какой контроллер нам вернул станцию.
    // __weak для того чтобы ссылки сами обнулялись при возврате к основному экрану выбора станций.
    __weak TTDStationsViewController *_controllerFrom;
    __weak TTDStationsViewController *_controllerTo;
    
    TTDBuyTicketsTableViewCell *_ordersCell;
}


#pragma mark - Lifecycle
- (void)awakeFromNib {
    self.title = NSLocalizedString(@"Route_window_title", @"Main window title");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _factory = [[TTDRouteFactory alloc] init];
    
    if ([_factory respondsToSelector:@selector(registerReusablesForTableView:)]) {
        [_factory registerReusablesForTableView:_tableView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *selectedRow = _tableView.indexPathForSelectedRow;
    if (selectedRow) {
        [_tableView deselectRowAtIndexPath:selectedRow animated:NO];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController conformsToProtocol:@protocol(TTDDataControllerUser)]) {
        [(id<TTDDataControllerUser>)segue.destinationViewController setDataController:_dataController];
    }
    
    if ([segue.identifier isEqualToString:kSegueIdentifiersSelectStation]) {
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        TTDStationsViewController *vc = (TTDStationsViewController*)segue.destinationViewController;
        vc.delegate = self;
        
        NSError *error = nil;
        
        switch (indexPath.section) {
            case TTDRouteViewControllerSectionFrom:
                _controllerFrom = vc;
                vc.group = [self p_fetchGroupWithTitle:kGroupTitleFrom error:&error];
                vc.title = NSLocalizedString(@"Departure_window_title", @"Departure station window title");
                break;
                
            case TTDRouteViewControllerSectionTo:
                _controllerTo = vc;
                vc.group = [self p_fetchGroupWithTitle:kGroupTitleTo error:&error];
                vc.title = NSLocalizedString(@"Arrival_window_title", @"Arrival station window title");
                break;
        }
        
        if (error) {
            NSLog(@"Something gone wild: %@", error);
        }
    }
    
    else if ([segue.identifier isEqualToString:kSegueIdentifiersShowStation]) {
        TTDStationDetailsViewController *vc = (TTDStationDetailsViewController*)segue.destinationViewController;
        vc.station = sender;
    }
}


#pragma mark - TTDStationsViewControllerDelegate
- (void)stationsViewController:(TTDStationsViewController *)controller didSelectStation:(TTDStation *)station {
    if (controller == nil)
        return;
    
    if (controller == _controllerTo) {
        _stationTo = station;
         [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:TTDRouteViewControllerSectionTo]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    else if (controller == _controllerFrom) {
        _stationFrom = station;
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:TTDRouteViewControllerSectionFrom]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [_ordersCell setEnabled:_stationFrom && _stationTo animated:YES];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TTDRouteViewControllerSectionDate:
            return 150;
            
        case TTDRouteViewControllerSectionFrom:
        case TTDRouteViewControllerSectionTo:
            return 70;
            
        default:
            return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TTDRouteViewControllerSectionFrom:
            [self performSegueWithIdentifier:kSegueIdentifiersSelectStation sender:indexPath];
            break;
            
        case TTDRouteViewControllerSectionTo:
            [self performSegueWithIdentifier:kSegueIdentifiersSelectStation sender:indexPath];
            break;
            
        case TTDRouteViewControllerSectionOrder: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Demo_alert_title", @"Tickets demo alert")
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }];
            break;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TTDRouteViewControllerSectionDate:
            return NO;
            
        case TTDRouteViewControllerSectionOrder:
            return _ordersCell.enabled;
            
        default:
            return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TTDRouteViewControllerSectionTo:
            _stationTo = nil;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:TTDRouteViewControllerSectionTo]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case TTDRouteViewControllerSectionFrom:
            _stationFrom = nil;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:TTDRouteViewControllerSectionFrom]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    
    [_ordersCell setEnabled:_stationTo && _stationFrom animated:YES];
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"Clear_button", @"Clear selected station button");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TTDRouteViewControllerSectionFrom:
            return _stationFrom != nil;
            
        case TTDRouteViewControllerSectionTo:
            return _stationTo != nil;
            
        default:
            return NO;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    TTDStation *sender;
    if (indexPath.section == TTDRouteViewControllerSectionFrom) {
        sender = _stationFrom;
    } else if (indexPath.section == TTDRouteViewControllerSectionTo) {
        sender = _stationTo;
    }
    
    [self performSegueWithIdentifier:kSegueIdentifiersShowStation sender:sender];
}

#pragma mark Sections
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case TTDRouteViewControllerSectionTo:
            return NSLocalizedString(@"Arrival_section", @"Main page arrival section title");
            
        case TTDRouteViewControllerSectionFrom:
            return NSLocalizedString(@"Departure_section", @"Main page departure section title");
            
        case TTDRouteViewControllerSectionDate:
            return NSLocalizedString(@"Departure_date_section", @"Main page departure date section title");
            
        case TTDRouteViewControllerSectionOrder:
            return NSLocalizedString(@"Tickets_section", @"Main page tickets section title");
            
        default:
            return @"";
    }
}

#pragma mark Cells
/**
 * Создание и подготовка ячеек вынесена в RouteFactory. Манипуляции с ячейками и логикой интерфейса, связанной с ними, непосредственно тут.
 */
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case TTDRouteViewControllerSectionFrom:
            cell = [_factory tableView:tableView cellForRowAtIndexPath:indexPath withObject:_stationFrom inSection:nil];
            [_factory configureCell:cell atIndexPath:indexPath withObject:_stationFrom inSection:nil];
            
            if (!_stationFrom) {
                cell.textLabel.text = NSLocalizedString(@"From_cell_placeholder", "Main page empty departure cell placeholder");
            }
            break;
            
        case TTDRouteViewControllerSectionTo:
            cell = [_factory tableView:tableView cellForRowAtIndexPath:indexPath withObject:_stationTo inSection:nil];
            [_factory configureCell:cell atIndexPath:indexPath withObject:_stationTo inSection:nil];
            
            if (!_stationTo) {
                cell.textLabel.text = NSLocalizedString(@"To_cell_placeholder", "Main page empty arrival cell placeholder");
            }
            break;
            
        case TTDRouteViewControllerSectionDate:
            cell = [_factory datePickerCellForTableView:tableView];
            break;
            
        case TTDRouteViewControllerSectionOrder:
            cell = [_factory orderCellForTableView:tableView];
            _ordersCell = (TTDBuyTicketsTableViewCell*)cell;
            [_ordersCell setEnabled:_stationTo && _stationFrom];
            break;
    }
    
    return cell;
}


#pragma mark - Utils
- (TTDGroup*)p_fetchGroupWithTitle:(NSString*)title error:(NSError**)error {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TTDGroup entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    request.fetchLimit = 1;
    
    TTDGroup *group = [[self.dataController.managedObjectContext executeFetchRequest:request error:error] firstObject];
    
    return group;
}


@end
