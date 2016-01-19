//
//  NewViewController.m
//  DkLogin
//
//  Created by Sreeji Gopal on 18/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import "NewViewController.h"
#import "TextFieldValidator.h"



#define REGEX_USER_NAME_LIMIT @"^.{1,20}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"


@interface NewViewController ()<UITextFieldDelegate>{
    IBOutlet TextFieldValidator *txtEmail;
    IBOutlet TextFieldValidator *txtFirstName;
    IBOutlet TextFieldValidator *txtLastName;
    IBOutlet TextFieldValidator *txtPassword;
    IBOutlet TextFieldValidator *txtMobile;
    IBOutlet TextFieldValidator *txtGovtID;
}

@end

@implementation NewViewController;

@synthesize txtEmail;
@synthesize tapGesture;
@synthesize txtFirstName;
@synthesize txtLastName;
@synthesize txtGovtID;
@synthesize txtPassword;
@synthesize txtMobile;

- (void)viewDidLoad {
    [super viewDidLoad];
    [txtEmail becomeFirstResponder];
    [txtEmail addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    txtEmail.validateOnResign=NO;
    [txtPassword addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [txtPassword addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
    txtPassword.validateOnResign=NO;
    
    // Do any additional setup after loading the view.
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    self.txtFirstName.delegate = self;
    self.txtLastName.delegate = self;
    self.txtMobile.delegate = self;
    self.txtGovtID.delegate = self;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.enabled = NO;
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];

    [self.view addGestureRecognizer:tapGesture];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"Key Pressed");
    //[txtEmail resignFirstResponder];
    [textField resignFirstResponder];
    return TRUE;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    tapGesture.enabled = YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tapGesture = textField;
}

//Implement resignOnTap:


-(void)hideKeyboard
{
    [[self view] endEditing:YES];
    tapGesture.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnRegisterUser:(id)sender {
    
    NSLog(@"Clicked Register User");
    [self registerNewUser:@"sreeji.gopal@gmail.com" :@"sreeji"];
}

//This will validate user (email or phone) and store in ManagedContext.
-(void) registerNewUser:(NSString *) userEmailorPhone:(NSString *) password{
    
    NSString *urlRest = @"http://mydrunkcart/index.php?route=module/apps/addcustomer/";
    
    NSString *postData=[NSString stringWithFormat:@"device=iOS&email=%@&password=%@&firstname=%@lastname=%@mobile=%@govtid=%@",txtEmail.text,txtPassword.text,txtFirstName.text,txtLastName.text,txtMobile.text,txtGovtID.text];

    [self placeGetRequest:urlRest:postData withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // your code
        _responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSLog(@"Value for Json Data %@", _responseData);
        
        if(_responseData != NULL){
            NSLog(@"Response data is not null");
            
            NSDictionary* jsonUser = nil;
            if (_responseData) {
                jsonUser = [NSJSONSerialization
                            JSONObjectWithData:data
                            options:kNilOptions
                            error:nil];
            }
            
            jsonUser = [jsonUser objectForKey:@"data"];
            NSLog(@"Data value %lu", [jsonUser count]);
            
            if([[jsonUser objectForKey:@"customer_id"]  isEqual: @""]){
                NSLog(@"User Details not found due to %@", [jsonUser objectForKey:@"customer_id"]);
            }else{
                NSLog(@"Customer Created with customer id %@", [jsonUser objectForKey:@"customer_id"]);
            }
        
            //results = [Data valueForKey:@"data"];
            //NSLog(@"Count %ld", [results count]);
        }else{
            NSLog(@"No data found for the");
        }
        
    }];
    
    
}

-(void)placeGetRequest:(NSString *)restURL:(NSString *)action withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))ourBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@&%@", restURL, action];
    //NSString *urlString = [NSString stringWithFormat:@"http://mydrunkcart/index.php?route=module/apps/validate/"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:ourBlock] resume];
}


@end
