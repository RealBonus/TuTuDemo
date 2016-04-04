//
//  TTDNavigationController.h
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDDataController.h"

/**
 * При представлении навигаторов, представляющие его контроллеры передают контроллер данных ему. Навигатор должен передать его дальше всем подчинённым контроллерам.
 */
@interface TTDNavigationController : UINavigationController <TTDDataControllerUser>

@end
