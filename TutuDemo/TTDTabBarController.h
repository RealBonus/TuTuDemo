//
//  TTDTabBarController.h
//  TutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDDataController.h"

/**
 * AppDelegate передаёт контроллер данных таб бар контроллеру. ТабБарКонтроллер должен передать его всем отвечающим протоколу подчинённым контроллерам. 
 */
@interface TTDTabBarController : UITabBarController <TTDDataControllerUser>

@end
