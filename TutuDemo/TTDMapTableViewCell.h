//
//  TTDMapTableViewCell.h
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Простая ячейка с картой. Ставит стандартный пин на координате и фокусирует на нём карту.
 */
@interface TTDMapTableViewCell : UITableViewCell

- (void)showAnnotationAtLatitude:(double)latitude andLongitude:(double)longitude withTitle:(NSString*)title andSubtitle:(NSString*)subtitle;

@end
