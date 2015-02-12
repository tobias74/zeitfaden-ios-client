//
//  AbstractRequestDelegate.m
//  zeitfaden
//
//  Created by Tobias Gassmann on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AbstractRequestDelegate.h"
#import "JSON.h"



@implementation AbstractRequestDelegate

@synthesize context;

-(id)initWithContext:(ZeitfadenServer *)_context
{
	self = [super init];
	
	if(nil != self)
	{
		[self setContext:_context];
	}
	
	
	return self;
}




@end
