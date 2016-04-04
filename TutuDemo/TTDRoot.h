//
//  TTDRoot.h
//  TutuDemo
//
//  Created by Павел Анохов on 03.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TTDGroup;

NS_ASSUME_NONNULL_BEGIN

@interface TTDRoot : NSManagedObject

+ (NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "TTDRoot+CoreDataProperties.h"
