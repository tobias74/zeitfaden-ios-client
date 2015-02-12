    //
//  RecordingViewController.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RecordingViewController.h"
#import "LocationService.h"
#import "PeriodOfTime.h"
#import <CoreLocation/CoreLocation.h>




@implementation RecordingViewController
@synthesize mapView;
@synthesize toolBar;


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
	

	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonTapped)];
	self.navigationItem.rightBarButtonItem = settingsButton;
	[settingsButton release];
	
	
	NSMutableArray *toolBarItems = [NSMutableArray array];
	[toolBarItems addObject: [[[UIBarButtonItem alloc] initWithTitle:@"pic" style:UIBarButtonItemStylePlain target:self action:@selector(takePic)] autorelease]];
	
	toolBar.items = toolBarItems;
	
	mapView.mapType = MKMapTypeStandard;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actUpponChangedLocation:) name:LOCATION_CHANGED object:nil];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void) settingsButtonTapped
{
	//[self popWithTransition: UIViewAnimationTransitionCurlUp];
	[self navigateTo:RECORDING_SETTINGS_VIEW];
}

- (void) popWithTransition: (UIViewAnimationTransition) transition
{ 
	[UIView beginAnimations:nil context:NULL]; 
	[UIView setAnimationDuration:.75]; 
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationTransition:transition forView:self.navigationController.view cache:YES];
	[UIView commitAnimations]; 
	[self.navigationController popViewControllerAnimated:NO];
	
}



- (void)takePic 
{
	NSArray *types = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	
	UIImagePickerController *myImagePicker = [[UIImagePickerController alloc] init];
	myImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	myImagePicker.delegate = self;
	myImagePicker.allowsEditing = NO;
	myImagePicker.mediaTypes = types;
	myImagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
	
	[self presentModalViewController:myImagePicker animated:YES];
	
	
}



- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
	NSLog(@"ImagePicker was cancelled.");
	[self dismissModalViewControllerAnimated:YES];
	[picker release];
}



- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"MdeiaPicker was ok.");
	[self dismissModalViewControllerAnimated:YES];
	[picker release];
	
	[zeitfadenService recordMediaWithInfo:info];
}





- (void)actUpponChangedLocation:(NSNotification *)notification
{
	NSLog(@"the recording View did get the Notificaiton ybout the changed location");

	CLLocation *newLocation = [[notification userInfo] objectForKey:@"newLocation"];
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
	MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
	[mapView setRegion:adjustedRegion animated:YES];
	
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
