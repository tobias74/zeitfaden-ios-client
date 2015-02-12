//
//  RecordingViewController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "AbstractZeitfadenViewController.h"

@interface RecordingViewController : AbstractZeitfadenViewController <CLLocationManagerDelegate, MKReverseGeocoderDelegate, MKMapViewDelegate, UIAlertViewDelegate> {

	MKMapView *mapView;
	UIToolbar *toolBar;
	
}

@property (retain) IBOutlet MKMapView *mapView;
@property (retain) IBOutlet UIToolbar *toolBar;

- (void)takePic;
- (void) backButtonTapped;
- (void) popWithTransition: (UIViewAnimationTransition) transition;
- (void)actUpponChangedLocation:(NSNotification *)notification;



@end
