//
//  HomeViewController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractZeitfadenViewController.h"




@interface HomeViewController : AbstractZeitfadenViewController {
	UIBarButtonItem *loginButton;
}




- (IBAction) myButtonPressed;
- (IBAction) showPendingUploads:(id)sender;
- (IBAction) showRecordingView:(id)sender;
- (IBAction) showInfoView:(id)sender;
- (IBAction) showLoginView;
- (IBAction) showRecordingSettingsView:(id)sender;
- (void) actUpponChangedLogin:(NSNotification *)notification;
- (void) performLogout;



@end















