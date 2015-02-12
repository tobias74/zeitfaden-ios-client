    //
//  GroupsSelectorViewController.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GroupsSelectorViewController.h"
#import "ZeitfadenWithCoreDataAppDelegate.h"


@implementation GroupsSelectorViewController




#pragma mark -
- (IBAction)addGroup {
	NSManagedObjectContext *context =
	[self.fetchedResultsController managedObjectContext];
	NSEntityDescription *entity =
	[[self.fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription
										 insertNewObjectForEntityForName:[entity name]
										 inManagedObjectContext:context];
	
	[newManagedObject setValue:@"New Group" forKey:@"groupDescription"];
	NSError *error;
	if (![context save:&error])
		NSLog(@"Error saving entity: %@", [error localizedDescription]);
	// TODO: Instantiate detail editing controller and push onto stack
}
- (IBAction)toggleEdit {
	BOOL editing = !self.tableView.editing;
	self.navigationItem.rightBarButtonItem.enabled = !editing;
	self.navigationItem.leftBarButtonItem.title = (editing) ?
	NSLocalizedString(@"Done", @"Done") : NSLocalizedString(@"Edit", @"Edit");
	[self.tableView setEditing:editing animated:YES];
}
- (void)viewDidLoad 
{
	[super viewDidLoad];
	NSLog(@"View did load called");
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:NSLocalizedString(@"Error loading data",
															  @"Error loading data")
							  message:[NSString stringWithFormat:NSLocalizedString(
																				   @"Error was: %@, quitting.", @"Error was: %@, quitting."),
									   [error localizedDescription]]
							  delegate:self
							  cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts")
							  otherButtonTitles:nil];
		[alert show];
	}
}
- (void)viewDidAppear:(BOOL)animated 
{
	if (self.editButtonItem == nil)
	{
		NSLog(@"that damn thing is nil, but this message is a start");
	}
	
	
	//UIBarButtonItem *editButton = self.editButtonItem;
	//[editButton setTarget:self];
	//[editButton setAction:@selector(toggleEdit)];
	//self.navigationItem.leftBarButtonItem = editButton;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
								  target:self
								  action:@selector(addGroup)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	NSLog(@"View did appear called and ended good.");
	
}
- (void)viewDidUnload {
    [super viewDidUnload];
	
	self.tableView = nil;
}
- (void)dealloc {
	[tableView release];
	[_fetchedResultsController release];
	[super dealloc];
}





#pragma mark -
#pragma mark Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSUInteger count = [[self.fetchedResultsController sections] count];
	if (count == 0)
	{
		count = 1;
	};
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *sections = [self.fetchedResultsController sections];
	NSUInteger count = 0;
	if ([sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
		count = [sectionInfo numberOfObjects];
	}
	
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *GroupsSelectorTableViewCell = @"GroupsSelectorTableViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupsSelectorTableViewCell];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GroupsSelectorTableViewCell] autorelease];
	}
	
	NSManagedObject *oneGroup = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = [oneGroup valueForKey:@"groupDescription"];
	//cell.detailTextLabel.text = [oneStation valueForKey:@"startDate"];
	cell.detailTextLabel.text = @"hmm, subtitle for group";
	return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	NSManagedObject *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	[zeitfadenService toggleGroupToBeAssignedToRecordedStations:group];
	selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		NSError *error;
		
		if (![context save:&error]) 
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
			UIAlertView *alert = [[UIAlertView alloc] 
								  initWithTitle: NSLocalizedString(@"Error saving after delete", @"Error saving after delete.") 
								  message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.",@"Error was: %@, quitting."), [error localizedDescription]]
								  delegate:self
								  cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts")
								  otherButtonTitles:nil];
			[alert show];
		}
	}
}


#pragma mark -
#pragma mark Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	ZeitfadenWithCoreDataAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ZeitfadenGroup"
											  inManagedObjectContext:managedObjectContext];
	NSString *sectionKey = nil;
	NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
										 initWithKey:@"groupDescription" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc]
								initWithObjects:sortDescriptor1, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptor1 release];
	[sortDescriptors release];
	sectionKey = @"groupDescription";
	
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20];
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
									   initWithFetchRequest:fetchRequest
									   managedObjectContext:managedObjectContext
									   sectionNameKeyPath:sectionKey
									   cacheName:@"ZeitfadenGroup"];
	frc.delegate = self;
	_fetchedResultsController = frc;
	[fetchRequest release];
	return _fetchedResultsController;
}


#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex {
	exit(-1);
}





/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
