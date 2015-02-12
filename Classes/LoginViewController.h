//
//  LoginViewController.h
//  ZeitfadenWithCoreData
//
//  Created by Tobias Gassmann on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractZeitfadenViewController.h"

@interface LoginViewController : AbstractZeitfadenViewController <UITextFieldDelegate> 
{
	UITextField *emailField;
	UITextField *passwordField;
}

- (IBAction)sendLogin:(id)sender;
- (void)saveLoginData;
- (IBAction)clearLoginData:(id)sender;
- (void) invokeSendLogin;
	
@property (retain) IBOutlet UITextField *emailField;
@property (retain) IBOutlet UITextField *passwordField;
	
@end
