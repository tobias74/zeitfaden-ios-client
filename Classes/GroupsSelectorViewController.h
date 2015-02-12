//
//  GroupsSelectorViewController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractZeitfadenViewControllerWithTableViewDelegate.h"


@interface GroupsSelectorViewController : AbstractZeitfadenViewControllerWithTableViewDelegate <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
{

}

- (IBAction)addGroup;


@end

