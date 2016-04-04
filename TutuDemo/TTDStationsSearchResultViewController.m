//
//  TTDStationsSearchResultViewController.m
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDStationsSearchResultViewController.h"

@implementation TTDStationsSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_controller.fetchRequest.predicate == nil)
        return 0;
    
    return _controller.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_controller.fetchRequest.predicate == nil)
        return 0;
    
    return [_controller.sections[section] numberOfObjects];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_factory tableView:tableView cellForRowAtIndexPath:indexPath withObject:[_controller objectAtIndexPath:indexPath] inSection:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_factory configureCell:cell atIndexPath:indexPath withObject:[_controller objectAtIndexPath:indexPath] inSection:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(stationsSearchViewController:didSelectStation:)]) {
        [_delegate stationsSearchViewController:self didSelectStation:[_controller objectAtIndexPath:indexPath]];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(stationsSearchViewController:accessoryButtonTappedForStation:)]) {
        [_delegate stationsSearchViewController:self accessoryButtonTappedForStation:[_controller objectAtIndexPath:indexPath]];
    }
}

@end
