//
//  LocationAnnotation.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface LocationAnnotation : NSObject <MKAnnotation> {

	CLLocationCoordinate2D _coordinate;
	
	
}

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (assign) CLLocationCoordinate2D coordinate;

@end
