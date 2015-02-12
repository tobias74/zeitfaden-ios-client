//
//  LocationService.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationService : NSObject <CLLocationManagerDelegate>
{

	CLLocationManager *locationManager;
	CLLocationCoordinate2D currentCoordinate;
	NSDate *lastUpdateDate;
	NSMutableArray *observers;
	NSMutableArray *locationMeasurements;
	NSTimer *serviceTimer;
	CLLocation *currentLocation;
	CLLocation *bestEffortAtLocation;
	BOOL isWaitingForTimeout;
	BOOL serviceIsStarted;
	BOOL isRoundActive;
	float updateInterval;
}

- (void)initLocationManager;
- (float)getCurrentLatitude;
- (float)getCurrentLongitude;
- (void)setDistanceFilter:(int)distanceFilter;
- (void)notifyObserversAboutNewLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)observeLocationChanges:(id)observer;
- (void)stopObservingLocationChanges:(id)observer;
- (void)startUpdatingLocation:(NSString *)stateString;
- (void)stopUpdatingLocation:(NSString *)stateString;
- (void)startService;
- (void)stopService;
- (void)reset;
- (void) timerCallback:(NSTimer *)timer;
- (void)timedOutDuringUpdating:(NSString *)stateString;


- (void)startToWaitForTimeout;
- (void)stopWaitingForTimeout;




@property (nonatomic, retain) NSDate *lastUpdateDate;
@property (retain) CLLocationManager *locationManager;
@property (retain) NSMutableArray *locationMeasurements;
@property (retain) CLLocation *bestEffortAtLocation;
@property (retain) CLLocation *currentLocation;
@property (retain) NSTimer *serviceTimer;
@property BOOL isWaitingForTimeout;
@property BOOL serviceIsStarted;
@property BOOL isRoundActive;
@property CLLocationCoordinate2D currentCoordinate;
@property float updateInterval;

@end
