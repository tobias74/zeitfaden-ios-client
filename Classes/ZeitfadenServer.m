//
//  ZeitfadenServer.m
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ZeitfadenServer.h"
#import "LoginRequestDelegate.h"
#import "GroupsRequestDelegate.h"
#import "CreateGroupRequestDelgate.h"
#import "JSON.h"
#import "ApplicationMediator.h"


@implementation ZeitfadenServer

@synthesize loginCookie;
@synthesize loginUserEmail;
@synthesize loggedInUserId;


-(ZeitfadenServer *) init
{
	self = [super init];
	
	return self;
}


- (void)resetLoginUserEmail
{
	self.loginUserEmail = @"none";
    self.loggedInUserId = @"none";
}

- (void)updateLoginUserEmail:(NSString *)email
{
	self.loginUserEmail = email;
	
	NSDictionary *info = [NSDictionary dictionaryWithObject:email forKey:@"email"];
	[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEEDED object:self userInfo:info];
}

- (void)updateLoggedInUserId:(NSString *)userId
{
	self.loggedInUserId = userId;
	
	NSDictionary *info = [NSDictionary dictionaryWithObject:userId forKey:@"email"];
	[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCEEDED object:self userInfo:info];
}

- (void) login:(NSString *)email withPassword:(NSString *)password
{
	LoginRequestDelegate *myDelegate = [[LoginRequestDelegate alloc] initWithContext:self];
	
	NSString *url = @"http://livetest.zeitfaden.com/user/login";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	[request setHTTPMethod:@"POST"];
	
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
	
	
	[self appendData:email forParameter:@"email" toPostBody:postBody usingBoundary:stringBoundary];
	[self appendData:password forParameter:@"password" toPostBody:postBody usingBoundary:stringBoundary];

	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody: postBody];
	
	NSURLConnection *conn = [NSURLConnection connectionWithRequest: request delegate:myDelegate];
	[conn retain];
	
}

- (void)logout
{
	NSLog(@"sending logout in srver");
	LoginRequestDelegate *myDelegate = [[LoginRequestDelegate alloc] initWithContext:self];
	
	NSString *url = @"http://livetest.zeitfaden.com/user/logout";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	[request setHTTPMethod:@"POST"];
	
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody: postBody];
	
	NSURLConnection *conn = [NSURLConnection connectionWithRequest: request delegate:myDelegate];
	[conn retain];
	
}

- (BOOL)hasValidLogin
{
	NSLog(@"am asked about login in the serer");
	
	if ([loggedInUserId isEqualToString:@"none"])
	{
		return NO;
	}
	else
	{
		return YES;
	}
}

- (void) createGroup:(NSString *)groupName
{
	CreateGroupRequestDelgate *myDelegate = [[CreateGroupRequestDelgate alloc] initWithContext:self];
	
	NSString *url = @"http://livetest.zeitfaden.com/request.php?controller=group&action=create";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	[request setHTTPMethod:@"POST"];
	
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
	
	
	[self appendData:groupName forParameter:@"description" toPostBody:postBody usingBoundary:stringBoundary];
	
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody: postBody];
	
	NSURLConnection *conn = [NSURLConnection connectionWithRequest: request delegate:myDelegate];
	[conn retain];
	
	
}


- (void) loadGroups
{
	GroupsRequestDelegate *myDelegate = [[GroupsRequestDelegate alloc] initWithContext:self];
	
	NSString *url = @"http://livetest.zeitfaden.com/request.php?controller=group&action=getAll";
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	[request setHTTPMethod:@"POST"];
	
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
	
	
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody: postBody];
	
	NSURLConnection *conn = [NSURLConnection connectionWithRequest: request delegate:myDelegate];
	[conn retain];
	
	
}


