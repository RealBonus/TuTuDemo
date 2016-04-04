//
//  TTDStationsViewController.m
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDStationsViewController.h"
#import "HBSFetchedTableController.h"
#import "TTDStationsFactory.h"
#import "TTDStationDetailsViewController.h"
#import "TTDStationsSearchResultViewController.h"
#import "TTDStation.h"
#import "TTDGroup.h"

static NSString * const kSegueIdentifiersShowStationDetails = @"showStation";

/**
 * Таблица со списком станций, разделённых на секции по cityId
 * Вся работа с данными идёт в HBSFetchedTableController, мой небольшой cocoapod, берёт на себя всю работу по общению между таблицей и fetchedResultsController.
 * Вся работа с ячейками и секциями делегируется TTDStationsFactory.
 * Фабрика так же использует контроллер данных, чтобы преобразовывать "машинные" имена секций (cityId) в читаемый вид.
 * Для отображения результатов поиска используется отдельный простой контроллер таблицы, чтобы не обновлять результаты основной в HBSFetchedTableController.
 */
@interface TTDStationsViewController () <HBSFetchedTableControllerDelegate, TTDStationsSearchResultViewControllerDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@end


@implementation TTDStationsViewController {
    HBSFetchedTableController *_tableController;
    NSFetchedResultsController *_fetchedController;
    
    TTDStationsSearchResultViewController *_searchResultsViewController;
    UISearchController *_searchController;
    NSPredicate *_searchPredicateBase;
    NSFetchedResultsController *_searchFetchedController;
}


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fetchedController = [self p_buildFetchedResultControllerForGroup:_group withCache:YES];
    TTDStationsFactory *factory = [[TTDStationsFactory alloc] init];
    factory.dataController = _dataController;
    if ([factory respondsToSelector:@selector(registerReusablesForTableView:)]) {
        [factory registerReusablesForTableView:_tableView];
    }
    
    _tableController = [[HBSFetchedTableController alloc] initWithTableView:self.tableView
                                                    fetchedResultController:_fetchedController
                                                                   delegate:self
                                                        andTableViewFactory:factory];
    
    _searchResultsViewController = [[TTDStationsSearchResultViewController alloc] init];
    _searchResultsViewController.factory = factory;
    _searchResultsViewController.delegate = self;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultsViewController];
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    self.definesPresentationContext = YES;
    
    /** 
     * There is a bug in iOs9 with UISearchController - controller attempts to load its view in its dealloc method. This will log a warning.
     * Solution - just force it to load itself.
     * OpenRadar: http://www.openradar.me/22250107
     */
    [_searchController loadViewIfNeeded];
    
    _tableView.tableHeaderView = _searchController.searchBar;
    self.definesPresentationContext = YES;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController conformsToProtocol:@protocol(TTDDataControllerUser)]) {
        [(id<TTDDataControllerUser>)segue.destinationViewController setDataController:_dataController];
    }
    
    if ([segue.identifier isEqualToString:kSegueIdentifiersShowStationDetails]) {
        TTDStationDetailsViewController *vc = (TTDStationDetailsViewController*)segue.destinationViewController;
        vc.station = sender;
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fetchedController.fetchedObjects.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [[_fetchedController objectAtIndexPath:indexPath] title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate) {
        [_delegate stationsViewController:self didSelectStation:[_fetchedController objectAtIndexPath:indexPath]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    TTDStation *station = [_fetchedController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kSegueIdentifiersShowStationDetails sender:station];
}


#pragma mark - FetchedResultsController
- (NSFetchedResultsController*)p_buildFetchedResultControllerForGroup:(TTDGroup*)group withCache:(BOOL)cache {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TTDStation entityName]];
    [request setFetchBatchSize:20];
    
    if (group) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city.group == %@", group];
        request.predicate = predicate;
    }
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cityId" ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"stationTitle" ascending:YES]];
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.dataController.managedObjectContext sectionNameKeyPath:@"cityId" cacheName:(cache ? group.title : nil)];
    
    NSError *error;
    [controller performFetch:&error];
    if (error)
        NSLog(@"Error fetching controller: %@, %@", [self class], error);
    
    return controller;
}


#pragma mark - UISearchController
- (void)willPresentSearchController:(UISearchController *)searchController {
    _searchFetchedController = [self p_buildFetchedResultControllerForGroup:_group withCache:NO];
    _searchPredicateBase = [NSPredicate predicateWithFormat:@"city.group == %@", _group];
    _searchResultsViewController.controller = _searchFetchedController;
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    _searchFetchedController = nil;
    _searchPredicateBase = nil;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *text = searchController.searchBar.text;
    
    if (text == nil || text.length == 0) {
        _searchFetchedController.fetchRequest.predicate = _searchPredicateBase;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationTitle contains[c] %@", text];
        if (_searchPredicateBase) {
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ _searchPredicateBase, predicate]];
        }
        
        _searchFetchedController.fetchRequest.predicate = predicate;
        
        NSError *error = nil;
        [_searchFetchedController performFetch:&error];
        [_searchResultsViewController.tableView reloadData];
    }
}

#pragma mark SearchResult delegate
/**
 * Результаты поиска отображает TTDStationsSearchResultViewController. Через делегат он сообщает о выбранных ячейках и нажатых кнопках.
 */
- (void)stationsSearchViewController:(TTDStationsSearchResultViewController *)controller didSelectStation:(TTDStation *)station {
    if (_delegate) {
        [_delegate stationsViewController:self didSelectStation:station];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)stationsSearchViewController:(TTDStationsSearchResultViewController *)controller accessoryButtonTappedForStation:(TTDStation *)station {
    [self performSegueWithIdentifier:kSegueIdentifiersShowStationDetails sender:station];
}


@end
