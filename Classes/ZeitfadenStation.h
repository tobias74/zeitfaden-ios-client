//
//  ZeitfadenStation.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>


@interface ZeitfadenStation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * stationId;
@property (nonatomic, retain) NSString * startTimezone;
@property (nonatomic, retain) NSString * publishStatus;
@property (nonatomic, retain) NSString * endTimezone;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * attachmentFile;
@property (nonatomic, retain) NSString * stationDescription;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * startLongitude;
@property (nonatomic, retain) NSNumber * endLongitude;
@property (nonatomic, retain) NSNumber * endLatitude;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * startLatitude;
@property (nonatomic, retain) NSSet* assignedToGroups;

@end


@interface ZeitfadenStation (CoreDataGeneratedAccessors)
- (void)addAssignedToGroupsObject:(NSManagedObject *)value;
- (void)removeAssignedToGroupsObject:(NSManagedObject *)value;
- (void)addAssignedToGroups:(NSSet *)value;
- (void)removeAssignedToGroups:(NSSet *)value;
- (void)prepareForDeletion;

@end

