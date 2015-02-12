//
//  UploadSingleStationOperation.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UploadSingleStationOperation.h"
#import "ZeitfadenService.h"


@implementation UploadSingleStationOperation

@synthesize stationID;
@synthesize zeitfadenService;

- (UploadSingleStationOperation *) initWithStationID:(NSManagedObjectID *)_stationID useService:(ZeitfadenService *)_service 
{
	self = [super init];
	self.zeitfadenService = _service;
	self.stationID = _stationID;

    managedObjectContext = [zeitfadenService newContextToMainStore];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
	
	return self;
}


- (void)cleanUp
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)contextDidSave:(NSNotification *)notification
{
	[zeitfadenService mergeContextChanges:notification];
}


- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if (![self isCancelled])
	{
		NSLog(@"inside the single-operation! %@", [[stationID URIRepresentation] absoluteString]);
		
		NSManagedObject *zeitfadenStation = [managedObjectContext objectWithID:stationID];
		
		NSLog(@"After getting the station from th id in the isngle worker operation");
		
		NSLog(@"Station Description %@",[zeitfadenStation valueForKey:@"stationDescription"]);
		
		if ([zeitfadenService uploadStation:zeitfadenStation])
		{
			NSLog(@"We have a stationId in the managedStationObject: %@", [zeitfadenStation valueForKey:@"stationId"]);
			
			if ([zeitfadenService isActiveStation:zeitfadenStation])
			{
				NSLog(@"ahhh! this si the lastKnow station, we do not delete it!");
			}
			else 
			{
				NSLog(@"no, this is not the latstStation we delet it.");
				[managedObjectContext deleteObject:zeitfadenStation];
			}
			
			NSError *error;
			if (![managedObjectContext save:&error])
			{
				NSLog(@"erro persisting store after delete.");
			}
		}
		else 
		{
			NSLog(@"Upload of station did fail?");
		}
				
	}
	
	
	[self cleanUp];
	[pool drain];
}





@end
