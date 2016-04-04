//
//  TTDTabBarController.m
//  TutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDTabBarController.h"

@implementation TTDTabBarController

- (void)setDataController:(id<TTDDataController>)dataController {
    for (UIViewController *vc in self.viewControllers) {
        if ([vc conformsToProtocol:@protocol(TTDDataControllerUser)]) {
            [(id<TTDDataControllerUser>)vc setDataController:dataController];
        }
    }
}

@end
