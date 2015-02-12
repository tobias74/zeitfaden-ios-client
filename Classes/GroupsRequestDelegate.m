//
//  GroupsRequestDelegate.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GroupsRequestDelegate.h"
#import "ZeitfadenWithCoreDataAppDelegate.h"

@implementation GroupsRequestDelegate



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	SBJsonParser *parser = [[SBJsonParser new] autorelease];
	NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"received from Groups-Server: %@" , json_string);
	
	NSArray *responseData = [parser objectWithString:json_string error:nil];
	if (![responseData valueForKey:@"requestCompletedSuccessfully"])
	{
		NSLog(@"request problems");
	}
	else
	{
		NSLog(@"requst complted good!");
		
		ZeitfadenWithCoreDataAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZeitfadenGroup" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		NSError *error;
		NSArray *groups = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
		NSMutableArray *groupsToBeDeleted = [NSMutableArray array];
		for (NSArray *group in groups)
		{
			[groupsToBeDeleted addObject:group];
		}
		
		
		[fetchRequest release];
		
		NSLog(@"Counted groups %d", [groupsToBeDeleted count]);
		
		
		NSArray *loadedGroupsArray = [responseData valueForKey:@"allGroups"];
		NSLog(@"Counted loaded groups %d", [loadedGroupsArray count]);
		

		
		
		for (NSArray *loadedGroup in loadedGroupsArray)
		{
			// try to find this groupID local
			NSString *groupId = [loadedGroup valueForKey:@"groupId"];
			
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZeitfadenGroup" inManagedObjectContext:managedObjectContext];
			[fetchRequest setEntity:entity];
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId=%@", groupId];
			[fetchRequest setPredicate:predicate];
			
			NSArray *predicateGroups = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
			[fetchRequest release];
			
			NSManagedObject *editGroup;
			
			if ([predicateGroups count] == 1)
			{
				NSLog(@"we found the group locally");
				editGroup = [predicateGroups objectAtIndex:0];
			}
			else if ([predicateGroups count] > 1)
			{
				NSLog(@"error in applicaiton.");
			}
			else 
			{
				NSLog(@"did not find it crreating it now");
				NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZeitfadenGroup" inManagedObjectContext:managedObjectContext];
				
				editGroup = [NSEntityDescription
							   insertNewObjectForEntityForName:[entity name]
							   inManagedObjectContext:managedObjectContext];
				
			}


			[editGroup setValue:[loadedGroup valueForKey:@"description"] forKey:@"groupDescription"];
			[editGroup setValue:[loadedGroup valueForKey:@"groupId"] forKey:@"groupId"];
			
			[groupsToBeDeleted removeObject: editGroup];
			
		}
		
		
		if (![managedObjectContext save:&error])
		{
			NSLog(@"error writing thething in the bad error");
		}
		
		
		NSLog(@"Groups to be deleted %d ", [groupsToBeDeleted count]);
		
		for (NSManagedObject *deleteGroup in groupsToBeDeleted)
		{
			[managedObjectContext deleteObject:deleteGroup];
		}
		
		
		if (![managedObjectContext save:&error])
		{
			NSLog(@"error save the context");
		}
		
	}
	
	
	
			
	
	
	//[context setLoginUserEmail:[responseData valueForKey:@"loginUserEmail"]];
	
}


@end
