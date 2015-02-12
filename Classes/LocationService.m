//
//  LocationService.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "LocationService.h"
#import "ApplicationMediator.h"


@implementation LocationService

@synthesize lastUpdateDate;
@synthesize locationManager;
@synthesize locationMeasurements;
@synthesize bestEffortAtLocation;
@synthesize serviceTimer;
@synthesize currentCoordinate;
@synthesize isWaitingForTimeout;
@synthesize currentLocation;
@synthesize serviceIsStarted;
@synthesize isRoundActive;
@synthesize updateInterval;


-(LocationService *) init
{
	self = [super init];
	
	[self initLocationManager];
	self.updateInterval = 30.0f;
	
	return self;
	
}

-(void) initLocationManager
{
	NSLog(@"LocationService was initialized.");
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
	
    observers = [[NSMutableArray alloc] init];
	
	self.locationMeasurements = [NSMutableArray arrayWithCapacity:128];
	
}





- (void)startRound:(NSString *)stateString
{
	NSLog(@"New Location-Round started. ********************************************************");
	self.isRoundActive = YES;
	self.bestEffortAtLocation = nil;
	self.currentLocation = nil;
	self.lastUpdateDate = nil;

	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

	[self startToWaitForTimeout];

	
}

- (void)stopRound
{
	NSLog(@"Round ended, now putting the locationmanager in threekm-mode.");
	self.isRoundActive = NO;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
	if (self.updateInterval < 16.0f)
	{
		self.updateInterval = 16.0f;
	}
	[self performSelector:@selector(startRound:) withObject:@"yeah bull" afterDelay:self.updateInterval];
}

- (void) startService
{
	self.locationManager.delegate = self;
	self.serviceIsStarted = YES;
	[self.locationManager startUpdatingLocation];

	[self startRound:@"holy fuck"];
}

- (void) stopService
{
	NSLog(@"this does not stop our thing, we need to redo this, its not used for the time beeing.");

	[locationManager stopUpdatingLocation];
	locationManager.delegate = nil;

	self.serviceIsStarted = NO;
	[self stopWaitingForTimeout];
	
}





- (void)locationSearchingTimeout:(NSString *)stateString
{
	NSLog(@"Location Search Timed out. We were still waiting for this timeout?");

	[self stopWaitingForTimeout];
	
	[self publishBestLocation];
	
	
}

- (void)startToWaitForTimeout
{
	self.isWaitingForTimeout = YES;
	[self performSelector:@selector(locationSearchingTimeout:) withObject:@"Timed Out" afterDelay:15.0];
}

- (void)stopWaitingForTimeout
{
	NSLog(@"we called the stopWaitingForTimeout... now cancelling the delayedPefoforo");
	[self stopRound];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationSearchingTimeout:) object:@"Timed Out"];
	self.isWaitingForTimeout = NO;
}


- (void)publishBestLocation
{
	if (self.bestEffortAtLocation != nil)
	{
		NSLog(@"publishing new best location");
		[self notifyObserversAboutNewLocation:self.bestEffortAtLocation fromLocation:nil];

		self.currentLocation = self.bestEffortAtLocation;
		self.bestEffortAtLocation = nil;
		self.currentCoordinate = self.currentLocation.coordinate;
		
	}
	else if (self.currentLocation != nil)
	{
		NSLog(@"publishing last know best location, we obviously did not move");
		[self notifyObserversAboutNewLocation:self.currentLocation fromLocation:nil];
	}
	else 
	{
		// we dont kow anything, we could be at the northpole for all I know.
	}

	

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"did update to location was called.!!!!!!!!!!!!!!!!!!!!!!!!!!");

	if (self.isRoundActive == NO)
	{
		NSLog(@"And ismissed right away, because round is not active.");
		return;
	}
	
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
	if (locationAge > 5.0) 
	{
		NSLog(@"location is too old, not using it.");	
		return;
	}

	if (newLocation.horizontalAccuracy < 0) 
	{
		NSLog(@"location has invalid accuracy what??.");	
		return;
	}

	// remember, the word accuracy is not realy a good choice of words, becuase the lower he accuricy in meters, the better the result.
	if (self.bestEffortAtLocation == nil || self.bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy)
	{
		self.bestEffortAtLocation = newLocation;
		self.lastUpdateDate = [NSDate date];
		
		if (newLocation.horizontalAccuracy <= 10.0f)
		{
			NSLog(@"This is exceptional!! ##################### accuracy was better then needed: %f",newLocation.horizontalAccuracy);
			[self stopWaitingForTimeout];
			[self publishBestLocation];
		}
		else
		{
			NSLog(@"Not using the current coordinate right away, because we were not accurate enough %f with latitude %f and longitude %f",newLocation.horizontalAccuracy,newLocation.coordinate.latitude, newLocation.coordinate.longitude);	
		
		}
	}
	else
	{
		NSLog(@"we did get a location, but our current best choice is alrady better, moving on.....  compare %f with %f ", bestEffortAtLocation.horizontalAccuracy , newLocation.horizontalAccuracy);	
		NSLog(@"newLocation latitude %f with lonitude %f ", newLocation.coordinate.latitude, newLocation.coordinate.longitude);	
	}
	
	
}


- (float)getCurrentLatitude
{
	return self.currentCoordinate.latitude;
}

- (float)getCurrentLongitude
{
	return self.currentCoordinate.longitude;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *) error
{
	NSLog(@"Location Manager could not update to location .!!!!!!!!!!!!!!!!!!!!!!!!!!");
}

- (void)notifyObserversAboutNewLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSDictionary *info = [NSDictionary dictionaryWithObject:newLocation forKey:@"newLocation"];
	[[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_CHANGED object:self userInfo:info];
}









@end
