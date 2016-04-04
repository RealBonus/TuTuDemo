//
//  TTDStationsViewController.h
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDDataController.h"
@class TTDStationsViewController;
@class TTDStation, TTDGroup;

@protocol TTDStationsViewControllerDelegate <NSObject>
@required
- (void)stationsViewController:(TTDStationsViewController*)controller didSelectStation:(TTDStation*)station;
@end


@interface TTDStationsViewController : UIViewController <TTDDataControllerUser, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TTDGroup *group;
@property (nonatomic, strong) id<TTDDataController> dataController;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<TTDStationsViewControllerDelegate> delegate;

@end
