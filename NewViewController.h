//
//  NewViewController.h
//  DkLogin
//
//  Created by Sreeji Gopal on 18/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDataDelegate>{
    NSMutableData *_responseData;
    
}
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
@property (strong, nonatomic) IBOutlet UITextField *txtGovtID;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
- (IBAction)btnRegisterUser:(id)sender;


@end
