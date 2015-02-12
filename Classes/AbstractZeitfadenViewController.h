//
//  AbstractZeitfadenViewController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@protocol ZeitfadenViewController

@end


#import <UIKit/UIKit.h>
#import "ZeitfadenService.h"
#import "ApplicationMediator.h"

@class ZeitfadenService;


@interface AbstractZeitfadenViewController : UIViewController {
	
	ZeitfadenService *zeitfadenService;

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil serviceFacade:(ZeitfadenService*)_service;
- (void)pushController:(UIViewController *) controller withTransition:(UIViewAnimationTransition) transition;
- (void)navigateTo:(NSString *)viewName;


@end
