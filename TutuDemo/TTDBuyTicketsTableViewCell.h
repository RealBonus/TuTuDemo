//
//  TTDBuyTicketsTableViewCell.h
//  TutuDemo
//
//  Created by Павел Анохов on 03.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTDBuyTicketsTableViewCell : UITableViewCell

@property (nonatomic) BOOL enabled;

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated;

@end
