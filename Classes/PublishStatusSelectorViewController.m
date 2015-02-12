//
//  PublishStatusSelectorViewController.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PublishStatusSelectorViewController.h"


@implementation PublishStatusSelectorViewController
@synthesize publishStatusPicker;
@synthesize publishStatuses;

- (IBAction)buttonPressed
{
    NSInteger row = [publishStatusPicker selectedRowInComponent:0];
    NSString *selected = [publishStatuses objectAtIndex:row];
    NSString *title = [[NSString alloc] initWithFormat:@"You selected %@!", selected];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"Thank you for choosing." delegate:nil cancelButtonTitle:@"done." otherButtonTitles:nil];
    
    [zeitfadenService setPublishStatusForRecording:selected];
    
    [alert show];
    [alert release];
    [title release];
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [publishStatuses count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [publishStatuses objectAtIndex:row];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [publishStatusPicker release];
    [publishStatuses release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"public", @"private", @"googlable", nil];
    self.publishStatuses = array;
    [array release];
}

- (void)viewDidUnload
{
    self.publishStatusPicker = nil;
    self.publishStatuses = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
