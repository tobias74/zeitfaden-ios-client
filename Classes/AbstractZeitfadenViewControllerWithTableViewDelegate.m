//
//  AbstractZeitfadenViewControllerWithTableViewDelegate.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AbstractZeitfadenViewControllerWithTableViewDelegate.h"


@implementation AbstractZeitfadenViewControllerWithTableViewDelegate


#pragma mark Properties
@synthesize tableView;
@synthesize fetchedResultsController = _fetchedResultsController;




- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	sectionInsertCount = 0;
	[self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath 
{
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray
													arrayWithObject:newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray
													arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate: {
			NSLog(@"there were changes recorded in the abstract viewcontroller !!!!!!!!!!!!!!!!!!!!ÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖÖ");

			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			
			NSString *sectionKeyPath = [controller sectionNameKeyPath];
			if (sectionKeyPath == nil)
				break;
			NSManagedObject *changedObject = [controller
											  objectAtIndexPath:indexPath];
			NSArray *keyParts = [sectionKeyPath componentsSeparatedByString:@"."];
			id currentKeyValue = [changedObject valueForKeyPath:sectionKeyPath];
			for (int i = 0; i < [keyParts count] - 1; i++) {
				NSString *onePart = [keyParts objectAtIndex:i];
				changedObject = [changedObject valueForKey:onePart];
			}
			sectionKeyPath = [keyParts lastObject];
			NSDictionary *committedValues = [changedObject
											 committedValuesForKeys:nil];
			if ([[committedValues valueForKeyPath:sectionKeyPath] isEqual:currentKeyValue]) 
				break;
			
			NSUInteger tableSectionCount = [self.tableView numberOfSections];
			NSUInteger frcSectionCount = [[controller sections] count];
			if (tableSectionCount + sectionInsertCount != frcSectionCount) {
				// Need to insert a section
				NSArray *sections = controller.sections;
				NSInteger newSectionLocation = -1;
				for (id oneSection in sections) {
					NSString *sectionName = [oneSection name];
					if ([currentKeyValue isEqual:sectionName]) {
						newSectionLocation = [sections indexOfObject:oneSection];
						break;
					}
				}
				
				if (newSectionLocation == -1)
					return; // uh oh
				
				
				if (!((newSectionLocation == 0) && (tableSectionCount == 1) && ([self.tableView numberOfRowsInSection:0] == 0)))
				{
					[self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionLocation] withRowAnimation:UITableViewRowAnimationFade];
					sectionInsertCount++;
				}
				
				NSUInteger indices[2] = {newSectionLocation, 0};
				newIndexPath = [[[NSIndexPath alloc] initWithIndexes:indices length:2] autorelease];
			}
			
			
		}
		case NSFetchedResultsChangeMove:
			if (newIndexPath != nil) 
			{
				NSUInteger tableSectionCount = [self.tableView numberOfSections];
				NSUInteger frcSectionCount = [[controller sections] count];
				
				if (frcSectionCount != tableSectionCount + sectionInsertCount)
				{
					[self.tableView insertSections:[NSIndexSet indexSetWithIndex:[newIndexPath section]] withRowAnimation:UITableViewRowAnimationNone];
					sectionInsertCount++;
				}
				
				[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
				[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation: UITableViewRowAnimationRight];
			}
			else 
			{
				[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
			}
			
			break;
		default:
			break;
	}
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
	switch(type) {
		case NSFetchedResultsChangeInsert:
			if (!((sectionIndex == 0) && ([self.tableView numberOfSections] == 1)))
			{
				[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
				sectionInsertCount++;
			}
			break;
			
		case NSFetchedResultsChangeDelete:
			if (!((sectionIndex == 0) && ([self.tableView numberOfSections] == 1)))
			{
				[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
				sectionInsertCount--;
			}
			break;
			
		case NSFetchedResultsChangeMove:
			break;
			
		case NSFetchedResultsChangeUpdate:
			break;
			
		default:
			break;
	}
}


@end
