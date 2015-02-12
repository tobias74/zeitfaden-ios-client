//
//  CreateGroupRequestDelgate.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreateGroupRequestDelgate.h"


@implementation CreateGroupRequestDelgate




- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	SBJsonParser *parser = [[SBJsonParser new] autorelease];
	NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"received from Groups-Server: %@" , json_string);
	
	NSArray *responseData = [parser objectWithString:json_string error:nil];
	if (![responseData valueForKey:@"requestCompletedSuccessfully"])
	{
		NSLog(@"request problems");
	}
	else
	{
		NSLog(@"requst complted good!");
		
	}
	
	
	
	
	
	
	//[context setLoginUserEmail:[responseData valueForKey:@"loginUserEmail"]];
	
}



@end
