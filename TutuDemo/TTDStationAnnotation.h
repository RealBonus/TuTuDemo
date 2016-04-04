//
//  TTDStationAnnotation.h
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Простой immutable контейнер данных станции для реализации поддержки протокола MKAnnotation.
 */
@interface TTDStationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly, nullable) NSString *subtitle;

- (instancetype)initWithLatitude:(double)latitude andLongitue:(double)longitude withTitle:(NSString*)title andSubtitle:(nullable NSString*)subtitle;
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString*)title andSubtitle:(nullable NSString*)subtitle;

@end

NS_ASSUME_NONNULL_END