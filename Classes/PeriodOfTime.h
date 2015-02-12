//
//  PeriodOfTime.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PeriodOfTime : NSObject {

	NSDate *startDate;
	NSDate *endDate;
}

@property (retain) NSDate *startDate;
@property (retain) NSDate *endDate;

@end
