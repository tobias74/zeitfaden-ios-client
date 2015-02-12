//
//  LocationAnnotation.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationAnnotation.h"


@implementation LocationAnnotation

@synthesize coordinate = _coordinate;

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
	return [[[[self class] alloc] initWithCoordinate:coordinate] autorelease];
}


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
	self = [super init];
	if (nil != self)
	{
		self.coordinate = coordinate;
	}
	
	return self;
}

@end
