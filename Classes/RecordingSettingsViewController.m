    //
//  RecordingSettingsViewController.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RecordingSettingsViewController.h"
#import "GroupsSelectorViewController.h"
#import "PublishStatusSelectorViewController.h"

@implementation RecordingSettingsViewController

@synthesize groupsSelectorViewController;
@synthesize publishStatusSelectorViewController;
@synthesize distanceSliderLabel;
@synthesize distanceSlider;
@synthesize recordingStatus;
@synthesize uploadingStatus;


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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.distanceSlider.value = [zeitfadenService getRecordingInterval];
	[self.recordingStatus setOn:[zeitfadenService getRecordingStatus] animated:YES];
	[self.uploadingStatus setOn:[zeitfadenService getUploadingStatus] animated:YES];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (IBAction) showGroupsSelectorView:(id)sender
{
	if (self.groupsSelectorViewController == nil)
	{
		GroupsSelectorViewController *groupsSelectorController = [[GroupsSelectorViewController alloc] initWithNibName:@"GroupsSelectorView" bundle:nil serviceFacade:zeitfadenService];
		self.groupsSelectorViewController = groupsSelectorController;
		[groupsSelectorController release];
	}
	
	[self pushController:self.groupsSelectorViewController withTransition:UIViewAnimationTransitionCurlUp];
	
}

- (IBAction) showPublishStatusSelectorView:(id)sender
{
	if (self.publishStatusSelectorViewController == nil)
	{
		PublishStatusSelectorViewController *publishStatusSelectorController = [[PublishStatusSelectorViewController alloc] initWithNibName:@"PublishStatusSelectorView" bundle:nil serviceFacade:zeitfadenService];
		self.publishStatusSelectorViewController = publishStatusSelectorController;
		[publishStatusSelectorController release];
	}
	
	[self pushController:self.publishStatusSelectorViewController withTransition:UIViewAnimationTransitionCurlUp];
	
}



-(IBAction)sliderChanged:(id)sender
{
	UISlider *slider = (UISlider *) sender;
	int distance = (int)(slider.value + 0.5f);
	NSString *newText = [[NSString alloc] initWithFormat:@"%d", distance];
	distanceSliderLabel.text = newText;
	
	
	[newText release];
	NSLog(@"slider changed");
	
}

-(IBAction)sliderUp:(id)sender
{
	NSLog(@"Yes clicked!");

	UISlider *slider = (UISlider *) sender;
	int distanceFilter = (int)(slider.value + 0.5f);
	
	NSLog(@"In the view controller we have the distance %d", distanceFilter);
	
	[zeitfadenService setRecordingInterval:distanceFilter];
	
}


-(IBAction)recordingSwitchChanged:(id)sender
{
	NSLog(@"The Recording Switch was changed.");
	UISwitch *recordingSwitch = (UISwitch *)sender;
	if(recordingSwitch.isOn)
	{
        NSLog(@"The recording switch is on");
		[zeitfadenService startRecordingLocations];
	}
	else 
	{
        NSLog(@"The recording switch is off");
		[zeitfadenService stopRecordingLocations];
	}
}


-(IBAction)uploadingSwitchChanged:(id)sender
{
	NSLog(@"The Uploading Switch was changed.");
	UISwitch *uploadingSwitch = (UISwitch *)sender;
	if(uploadingSwitch.isOn)
	{
		[zeitfadenService startUploadingStations];
	}
	else 
	{
		[zeitfadenService stopUploadingStations];
	}
	
}






- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
