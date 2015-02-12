//
//  LocationRecorder.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationRecorder.h"
#import "ZeitfadenWithCoreDataAppDelegate.h"
#import "ZeitfadenService.h"

@implementation LocationRecorder

@synthesize activeStationID;
@synthesize lastActUpponNewLocation;
@synthesize recordingTimeInterval;
@synthesize lastKnownLocation;
@synthesize lastRecordingTime;
@synthesize recordingStatus;
@synthesize zeitfadenService;
@synthesize recordingPublishStatus;



- (LocationRecorder *) initWithService:(ZeitfadenService *)_service
{
	self = [super init];
	NSLog(@"The LocationRecorder is initialized.");
	
	recordToGroups = [[NSMutableSet alloc] init];

	
	self.zeitfadenService = _service;
	return self;
}


- (void)resetLocationData
{
	self.lastActUpponNewLocation = [NSDate dateWithTimeIntervalSince1970:0];
	self.lastRecordingTime = nil;
	self.lastKnownLocation = nil;
	self.activeStationID = nil;
}

- (NSManagedObjectContext *)getNewManagedObjectContext {
    
    NSManagedObjectContext *managedObjectContext = [zeitfadenService newContextToMainStore];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
	
    return [managedObjectContext retain];
}


- (void)contextDidSave:(NSNotification*)notification
{
	[zeitfadenService mergeContextChanges:notification];
}



- (void)startRecording
{
	[self resetLocationData];
	self.recordingStatus = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actUpponChangedLocation:) name:LOCATION_CHANGED object:nil];
}


- (void)stopRecording
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.recordingStatus = NO;
	
	NSManagedObjectID *stationID = self.activeStationID;
	
	[self resetLocationData];

	NSManagedObject *managedStation = nil;
	NSManagedObjectContext *managedObjectContext = [self getNewManagedObjectContext];
	
	if (stationID != nil)
	{
		managedStation = [managedObjectContext objectWithID:stationID];
	}

	if (managedStation != nil)
	{
		NSLog(@"yepp");
		[self notifyObserversAboutChangedStation:managedStation];
	}
	
}


- (void)recordMediaWithInfo:(NSDictionary *)info
{
	NSDate *currentTime = [NSDate date];

	NSManagedObjectContext *managedObjectContext = [self getNewManagedObjectContext];
	
	// in case we are recording, please close and save the last station
	if ((self.recordingStatus == YES) && (self.activeStationID != nil))
	{
		NSManagedObject *lastStation = nil;
		
		NSLog(@"making the recorder upload and remove the latestStationfrom the store");
		lastStation = [managedObjectContext objectWithID:self.activeStationID];
		[lastStation setValue:currentTime forKey:@"endDate"];
		[lastStation setEndLocation:self.lastKnownLocation];

		[self commitContext:managedObjectContext];
		self.activeStationID = nil;
		[self notifyObserversAboutChangedStation:lastStation];
	}
	
	
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	NSLog(@"Mediatype is %@", mediaType);
	
	NSManagedObject *managedStation = [self getNewStationInContext:managedObjectContext];
	[self initializeTimezonesForStation:managedStation];
	[managedStation setValue:currentTime forKey:@"startDate"];
	[managedStation setValue:currentTime forKey:@"endDate"];
	[managedStation setStartLocation: self.lastKnownLocation];
	[managedStation setEndLocation: self.lastKnownLocation];
	
	NSData *data;

	if ([mediaType isEqualToString:@"public.image"])
	{	
		NSLog(@"Image case");
		[managedStation setValue:@"IPhone 2010 Image-Upload" forKey:@"stationDescription"];
		[managedStation setValue:@"image/jpeg" forKey:@"attachmentMimeType"];
		UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
		data = UIImageJPEGRepresentation(image, 0.99);
	}
	else if ([mediaType isEqualToString:@"public.movie"])
	{
		NSLog(@"Movie case");
		[managedStation setValue:@"IPhone 2010 Video-Upload" forKey:@"stationDescription"];
		[managedStation setValue:@"video/mpeg" forKey:@"attachmentMimeType"];
		NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
		data = [NSData dataWithContentsOfURL:url];
	}
	else 
	{
		NSLog(@"default case, this is wrong.");
	}
	
	NSString *fileName = [zeitfadenService getUniqueFilename];
	[data writeToFile:fileName atomically:YES];
	
	[managedStation setValue:fileName forKey:@"attachmentFile"];

	[self commitContext:managedObjectContext];
	[self notifyObserversAboutChangedStation:managedStation];
	
	
	// in case we are recording, please open a new station
	if (self.recordingStatus == YES)
	{
		NSManagedObject *newStation = [self getNewStationInContext:managedObjectContext];
		[self initializeTimezonesForStation:newStation];
		[newStation setValue:currentTime forKey:@"startDate"];
		[newStation setValue:currentTime forKey:@"endDate"];

		[newStation setStartLocation: self.lastKnownLocation];
		[newStation setEndLocation: self.lastKnownLocation];

		[newStation setValue:@"the one after the pic" forKey:@"stationDescription"];

		self.lastRecordingTime = currentTime;

		[self commitContext:managedObjectContext];
		self.activeStationID = [newStation objectID];
		
		[self notifyObserversAboutChangedStation:newStation];
		
	}
	
	
	[self releaseContext:managedObjectContext];
	
}


