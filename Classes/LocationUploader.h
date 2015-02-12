//
//  LocationUploader.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationMediator.h"
#import <CoreLocation/CoreLocation.h>
#import "PeriodOfTime.h"


@class ZeitfadenService;

@interface LocationUploader : NSObject {

	ZeitfadenService *zeitfadenService;
	NSOperationQueue *queue;
	NSManagedObjectContext *managedObjectContext;
	BOOL uploadingStatus;
	BOOL areThereMore;
	
}

@property BOOL uploadingStatus;
@property BOOL areThereMore;

- (void)startUploading;
- (void)stopUploading;
- (void)initializeUploadQueue;
- (LocationUploader *) initWithService:(ZeitfadenService *)_service;
- (void)enqueueStationForUploading:(NSManagedObject *)zeitfadenStation;


@end
