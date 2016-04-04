//
//  TTDRouteViewController.h
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDDataController.h"

@interface TTDRouteViewController : UIViewController <TTDDataControllerUser>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id<TTDDataController> dataController;

@end
