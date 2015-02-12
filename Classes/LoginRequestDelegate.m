//
//  LoginRequestDelegate.m
//  zeitfaden
//
//  Created by Tobias Gassmann on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginRequestDelegate.h"

@implementation LoginRequestDelegate



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
	NSHTTPURLResponse *myResponse = (NSHTTPURLResponse *)response;
	NSDictionary *fields = [myResponse allHeaderFields];
	NSString *cookie = [fields valueForKey:@"Set-Cookie"];
	
	NSLog(@"Received cookie: %@", cookie);
	
	[context setLoginCookie:cookie];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	SBJsonParser *parser = [[SBJsonParser new] autorelease];
	NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"received from Login-Server: %@" , json_string);
	
	NSArray *responseData = [parser objectWithString:json_string error:nil];
    
	NSLog(@"after nsarray");
    
	if (![responseData valueForKey:@"loggedInUserId"])
	{
		NSLog(@"no valid loggin.");
		[context resetLoginUserEmail];
	}
	else
	{
		NSLog(@"good login!!trying to update.");
		[context updateLoggedInUserId:[responseData valueForKey:@"loggedInUserId"]];
		NSLog(@"good login!! completed");
	}
	
	
}

@end
