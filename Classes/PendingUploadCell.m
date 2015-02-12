//
//  PendingUploadCell.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PendingUploadCell.h"
#import "LocationAnnotation.h"


@implementation PendingUploadCell

@synthesize stationDescription;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize mapView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.stationDescription = [[[UILabel alloc] initWithFrame:CGRectMake(130.0,5.0,180.0,20.0)] autorelease];
		self.stationDescription.font = [UIFont boldSystemFontOfSize:12];
		[self.contentView addSubview:self.stationDescription];

		self.startDateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(130.0,30.0,180.0,20.0)] autorelease];
		self.startDateLabel.font = [UIFont boldSystemFontOfSize:10];
		[self.contentView addSubview:self.startDateLabel];

		self.endDateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(130.0,50.0,180.0,20.0)] autorelease];
		self.endDateLabel.font = [UIFont boldSystemFontOfSize:10];
		[self.contentView addSubview:self.endDateLabel];
		
		self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0.0,0.0,120.0,120.0)] autorelease];
		
		[self.contentView addSubview:self.mapView];
		
    }
    return self;
}

- (void)setStartLatitude:(float)latitude andStartLongitude:(float)longitude
{
	CLLocationCoordinate2D startCoordinate;
	startCoordinate.latitude = latitude;
	startCoordinate.longitude = longitude;
	
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(startCoordinate, 250, 250);
	MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
	[self.mapView setRegion:adjustedRegion animated:YES];
	
	LocationAnnotation *annotation = [LocationAnnotation annotationWithCoordinate:startCoordinate];
	[self.mapView addAnnotation:annotation];
}

- (void)clearLocations
{
	[self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
