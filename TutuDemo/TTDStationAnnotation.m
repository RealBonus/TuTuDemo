//
//  TTDStationAnnotation.m
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "TTDStationAnnotation.h"

@implementation TTDStationAnnotation {
    NSString *_title;
    NSString *_subtitle;
}

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString*)title andSubtitle:(nullable NSString*)subtitle {
    if (self = [super init]) {
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
    }
    
    return self;
}

- (instancetype)initWithLatitude:(double)latitude andLongitue:(double)longitude withTitle:(NSString *)title andSubtitle:(NSString *)subtitle {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    self = [self initWithCoordinate:coordinate withTitle:title andSubtitle:subtitle];
    return self;
}

- (NSString*)title {
    return _title;
}

- (NSString*)subtitle {
    return _subtitle;
}

@end