- (void)appendData:(NSString *)dataString forParameter:(NSString *)parameterName toPostBody:(NSMutableData *)postBody usingBoundary:(NSString *)stringBoundary
{
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", parameterName] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (BOOL)uploadStation:(id)managedStation
{

	NSString *stationId = [managedStation valueForKey:@"stationId"];
	NSString *actionName = @"";
	
	if ([stationId isEqualToString:@"0"])
	{
		NSLog(@"we have a new station, with id 0 therefore we make new upload!");
		actionName = @"create";
	}
	else 
	{
		NSLog(@"we have a know station!!! yes!!! good!!!! , with id %@ therefore we make new upload!", stationId);
		actionName = @"update";
	}

	NSString *url = [NSString stringWithFormat: @"http://livetest.zeitfaden.com/station/%@", actionName];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	[request setHTTPMethod:@"POST"];
	[request addValue:loginCookie forHTTPHeaderField:@"Cookie"];
	
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
	
	NSNumber *startLatitude = [managedStation valueForKey:@"startLatitude"];
	NSNumber *startLongitude = [managedStation valueForKey:@"startLongitude"];
	NSNumber *endLatitude = [managedStation valueForKey:@"endLatitude"];
	NSNumber *endLongitude = [managedStation valueForKey:@"endLongitude"];
	
	[self appendData:[NSString stringWithFormat:@"%3.15f", [startLatitude floatValue]] forParameter:@"startLatitude" toPostBody:postBody usingBoundary:stringBoundary];
	[self appendData:[NSString stringWithFormat:@"%3.15f", [startLongitude floatValue]] forParameter:@"startLongitude" toPostBody: postBody usingBoundary:stringBoundary];
	[self appendData:[NSString stringWithFormat:@"%3.15f", [endLatitude floatValue]] forParameter:@"endLatitude" toPostBody: postBody usingBoundary:stringBoundary];
	[self appendData:[NSString stringWithFormat:@"%3.15f", [endLongitude floatValue]] forParameter:@"endLongitude" toPostBody: postBody usingBoundary:stringBoundary];
	
	[self appendData:[NSString stringWithFormat:@"%@", [managedStation valueForKey:@"startDate"]] forParameter:@"startDate" toPostBody: postBody usingBoundary:stringBoundary];
	[self appendData:[NSString stringWithFormat:@"%@", [managedStation valueForKey:@"endDate"]] forParameter:@"endDate" toPostBody: postBody usingBoundary:stringBoundary];
	
	[self appendData:[NSString stringWithFormat:@"%@", [managedStation valueForKey:@"startTimezone"]] forParameter:@"startTimezone" toPostBody: postBody usingBoundary:stringBoundary];
	[self appendData:[NSString stringWithFormat:@"%@", [managedStation valueForKey:@"endTimezone"]] forParameter:@"endTimezone" toPostBody: postBody usingBoundary:stringBoundary];


	[self appendData:[NSString stringWithFormat:@"%@", [managedStation valueForKey:@"publishStatus"]] forParameter:@"publishStatus" toPostBody: postBody usingBoundary:stringBoundary];
	

	if (![stationId isEqualToString:@"0"])
	{
		[self appendData:[NSString stringWithFormat:@"%@", [managedStation valueForKey:@"stationId"]] forParameter:@"stationId" toPostBody: postBody usingBoundary:stringBoundary];
	}
	
	
	for (NSManagedObject *group in [managedStation valueForKey:@"assignedToGroups"])
	{
		[self appendData:[NSString stringWithFormat:@"%@", [group valueForKey:@"groupId"]] forParameter:@"groupIds[]" toPostBody: postBody usingBoundary:stringBoundary];
	}
	
	
	NSString *mimeType = [managedStation valueForKey:@"attachmentMimeType"];
	if ( ([mimeType isEqualToString:@"image/jpeg"]) || ([mimeType isEqualToString:@"video/mpeg"]))
	{
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:@"Content-Disposition:form-data; name=\"uploadFile\";filename=\"zeitfaden_attachment.bin\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
		//[postBody appendData:[NSData dataWithData:[managedStation valueForKey:@"attachmentData"] ]];
		NSLog(@"We use filename %@ in the serverthing", [managedStation valueForKey:@"attachmentFile"]);
		[postBody appendData:[NSData dataWithContentsOfFile:[managedStation valueForKey:@"attachmentFile"] ]];
	}
	else 
	{
		NSLog(@"Wedo not have attachment");
	}

	
	
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody: postBody];
	
	
	
	
	
	//NSURLConnection *conn = [NSURLConnection connectionWithRequest: request delegate:self];
	//[conn retain];
	NSError *requestError;
	NSURLResponse *urlResponse = nil;
	
	
	NSLog(@"hort before synchronous connection");
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse: &urlResponse error: &requestError];
	NSLog(@"hort after synchronous connection");

	SBJsonParser *parser = [[SBJsonParser new] autorelease];
	NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"received from Server: %@" , json_string);
	
	NSArray *zf_response = [parser objectWithString:json_string error:nil];
	
	if (zf_response == nil)
	{
		NSLog(@"response was nil");
		return NO;
	}
	else
	{
		
		
		if([zf_response valueForKey:@"stationId"])
		{
			NSLog(@"response was completed ok");
			
			//NSArray *stationJson = [zf_response valueForKey:@"station"];
			
			NSLog(@"StationId is %@", [zf_response valueForKey:@"stationId"]);
			[managedStation setValue:[zf_response valueForKey:@"stationId"] forKey:@"stationId"];

			return YES;
		}
		else
		{
			NSLog(@"response was returrned an error.");
			return NO;
		}
		
		
	}
	
	
	
	
}





@end
