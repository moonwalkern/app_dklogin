//
//  LoginViewController.h
//  DkLogin
//
//  Created by Sreeji Gopal on 29/12/15.
//  Copyright © 2015 Sreeji Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <NSURLConnectionDataDelegate>{
    NSMutableData *_responseData;
    IBOutlet UIActivityIndicatorView *activityInd;
    BOOL checked;
}


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSMutableArray *userArray;


@property (strong, nonatomic) IBOutlet UITextField *txtUser;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnNewDrunkcart;
@property (strong, nonatomic) IBOutlet UISwitch *switchCondition;
@property (strong, nonatomic) IBOutlet UIButton *checkBox;
- (IBAction)checkBox:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture;



@end
