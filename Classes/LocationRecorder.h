//
//  LocationRecorder.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationMediator.h"
#import <CoreLocation/CoreLocation.h>
#import "PeriodOfTime.h"

@class ZeitfadenService;

@interface LocationRecorder : NSObject {

	NSDate *lastActUpponNewLocation;
	
	NSDate *lastRecordingTime;
	CLLocation *lastKnownLocation;
	
	NSManagedObjectID *activeStationID;
	ZeitfadenService *zeitfadenService;
	NSMutableSet *recordToGroups;
	int recordingTimeInterval;
	BOOL recordingStatus;
    
    NSString *recordingPublishStatus;
	

	
	
}

@property (retain) NSManagedObjectID *activeStationID;
@property (retain) NSDate *lastActUpponNewLocation;
@property int recordingTimeInterval;
@property (retain) CLLocation *lastKnownLocation;
@property (retain) NSDate *lastRecordingTime;
@property BOOL recordingStatus;
@property (retain) ZeitfadenService* zeitfadenService;
@property (retain) NSString *recordingPublishStatus;


- (LocationRecorder *) initWithService:(ZeitfadenService *)_service;
- (void)commitContext:(NSManagedObjectContext *)managedObjectContext;
- (void)startRecording;
- (void)stopRecording;
- (void)actUpponChangedLocation:(NSNotification *)notification;
- (NSManagedObject *)getNewStationForCurrentLocation;
- (NSManagedObject *)getNewStationInContext:(NSManagedObjectContext *)managedObjectContext;
- (BOOL)canStation:(NSManagedObject *)existingStationID beExtendedBy:(PeriodOfTime*)periodOfTime at:(CLLocation*)location;                  
- (NSString *) getDeviceTimeZoneString;
- (void)toggleGroupToBeAssignedToRecordedStations:(NSManagedObject *)group;
- (void)releaseContext:(NSManagedObjectContext *)managedObjectContext;
- (void)notifyObserversAboutNewStation:(NSManagedObject *)newStation;
- (void)notifyObserversAboutChangedStation:(NSManagedObject *)newStation;
- (void)setPublishStatusForRecording:(NSString *)publishStatus;


@end
