//
//  ZeitfadenApplicationController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#define INFO_VIEW @"Info_View"
#define PENDING_UPLOADS_VIEW @"Pending_Uploads_View"
#define RECORDING_VIEW @"Recording_View"
#define RECORDING_SETTINGS_VIEW @"Recording_Settings_View"
#define LOGIN_VIEW @"Login_View"


#import <Foundation/Foundation.h>
#import "AbstractZeitfadenViewController.h"


@interface ZeitfadenApplicationController : NSObject {

	
	NSMutableDictionary *viewControllerClasses;
	NSMutableDictionary *viewControllerInstances;
	NSMutableDictionary *viewNibs;

	
}

- (void)addViewControllerClass:(NSString *)className withNib:(NSString*)nibName forView:(NSString*)viewName;
- (id <ZeitfadenViewController>)getViewController:(NSString*)viewName preparedWithService:(id)service;


@end
