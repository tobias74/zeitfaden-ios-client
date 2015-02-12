//
//  UploadStationsOperation.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UploadStationsOperation.h"
#import "ZeitfadenService.h"


@implementation UploadStationsOperation
@synthesize zeitfadenService;


- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) 
	{
        return managedObjectContext_;
    }
	
    managedObjectContext_ = [zeitfadenService newContextToMainStore];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext_];
	
    return managedObjectContext_;
}


- (void)contextDidSave:(NSNotification*)notification
{
	[zeitfadenService mergeContextChanges:notification];
}


-(void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if (![self isCancelled])
	{
		NSLog(@"inside the operation yesyes!!!!");
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZeitfadenStation"
												  inManagedObjectContext:managedObjectContext];
		
		NSString *sectionKey = nil;
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
		sectionKey = @"stationDescription";
		
		[fetchRequest setEntity:entity];
		[fetchRequest setFetchBatchSize:20];
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
										   initWithFetchRequest:fetchRequest
										   managedObjectContext:managedObjectContext
										   sectionNameKeyPath:sectionKey
										   cacheName:@"ZeitfadenStation"];
		
		NSError *error;
		
		if (![frc performFetch:&error])
		{
			NSLog(@"error with coredatadamn: %@", [error localizedDescription] );
		}
		
		frc.delegate = self;
		[fetchRequest release];

		
		NSArray *managedObjects = frc.fetchedObjects;
		
		if (managedObjects == nil)
		{
			NSLog(@"is nil..................... whatwhat?");
		}
		
		NSLog(@"we got %d managed obect in the queue",[managedObjects count]);
		
		
		int n;
		for (n = 0;n < [managedObjects count]; n++)
		{
			if (![self isCancelled])
			{
				NSManagedObject *zeitfadenStation = [managedObjects objectAtIndex:n];
				NSLog(@"working on object at index %d",n);
				NSLog(@"Station Description %@",[zeitfadenStation valueForKey:@"stationDescription"]);
				
				if ([zeitfadenService uploadStation:zeitfadenStation])
				{
					NSLog(@"We have a stationId in the managedStationObject: %@", [zeitfadenStation valueForKey:@"stationId"]);
					
					if ([zeitfadenService isLastKnownStation:zeitfadenStation])
					{
						NSLog(@"ahhh! this si the lastKnow station, we do not delete it!");
					}
					else 
					{
						NSLog(@"no, this is not the latstStation we delet it.");
						[managedObjectContext deleteObject:zeitfadenStation];
					}

					
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
		}
	}
}

@end
