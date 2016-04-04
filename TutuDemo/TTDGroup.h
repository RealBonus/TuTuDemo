//
//  TTDGroup.h
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TTDCity, TTDRoot;

NS_ASSUME_NONNULL_BEGIN

@interface TTDGroup : NSManagedObject

+ (NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "TTDGroup+CoreDataProperties.h"
