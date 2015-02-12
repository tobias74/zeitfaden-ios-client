//
//  ZeitfadenServer.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZeitfadenServer : NSObject {
	
	NSString *loginCookie;
	NSString *loginUserEmail;
	NSString *loggedInUserId;
	
}


- (void)appendData:(NSString *)dataString forParameter:(NSString *)parameterName toPostBody:(NSMutableData *)postBody usingBoundary:(NSString *)stringBoundary;
- (BOOL)uploadStation:(id)managedStation;
- (void)login:(NSString *)email withPassword:(NSString *)password;
- (void)loadGroups;
- (void)createGroup:(NSString *)groupName;
- (void)logout;
- (BOOL)hasValidLogin;
- (void)updateLoginUserEmail:(NSString *)email;
- (void)updateLoggedInUserId:(NSString *)userId;
- (void)resetLoginUserEmail;

@property (retain) NSString *loginCookie;
@property (retain) NSString *loginUserEmail;
@property (retain) NSString *loggedInUserId;

@end
