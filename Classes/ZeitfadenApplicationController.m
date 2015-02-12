//
//  ZeitfadenApplicationController.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ZeitfadenApplicationController.h"
#import "InfoViewController.h"
#import "PendingUploadsViewController.h"
#import "RecordingViewController.h"
#import "RecordingSettingsViewController.h"
#import "LoginViewController.h"


@implementation ZeitfadenApplicationController



- (ZeitfadenApplicationController *) init
{
	self = [super init];
	
	viewControllerClasses = [[NSMutableDictionary dictionary] retain];
	viewControllerInstances = [[NSMutableDictionary dictionary] retain];
	viewNibs = [[NSMutableDictionary dictionary] retain];

	
	
	[self addViewControllerClass:@"InfoViewController" withNib:@"InfoView" forView:INFO_VIEW];
	[self addViewControllerClass:@"LoginViewController" withNib:@"LoginView" forView:LOGIN_VIEW];
	[self addViewControllerClass:@"RecordingViewController" withNib:@"RecordingView" forView:RECORDING_VIEW];
	[self addViewControllerClass:@"RecordingSettingsViewController" withNib:@"RecordingSettingsView" forView:RECORDING_SETTINGS_VIEW];
	[self addViewControllerClass:@"PendingUploadsViewController" withNib:@"PendingUploadsView" forView:PENDING_UPLOADS_VIEW];
	
	return self;
}

- (void)addViewControllerClass:(NSString *)className withNib:(NSString*)nibName forView:(NSString*)viewName
{
	[viewControllerClasses setObject:className forKey:viewName];
	[viewNibs setObject:nibName forKey:viewName];
}


- (id <ZeitfadenViewController>)getViewController:(NSString*)viewName preparedWithService:(id)service
{
	id <ZeitfadenViewController> myViewController = [viewControllerInstances objectForKey:viewName];
	
	if (myViewController == nil)
	{
		NSString *nibName = [viewNibs objectForKey:viewName];
		
		Class controllerClass = NSClassFromString([viewControllerClasses objectForKey:viewName]);
		myViewController = [[controllerClass alloc] initWithNibName:nibName bundle:nil serviceFacade:service];
		[viewControllerInstances setObject:myViewController forKey:viewName];
	}
	return myViewController;
}







@end
