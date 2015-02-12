    //
//  LoginViewController.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController

@synthesize emailField;
@synthesize passwordField;


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

	emailField.delegate = self;
	passwordField.delegate = self;

	NSLog(@"viedDidLoad of LoginViewController was called.");
	[emailField setText:[NSString stringWithFormat:@"%@",[zeitfadenService getUserEmail]]] ;
	[passwordField setText:[NSString stringWithFormat:@"%@",[zeitfadenService getUserPassword]]] ;

	[emailField becomeFirstResponder];
 
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void) invokeSendLogin
{
	[self saveLoginData];
	[zeitfadenService sendCurrentLogin];
	NSLog(@"login was sent");
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[self invokeSendLogin];
	return YES;
}

- (IBAction)sendLogin:(id)sender
{
	NSLog(@"login send clicked");
	[self invokeSendLogin];
}


- (void)saveLoginData
{
	
	[zeitfadenService setUserEmail:[NSString stringWithFormat:@"%@",[emailField text]]];
	[zeitfadenService setUserPassword:[NSString stringWithFormat:@"%@",[passwordField text]]];
	
}


- (IBAction)clearLoginData:(id)sender {
	
	emailField.text = [NSString stringWithFormat:@""];
	passwordField.text = [NSString stringWithFormat:@""];
	
	[zeitfadenService setUserEmail:[NSString stringWithFormat:@"%@",[emailField text]]];
	[zeitfadenService setUserPassword:[NSString stringWithFormat:@"%@",[passwordField text]]];
	
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
	[emailField release];
	[passwordField release];
	
    [super dealloc];
}


@end
