//
//  TTDStationsSearchResultViewController.h
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HBSTableViewFactory.h"
@class TTDStation, TTDStationsSearchResultViewController;

@protocol TTDStationsSearchResultViewControllerDelegate <NSObject>
@optional
- (void)stationsSearchViewController:(TTDStationsSearchResultViewController*)controller didSelectStation:(TTDStation*)station;
- (void)stationsSearchViewController:(TTDStationsSearchResultViewController*)controller accessoryButtonTappedForStation:(TTDStation*)station;
@end


@interface TTDStationsSearchResultViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *controller;
@property (nonatomic, strong) id<HBSTableViewFactory> factory;
@property (nonatomic, weak) id<TTDStationsSearchResultViewControllerDelegate> delegate;

@end
