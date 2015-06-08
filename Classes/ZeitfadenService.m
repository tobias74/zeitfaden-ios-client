//
//  ZeitfadenService.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PeriodOfTime.h"
#import "ZeitfadenService.h"
#import "ZeitfadenWithCoreDataAppDelegate.h"
#import "LocationService.h"
#import "UploadStationsOperation.h"
#import "ZeitfadenServer.h"
#import <CoreLocation/CoreLocation.h>
#import "ApplicationMediator.h"
#import "ZeitfadenApplicationController.h"
#import "LocationRecorder.h"
#import "LocationUploader.h"


@implementation ZeitfadenService

@synthesize locationUploader;
@synthesize locationRecorder;
@synthesize locationService;
@synthesize queue;
@synthesize applicationController;
@synthesize zeitfadenServer;


- (ZeitfadenService *)initWithAppDelegate:_appDelegate
{
	self = [super init];
	appDelegate = _appDelegate;
	
	self.locationService = [[LocationService alloc] init];
	
	

	self.locationRecorder = [[LocationRecorder alloc] initWithService:self];
	self.locationUploader = [[LocationUploader alloc] initWithService:self];
	

	[self setRecordingInterval:[self getRecordingInterval]];
	
	
	self.zeitfadenServer = [[ZeitfadenServer alloc] init];
	
	self.applicationController = [[ZeitfadenApplicationController alloc] init];
	
	self.queue = [[NSOperationQueue alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actUpponChangedLogin:) name:LOGIN_SUCCEEDED object:nil];
	
	return self;
	
}

- (NSManagedObjectContext *)newContextToMainStore
{
	NSPersistentStoreCoordinator *coord = [appDelegate persistentStoreCoordinator];
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	[moc setPersistentStoreCoordinator:coord];
	return [moc retain];
}

-(NSManagedObjectContext* )getMainManagedObjectContext
{
	NSLog(@"we ased thefacadefor the managed object context, cool.");
	NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
	return [managedObjectContext retain];
}

- (void)mergeContextChanges:(NSNotification *)notification
{
	SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
	[[self getMainManagedObjectContext] performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
	
}


- (void)actUpponChangedLogin:(NSNotification *)notification
{
	//NSString *email = [[notification userInfo] objectForKey:@"email"];
	NSLog(@"notified about succesfull login");
}

- (void)startLocationService
{
	[locationService startService];
}

- (void)stopLocationService
{
	[locationService stopService];
}


- (void)recordMediaWithInfo:(NSDictionary *)info
{
	[locationRecorder recordMediaWithInfo:info];
}
	

- (NSString *)getUniqueFilename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *uniqueName = [NSString stringWithFormat:@"FILE%d",[[NSDate date] timeIntervalSince1970]];
	NSLog(@"uniqueName is %@", uniqueName);
	NSString *uniqueFilename = [documentsDirectory stringByAppendingPathComponent:uniqueName];
	return uniqueFilename;
	
}

- (id <ZeitfadenViewController>)getViewController:(NSString*)viewName
{
	return [applicationController getViewController:viewName preparedWithService:self];
}

- (void)startRecordingLocations
{
	[locationRecorder startRecording];
}

- (void)stopRecordingLocations
{
	[locationRecorder stopRecording];
}

- (BOOL)isActiveStation:(NSManagedObject*)managedStation
{
	NSLog(@"we have a urirepresentation of the thing: %@", [locationRecorder.activeStationID URIRepresentation]);
	return ([[[locationRecorder.activeStationID URIRepresentation] absoluteString] isEqualToString: [[[managedStation objectID] URIRepresentation] absoluteString]]);          
			 
}



-(void)startUploadingStations
{
	NSLog(@"Start Uplaoding queue was alled in the zeitfadeService");
	[locationUploader startUploading];
}

-(void)stopUploadingStations
{
	NSLog(@"STOPtUplaoding queue was alled in the zeitfadeService");
	[locationUploader stopUploading];
}




-(BOOL)uploadStation:(id)managedStation
{
	return [zeitfadenServer uploadStation:managedStation];
	
}


- (void)sendCurrentLogin
{
	[self sendLogin:[self getUserEmail] withPassword:[self getUserPassword]];
}

- (void)sendLogin:(NSString*)loginEmail withPassword:(NSString*)password
{
	NSLog(@"Sending Login in zeitfadenservice");
	[zeitfadenServer login:loginEmail withPassword:password];
	NSLog(@"Did Send Login in zeitfadenservice");
	
}

- (void)logout
{
	NSLog(@"Sending Logout in zeitfadenservice");
	[zeitfadenServer logout];
	NSLog(@"Did Send Logout in zeitfadenservice");
	
}

- (BOOL)hasValidLogin
{
	NSLog(@"am asked about login in the service");
	return [zeitfadenServer hasValidLogin];
}





- (NSString *)getUserEmail
{
	return [self getUserDefaultForKey:@"email_field"];
}

- (NSString *)getUserPassword
{
	return [self getUserDefaultForKey:@"password_field"];
}

- (void)setUserEmail:(NSString*)email
{
	[self setUserDefault:email forKey:@"email_field"];
}

- (void)setUserPassword:(NSString*)password
{
	[self setUserDefault:password forKey:@"password_field"];
}

- (void)setRecordingInterval:(int)recordingInterval
{
	[self setUserDefault:[NSNumber numberWithInt:recordingInterval] forKey:@"recording_interval"];
	self.locationRecorder.recordingTimeInterval = recordingInterval;
	self.locationService.updateInterval = recordingInterval;
}

- (int)getRecordingInterval
{
	return [[self getUserDefaultForKey:@"recording_interval"] intValue];
}

- (BOOL)getRecordingStatus
{
	return self.locationRecorder.recordingStatus;
}


- (BOOL)getUploadingStatus
{
	return self.locationUploader.uploadingStatus;
}



- (NSUserDefaults *)myDefaults
{
	return [NSUserDefaults standardUserDefaults];
}

- (id)getUserDefaultForKey:(NSString *)key
{
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	return [NSString stringWithFormat:@"%@",[myDefaults stringForKey:key]];
}

- (void)setUserDefault:(id)value forKey:(NSString *)key
{
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	[myDefaults setObject:value forKey:key];
	
}

- (BOOL)hasUserDefaults
{
	if ([[self getUserEmail] isEqualToString:@""])
	{
		return NO;
	}
	else 
	{
		return YES;
	}
}

- (void)setPublishStatusForRecording:(NSString *)publishStatus
{
    [self.locationRecorder setPublishStatusForRecording:publishStatus];
}


@end
