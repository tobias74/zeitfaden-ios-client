//
//  AbstractRequestDelegate.h
//  zeitfaden
//
//  Created by Tobias Gassmann on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZeitfadenServer.h"
#import "JSON.h"


@interface AbstractRequestDelegate : NSObject {
	
	ZeitfadenServer *context;
	
	
}

-(id)initWithContext:(ZeitfadenServer *)_context;
-(void)setContext:(ZeitfadenServer *)_context;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;


@property (retain) ZeitfadenServer *context;

@end