- (void)actUpponChangedLocation:(NSNotification *)notification
{
	NSLog(@"Location-Recorder was notified about new location.");

	if ([[NSDate date] timeIntervalSinceDate:self.lastActUpponNewLocation] < self.recordingTimeInterval)
	{
		NSLog(@"not waited long enough, the recorder ignores this update %f", [[NSDate date] timeIntervalSinceDate:self.lastActUpponNewLocation]);
		return;
	}
	else 
	{
		NSLog(@"we waited lon enough, now going in the recording %f",[[NSDate date] timeIntervalSinceDate:self.lastActUpponNewLocation]);
		
	}

	self.lastActUpponNewLocation = [NSDate date];
									
	
	
	NSManagedObjectContext *managedObjectContext = [self getNewManagedObjectContext];

	CLLocation *newLocation = [[notification userInfo] objectForKey:@"newLocation"];
	NSDate *currentTime = [NSDate date];
	
	if (self.lastRecordingTime == nil)
	{
		self.lastRecordingTime = currentTime;
	}
	
	if (self.lastKnownLocation == nil)
	{
		self.lastKnownLocation = newLocation;
	}
	
	PeriodOfTime *periodOfTime = [[PeriodOfTime alloc] init];
	periodOfTime.startDate = self.lastRecordingTime;
	periodOfTime.endDate = currentTime;
	
	NSManagedObject *managedStation = nil;
	
	if (self.activeStationID != nil)
	{
		managedStation = [managedObjectContext objectWithID:activeStationID];
	}
	
	if ((self.activeStationID != nil) && [self canStation:managedStation beExtendedBy:periodOfTime at:newLocation])
	{
		NSLog(@"The last Station can be extended");
		[managedStation setValue:periodOfTime.endDate forKey:@"endDate"];
	}
	else 
	{
		NSLog(@"Introducing new Station, because there is no extendible one.");
		
		// well this is fucked u, its not changed, but by this way I can tll the uploader to reschedule this.
		if (managedStation != nil)
		{
			[self notifyObserversAboutChangedStation:managedStation];
		}
		
		managedStation = [self getNewStationInContext:managedObjectContext];
		
		[self initializeTimezonesForStation:managedStation];
		[managedStation setValue:self.lastRecordingTime forKey:@"startDate"];
		[managedStation setValue:currentTime forKey:@"endDate"];
		
		[managedStation setStartLocation:self.lastKnownLocation];
		[managedStation setEndLocation:newLocation];
		
		[managedStation setValue:@"IPhone 2010 Upload without Image" forKey:@"stationDescription"];
	}
	
	

	[self commitContext:managedObjectContext];
	self.activeStationID = [managedStation objectID];

	
	[self notifyObserversAboutChangedStation:managedStation];


	[self releaseContext:managedObjectContext];
	


	self.lastRecordingTime = currentTime;
	self.lastKnownLocation = newLocation;
	

	
	
	
}


- (void)initializeTimezonesForStation:(NSManagedObject *)managedStation
{
	NSString *timeZoneString = [self getDeviceTimeZoneString];
	[managedStation setValue:timeZoneString forKey:@"startTimezone"];
	[managedStation setValue:timeZoneString forKey:@"endTimezone"];
}

-(NSManagedObject *) getNewStationInContext:(NSManagedObjectContext *)managedObjectContext
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZeitfadenStation" inManagedObjectContext:managedObjectContext];

	NSManagedObject *managedStation = [NSEntityDescription
									   insertNewObjectForEntityForName:[entity name]
									   inManagedObjectContext:managedObjectContext];
	

	[managedStation setValue:recordToGroups forKey:@"assignedToGroups"];
    [managedStation setValue:self.recordingPublishStatus forKey:@"publishStatus"];

	return managedStation;
}

