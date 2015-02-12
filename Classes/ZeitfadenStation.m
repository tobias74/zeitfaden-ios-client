// 
//  ZeitfadenStation.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ZeitfadenStation.h"


@implementation ZeitfadenStation 

@dynamic stationId;
@dynamic startTimezone;
@dynamic publishStatus;
@dynamic endTimezone;
@dynamic endDate;
@dynamic attachmentFile;
@dynamic stationDescription;
@dynamic userId;
@dynamic startLongitude;
@dynamic endLongitude;
@dynamic endLatitude;
@dynamic startDate;
@dynamic startLatitude;
@dynamic assignedToGroups;




- (void)setStartLocation:(CLLocation *)location
{
	[self setValue:[NSNumber numberWithFloat: location.coordinate.latitude] forKey:@"startLatitude"];
	[self setValue:[NSNumber numberWithFloat: location.coordinate.longitude] forKey:@"startLongitude"];
}

- (void)setEndLocation:(CLLocation *)location
{
	[self setValue:[NSNumber numberWithFloat: location.coordinate.latitude] forKey:@"endLatitude"];
	[self setValue:[NSNumber numberWithFloat: location.coordinate.longitude] forKey:@"endLongitude"];
}

- (void)prepareForDeletion
{
	NSLog(@"Inside the ZeitfadenStationManagedObject prepare for deletion.");
	if ([self valueForKey:@"attachmentFile"] != nil)
	{
		NSLog(@"deleting file belonging to done station.");
		NSError *error;
		if (! [[NSFileManager defaultManager] removeItemAtPath:[self valueForKey:@"attachmentFile"] error:&error] )
		{
			NSLog(@"deleteing FAILED");
		}
		else
		{
			NSLog(@"deleteing was successfull");
		}
			
	}
	
}

@end
