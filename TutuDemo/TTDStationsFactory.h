//
//  TTDStationsFactory.h
//  TutuDemo
//
//  Created by Павел Анохов on 01.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "HBSTableViewFactory.h"
#import "TTDDataController.h"
@class TTDGroup;

@interface TTDStationsFactory : NSObject <HBSTableViewFactory>

@property (nonatomic, strong) id<TTDDataController> dataController;

@end
