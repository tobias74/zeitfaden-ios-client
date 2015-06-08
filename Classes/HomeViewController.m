    //
//  HomeViewController.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "ModalAlert.h"
#import "ZeitfadenApplicationController.h"


@implementation HomeViewController


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
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	loginButton = [[UIBarButtonItem alloc] initWithTitle:@"login" style:UIBarButtonItemStyleBordered target:self action:@selector(showLoginView)];
	//	[loginButton setTarget:self];
	//	[loginButton setAction:@selector(toggleEdit)];
	self.navigationItem.leftBarButtonItem = loginButton;
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actUpponChangedLogin:) name:LOGIN_SUCCEEDED object:nil];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)showLoginButton
{
	[loginButton setTarget:self];
	[loginButton setAction:@selector(showLoginView)];
	[loginButton setTitle:@"Login"];
}

- (void)showLogoutButton
{
	[loginButton setTarget:self];
	[loginButton setAction:@selector(performLogout)];
	[loginButton setTitle:@"Logout"];
}


- (void)performLogout
{
	[zeitfadenService logout];
}

- (void) actUpponChangedLogin:(NSNotification *)notification
{
	//NSString *email = [[notification userInfo] objectForKey:@"email"];
	NSLog(@"did get the notivfcation of the login changed thing");
	if ([zeitfadenService hasValidLogin])
	{
		[self showLogoutButton];
	}
	else 
	{
		[self showLoginButton];
	}

	
}


- (IBAction)createGroup:(id)sender
{
	NSString *groupName = [ModalAlert ask:@"Name for the new group" withTextPrompt:@"Group Name"];
	NSLog(@"entered groupName %@", groupName);
	
	[zeitfadenService createGroup:groupName];
	
}



- (IBAction)showPendingUploads:(id)sender
{
	[self navigateTo:PENDING_UPLOADS_VIEW];
}

- (IBAction) showRecordingSettingsView:(id)sender
{
	[self navigateTo:RECORDING_SETTINGS_VIEW];
}


- (IBAction)showRecordingView:(id)sender
{
	[self navigateTo:RECORDING_VIEW];
}

- (IBAction)showInfoView:(id)sender
{
	[self navigateTo:INFO_VIEW];
}

- (IBAction)showLoginView
{
	[self navigateTo:LOGIN_VIEW];
}



- (IBAction)myButtonPressed
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Home View Button Pressed" message:@"You pressed it yeah" delegate:nil cancelButtonTitle:@"Yep I did" otherButtonTitles: nil];
	[alert show];
	[alert release];
	
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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}


@end
