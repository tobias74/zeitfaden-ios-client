//
//  RecordingSettingsViewController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractZeitfadenViewController.h"

@class GroupsSelectorViewController;
@class PublishStatusSelectorViewController;

@interface RecordingSettingsViewController : AbstractZeitfadenViewController  
{
	GroupsSelectorViewController *groupsSelectorViewController;
    PublishStatusSelectorViewController *publishStatusSelectorViewController;
	UILabel *distanceSliderLabel;
	UISlider *distanceSlider;
	UISwitch *recordingStatus;
	UISwitch *uploadingStatus;

}

@property (retain) IBOutlet UILabel *distanceSliderLabel;
@property (retain) IBOutlet UISlider *distanceSlider;
@property (retain) IBOutlet UISwitch *recordingStatus;
@property (retain) IBOutlet UISwitch *uploadingStatus;


@property (retain) GroupsSelectorViewController *groupsSelectorViewController;
@property (retain) PublishStatusSelectorViewController *publishStatusSelectorViewController;



- (IBAction)showGroupsSelectorView:(id)sender;
- (IBAction)showPublishStatusSelectorView:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)sliderUp:(id)sender;
- (IBAction)recordingSwitchChanged:(id)sender;
- (IBAction)uploadingSwitchChanged:(id)sender;


@end
