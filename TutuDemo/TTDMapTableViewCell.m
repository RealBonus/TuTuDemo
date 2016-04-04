//
//  TTDMapTableViewCell.m
//  TutuDemo
//
//  Created by Павел Анохов on 02.04.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TTDMapTableViewCell.h"
#import "TTDStationAnnotation.h"

@interface TTDMapTableViewCell () <MKMapViewDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@end

@implementation TTDMapTableViewCell {
    TTDStationAnnotation *_annotation;
}

- (void)showAnnotationAtLatitude:(double)latitude andLongitude:(double)longitude withTitle:(NSString*)title andSubtitle:(NSString*)subtitle {
    if (_annotation) {
        [_mapView removeAnnotation:_annotation];
        _annotation = nil;
    }
    
    _annotation = [[TTDStationAnnotation alloc] initWithLatitude:latitude andLongitue:longitude
                                                       withTitle:title andSubtitle:subtitle];
    [_mapView addAnnotation:_annotation];
    [_mapView showAnnotations:@[_annotation] animated:NO];
}


#pragma mark - MKMapViewDelegate
- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.animatesDrop = NO;
    pin.draggable = NO;
    
    return pin;
}

@end
