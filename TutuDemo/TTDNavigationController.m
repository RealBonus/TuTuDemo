//
//  TTDNavigationController.m
//  TTDTutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDNavigationController.h"

@implementation TTDNavigationController

- (void)setDataController:(id<TTDDataController>)dataController {
    for (UIViewController *vc in self.viewControllers) {
        if ([vc conformsToProtocol:@protocol(TTDDataControllerUser)]) {
            [(id<TTDDataControllerUser>)vc setDataController:dataController];
        }
    }
}

@end
