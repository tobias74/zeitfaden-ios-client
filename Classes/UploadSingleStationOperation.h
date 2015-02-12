//
//  UploadSingleStationOperation.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZeitfadenService;

@interface UploadSingleStationOperation  : NSOperation {
	
	ZeitfadenService *zeitfadenService;
	NSManagedObjectID *stationID;
	NSManagedObjectContext *managedObjectContext;

}

@property (retain) NSManagedObjectID *stationID;
@property (retain) ZeitfadenService *zeitfadenService;


- (UploadSingleStationOperation *) initWithStationID:(NSManagedObjectID *)_stationID useService:(ZeitfadenService *)_service;

@end
