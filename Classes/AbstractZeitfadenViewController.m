    //
//  AbstractZeitfadenViewController.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "AbstractZeitfadenViewController.h"
#import "ModalAlert.h"


@implementation AbstractZeitfadenViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil serviceFacade:(ZeitfadenService*)_service
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		zeitfadenService = _service;
		NSLog(@"init set the zeitfadenService int he abstract thing.");
    }
    return self;
}

- (void)pushController:(UIViewController *) controller withTransition:(UIViewAnimationTransition) transition
{
    [UIView beginAnimations:nil context:NULL];
    [self.navigationController pushViewController:controller animated:NO];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationBeginsFromCurrentState:YES];        
    [UIView setAnimationTransition:transition forView:self.navigationController.view cache:YES];
    [UIView commitAnimations];	
	
}

- (void)navigateTo:(NSString *)viewName
{
	NSLog(@"inside navigateTo viewName: %@", viewName);
	id <ZeitfadenViewController> viewController = [zeitfadenService getViewController:viewName];
	NSLog(@"inside navigateTo2");
	[self pushController:viewController withTransition:UIViewAnimationTransitionCurlUp];
	NSLog(@"inside navigateTo3");
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
}


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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
