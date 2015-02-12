//
//  ZeitfadenService.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZeitfadenApplicationController.h"
#import "LocationRecorder.h"
#import "LocationUploader.h"





@class LocationService;
@class UploadStationsOperation;
@class ZeitfadenServer;
@class PeriodOfTime;
@class CLLocation;
@class ZeitfadenWithCoreDataAppDelegate;
@class LocationRecorder;
@class ZeitfadenApplicationController;
@class LocationUploader;

@interface ZeitfadenService : NSObject {

	LocationService *locationService;
	ZeitfadenServer *zeitfadenServer;
	UploadStationsOperation *uploadOperation;
	NSOperationQueue *queue;
	ZeitfadenWithCoreDataAppDelegate *appDelegate;
	LocationRecorder *locationRecorder;
	ZeitfadenApplicationController *applicationController;
	LocationUploader *locationUploader;
}

- (NSManagedObjectContext *)newContextToMainStore;
- (NSManagedObjectContext* )getMainManagedObjectContext;
- (void)mergeContextChanges:(NSNotification *)notification;

- (BOOL)isLastKnownStation:(NSManagedObject*)managedStation;


- (void)setDistanceFilter:(int)myInt;
- (BOOL)uploadStation:(id)managedStation;
- (void)sendLogin:(NSString*)login withPassword:(NSString*)password;
- (void)sendCurrentLogin;
- (void)logout;
- (id)getUserDefaultForKey:(NSString *)key;
- (void)setUserDefault:(id)value forKey:(NSString *)key;
- (void) loadGroups;
- (void) createGroup:(NSString *)groupName;
- (void)observeLoginChanges:(id)observer;
- (void)stopObservingLoginChanges:(id)observer;
- (BOOL)hasValidLogin;
- (NSString *)getUserEmail;
- (NSString *)getUserPassword;
- (void)setUserEmail:(NSString*)email;
- (void)setUserPassword:(NSString*)password;
- (BOOL)hasUserDefaults;

- (NSUserDefaults *)myDefaults;

- (void)startRecordingLocations;
- (void)stopRecordingLocations;

- (void)startLocationService;
- (void)stopLocationService;

-(void)startUploadingStations;
-(void)stopUploadingStations;

- (void)setRecordingInterval:(int)recordingInterval;
- (int)getRecordingInterval;

- (void)setPublishStatusForRecording:(NSString *)publishStatus;

- (ZeitfadenService *)initWithAppDelegate:_appDelegate;


- (void) actUpponChangedLogin:(NSNotification *)notification;

- (id <ZeitfadenViewController>)getViewController:(NSString*)viewName;




@property (retain) LocationUploader *locationUploader;
@property (retain) LocationRecorder *locationRecorder;
@property (retain) LocationService *locationService;
@property (retain) NSOperationQueue *queue;
@property (retain) ZeitfadenServer *zeitfadenServer;
@property (retain) ZeitfadenApplicationController *applicationController;







@end
