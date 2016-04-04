//
//  TTDStationFullTableViewCell.h
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTDStationFullTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *districtLabel;
@property (nonatomic, strong) IBOutlet UILabel *cityLabel;

@end