- (NSManagedObject *) getNewStationForCurrentLocation
{
	NSManagedObject *managedStation = [self getNewStation];
	
	
	NSString *timeZoneString = [self getDeviceTimeZoneString];
	
	NSDate *currentDate = [NSDate date];
	
	/*
	 NSString *strDate = [[currentDate dateWithCalendarFormat:@"%Y-%m-%d %H:%M:%S" timeZone:nil] description];
	 NSString *input_current_date = [[NSString alloc] initWithFormat:@"%@",strDate]; 
	 */
	
	
	[managedStation setValue:currentDate forKey:@"startDate"];
	[managedStation setValue:currentDate forKey:@"endDate"];
	[managedStation setValue:timeZoneString forKey:@"startTimezone"];
	[managedStation setValue:timeZoneString forKey:@"endTimezone"];
	[managedStation setValue:[NSNumber numberWithFloat: lastKnownLocation.coordinate.latitude] forKey:@"startLatitude"];
	[managedStation setValue:[NSNumber numberWithFloat: lastKnownLocation.coordinate.longitude] forKey:@"startLongitude"];
	[managedStation setValue:[NSNumber numberWithFloat: lastKnownLocation.coordinate.latitude] forKey:@"endLatitude"];
	[managedStation setValue:[NSNumber numberWithFloat: lastKnownLocation.coordinate.longitude] forKey:@"endLongitude"];
	
	
	return managedStation;
}


- (BOOL)canStation:(NSManagedObject *)existingStation beExtendedBy:(PeriodOfTime*)periodOfTime at:(CLLocation*)location
{
	NSLog(@"Inside the Location-Recorder: examining the lastKnowStation to see if it can be extended");
	
	NSDate *stationEndDate = [existingStation valueForKey:@"endDate"];
	
	NSNumber *stationEndLatitude = [existingStation valueForKey:@"endLatitude"];
	NSNumber *stationEndLongitude = [existingStation valueForKey:@"endLongitude"];
	
	NSNumber *comparedEndLatitude = [NSNumber numberWithFloat:location.coordinate.latitude];
	NSNumber *comparedEndLongitude = [NSNumber numberWithFloat:location.coordinate.longitude];
	
	NSLog(@"exitsing Station end Date %@ ", [stationEndDate description]);
	NSLog(@"new period of time start date %@ ", [periodOfTime.startDate description]);
	NSLog(@"existing station  end latitude %3.15f ", [stationEndLatitude floatValue]);
	NSLog(@"existing station  end longitude %3.15f ", [stationEndLongitude floatValue]);
	NSLog(@"current location latitude %3.15f ", [comparedEndLatitude floatValue]);
	NSLog(@"current location longitufe %3.15f ", [comparedEndLongitude floatValue]);
	
	
	if ([stationEndDate isEqualToDate:periodOfTime.startDate])
	{
		NSLog(@"dates matched, good.");
		if ([stationEndLatitude isEqualToNumber:comparedEndLatitude])
		{
			NSLog(@"latitudes matched, good");
			if ([stationEndLongitude isEqualToNumber:comparedEndLongitude])
			{
				NSLog(@"longitudes matched, good");
				return YES;
			}
		}
	}

	
	
	return NO;	
	
	
	
}

- (NSString *) getDeviceTimeZoneString
{
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	NSString *timeZoneString = [timeZone name];
	
	return timeZoneString;
}


- (void)toggleGroupToBeAssignedToRecordedStations:(NSManagedObject *)group
{
	if ([recordToGroups containsObject:group])
	{
		[recordToGroups removeObject:group];
	}
	else 
	{
		[recordToGroups addObject:group];
	}
}

- (void)setPublishStatusForRecording:(NSString *)publishStatus
{
    self.recordingPublishStatus = publishStatus;
}

- (void)commitContext:(NSManagedObjectContext*)managedObjectContext
{
	NSError *error;
	if (![managedObjectContext save:&error])
	{
		NSLog(@"Error saving entity: %@", [error localizedDescription]);
	}
}

- (void)releaseContext:(NSManagedObjectContext *)managedObjectContext
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
	[managedObjectContext release];
}

- (void)notifyObserversAboutNewStation:(NSManagedObject *)newStation
{
	NSDictionary *info = [NSDictionary dictionaryWithObject:newStation forKey:@"newStation"];
	[[NSNotificationCenter defaultCenter] postNotificationName:NEW_STATION_CREATED object:self userInfo:info];
}

- (void)notifyObserversAboutChangedStation:(NSManagedObject *)newStation
{
	NSDictionary *info = [NSDictionary dictionaryWithObject:newStation forKey:@"changedStation"];
	[[NSNotificationCenter defaultCenter] postNotificationName:STATION_HAS_BEEN_CHANGED object:self userInfo:info];
}



@end
