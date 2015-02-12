//
//  PendingUploadsViewController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractZeitfadenViewControllerWithTableViewDelegate.h"


@interface PendingUploadsViewController : AbstractZeitfadenViewControllerWithTableViewDelegate <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, NSFetchedResultsControllerDelegate>
{
	
}



- (IBAction) addTestStation;
- (IBAction) toggleEdit;



@end
