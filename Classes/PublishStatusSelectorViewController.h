//
//  PublishStatusSelectorViewController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractZeitfadenViewController.h"


@interface PublishStatusSelectorViewController : AbstractZeitfadenViewController {
    UIPickerView *publishStatusPicker;
    NSArray *publishStatuses;
 
}

@property (retain) IBOutlet UIPickerView *publishStatusPicker;
@property (retain) NSArray *publishStatuses;

-(IBAction)buttonPressed; 

@end
