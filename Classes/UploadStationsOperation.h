//
//  UploadStationsOperation.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZeitfadenService;

@interface UploadStationsOperation : NSOperation <NSFetchedResultsControllerDelegate> {
	ZeitfadenService *zeitfadenService;
	
	
@private
    NSManagedObjectContext *managedObjectContext_;
	
}

@property (retain) ZeitfadenService *zeitfadenService;

@end