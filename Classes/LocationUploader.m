//
//  LocationUploader.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationUploader.h"
#import "UploadSingleStationOperation.h"
#import "ZeitfadenService.h"


@implementation LocationUploader
@synthesize uploadingStatus;
@synthesize areThereMore;

- (LocationUploader *) initWithService:(ZeitfadenService *)_service
{
	self = [super init];
	NSLog(@"The LocationUploader is initialized.");
	zeitfadenService = _service;
	queue = nil;
	managedObjectContext = [zeitfadenService getMainManagedObjectContext];
	if (managedObjectContext == nil)
	{
		NSLog(@"STARTING WITH THE BAD STUFF WHY IS THE Mananageggee c nil?");
	}
	
	
	return self;
}






- (void)startUploading
{
	queue = [[NSOperationQueue alloc] init];
	[queue setMaxConcurrentOperationCount:1];
	[queue setSuspended:YES];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actUpponChangedStation:) name:STATION_HAS_BEEN_CHANGED object:nil];
	
	[self initializeUploadQueue];
	
	[queue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
	
	[queue setSuspended:NO];
	self.uploadingStatus =YES;

}


- (void)stopUploading
{
	[queue setSuspended:YES];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[queue removeObserver:self forKeyPath:@"operations"];
	self.uploadingStatus = NO;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSLog(@"did getnotice about changes in the upload queue.");
	
	if ([queue operationCount] <= 1)
	{
		if (self.areThereMore == YES)
		{
			NSLog(@"re-initializing the upload queue");
            [queue removeObserver:self forKeyPath:@"operations"];
            [self startUploading];
			//[self initializeUploadQueue];
		}
	}
	
	
}

- (void)initializeUploadQueue
{
	// get all station stored in the coredata
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	if (managedObjectContext == nil)
	{
		NSLog(@"BAD STUFF WHY IS THE Mananageggee c nil?");
	}
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZeitfadenStation" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
										 initWithKey:@"stationDescription" ascending:YES];
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
										 initWithKey:@"startDate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc]
								initWithObjects:sortDescriptor1, sortDescriptor2, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptor1 release];
	[sortDescriptor2 release];
	[sortDescriptors release];
	
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchLimit:10];
	[fetchRequest setFetchBatchSize:20];
	
	NSError *error = nil;
	NSArray *managedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	// I have the stations now in an Array
	NSLog(@"we got %d managed obect in the queue",[managedObjects count]);
	
	if ([managedObjects count] >= 9)
	{
		self.areThereMore=YES;
	}
	else 
	{
		self.areThereMore=NO;
	}

	NSLog(@"-------------We found more staitons to upload %d",[managedObjects count]);
    
	int n;
	for (n = 0;n < [managedObjects count]; n++)
	{
		NSManagedObject *zeitfadenStation = [managedObjects objectAtIndex:n];
		NSLog(@"PUTTING  IN UPLOAD-QUEUEU: working on object at index %d",n);
		NSLog(@"Station Description %@",[zeitfadenStation valueForKey:@"stationDescription"]);

		[self enqueueStationForUploading:zeitfadenStation];
	}
	
}


- (BOOL)hasOperationQueuedForStationID:(NSManagedObjectID*)managedID
{
    NSLog(@"HASOPERATIONQUEUED?");
	for (UploadSingleStationOperation *operation in [queue operations])
	{
        NSLog(@"forloop");
		if ([[[managedID URIRepresentation] absoluteString] isEqualToString: [[operation.stationID URIRepresentation] absoluteString]])
		{
            NSLog(@"returningyes");
			return YES;
		}
	}
    NSLog(@"returning---no");
	return NO;
}

- (void)enqueueStationForUploading:(NSManagedObject *)zeitfadenStation
{
    NSLog(@"INSIDE THE FUNCTION WHATS NOW?");
    
	if (![self hasOperationQueuedForStationID:[zeitfadenStation objectID]])
	{
		NSLog(@"YES YSE YSE Queing up station for upload: %@", [[[zeitfadenStation objectID] URIRepresentation] absoluteString]);
		UploadSingleStationOperation *uploadOperation = [[UploadSingleStationOperation alloc] initWithStationID:[zeitfadenStation objectID] useService:zeitfadenService];
		[queue addOperation: uploadOperation];
		[uploadOperation release];
	}
	else 
	{
		NSLog(@"NOT NOT NOT queing up station %@ because it is already queued", [[[zeitfadenStation objectID] URIRepresentation] absoluteString]);
	}

	
}


- (void)actUpponChangedStation:(NSNotification *)notification
{
	NSLog(@"The LocationUplader was notified about a new station while he was uploading");

	NSManagedObject *changedStation = [[notification userInfo] objectForKey:@"changedStation"];
	[self enqueueStationForUploading:changedStation];

}

@end
