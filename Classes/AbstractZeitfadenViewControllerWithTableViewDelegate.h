//
//  AbstractZeitfadenViewControllerWithTableViewDelegate.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractZeitfadenViewController.h"


@interface AbstractZeitfadenViewControllerWithTableViewDelegate : AbstractZeitfadenViewController
{

	UITableView *tableView;
	
@protected	
	NSFetchedResultsController *_fetchedResultsController;
	NSUInteger sectionInsertCount;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;


@end
