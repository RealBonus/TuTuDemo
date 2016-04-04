//
//  TTDRouteFactory.h
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBSTableViewFactory.h"

@interface TTDRouteFactory : NSObject <HBSTableViewFactory>

- (UITableViewCell*)datePickerCellForTableView:(UITableView*)tableView;
- (UITableViewCell*)orderCellForTableView:(UITableView*)tableView;

@end
