//
//  PendingUploadCell.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface PendingUploadCell : UITableViewCell {

	UILabel *stationDescription;
	UILabel *startDateLabel;
	UILabel *endDateLabel;
	MKMapView *mapView;
	

}

@property (retain) UILabel *stationDescription;
@property (retain) UILabel *startDateLabel;
@property (retain) UILabel *endDateLabel;
@property (retain) MKMapView *mapView;


- (void)setStartLatitude:(float)latitude andStartLongitude:(float)longitude;
- (void)clearLocations;

@end
