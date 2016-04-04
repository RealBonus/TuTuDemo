//
//  TTDBuyTicketsTableViewCell.m
//  TutuDemo
//
//  Created by Павел Анохов on 03.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDBuyTicketsTableViewCell.h"

static const double kCellAnimationDuration = 0.2;

@implementation TTDBuyTicketsTableViewCell

- (void)setEnabled:(BOOL)enabled {
    [self setEnabled:enabled animated:NO];
}

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated {
    _enabled = enabled;
    
    if (animated) {
        [UIView animateWithDuration:kCellAnimationDuration animations:^{
            [self p_setColorsForEnabled:enabled];
        }];
    } else {
        [self p_setColorsForEnabled:enabled];
    }
}

- (void)p_setColorsForEnabled:(BOOL)enabled {
    self.textLabel.textColor = enabled ? [UIColor blackColor] : [UIColor grayColor];
    self.backgroundColor = enabled ? [UIColor whiteColor] : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
}

@end
