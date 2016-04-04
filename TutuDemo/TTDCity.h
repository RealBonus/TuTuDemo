//
//  TTDCity.h
//  TutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TTDStation, TTDGroup;

NS_ASSUME_NONNULL_BEGIN

@interface TTDCity : NSManagedObject

+ (NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "TTDCity+CoreDataProperties.h"
