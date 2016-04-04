//
//  TTDImportOperation.h
//  TutuDemo
//
//  Created by Павел Анохов on 04.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSManagedObjectContext;
@class TTDImportOperation;

@interface TTDImportOperation : NSOperation

@property (nonatomic) NSInteger updateRate;

- (instancetype)initWithContext:(NSManagedObjectContext*)context source:(NSString*)source;

@end
