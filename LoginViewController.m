//
//  LoginViewController.m
//  DkLogin
//
//  Created by Sreeji Gopal on 29/12/15.
//  Copyright © 2015 Sreeji Gopal. All rights reserved.
//

#import "LoginViewController.h"
#import "TextFieldValidator.h"
#import "DkAppDelegate.h"
#import "User+CoreDataProperties.h"
#import "NewDrunkcartViewController.h"
#import "GlobalData.h"
#import "CoreDataManager.h"
#import "UserDetails.h"
#import "MainViewViewController.h"
#import "SWRevealViewController.h"


#define REGEX_USER_NAME_LIMIT @"^.{1,20}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"


@interface LoginViewController ()<UITextFieldDelegate>{
    IBOutlet TextFieldValidator *txtUser;
    IBOutlet TextFieldValidator *txtPassword;
    NSMutableArray *Data;
}

@end



@implementation LoginViewController;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize userArray;


@synthesize txtUser;
@synthesize txtPassword;
@synthesize btnNewDrunkcart;
@synthesize btnLogin;
@synthesize checkBox;
@synthesize tabGesture;

- (void)viewDidLoad {
    

    [super viewDidLoad];
    activityInd.hidden = YES;
    [txtUser becomeFirstResponder];
    txtUser.validateOnResign=NO;
    self.txtUser.delegate = self;
    self.txtPassword.delegate = self;
    checked = NO;
    // Do any additional setup after loading the view.
    NSLog(@"%@",[GlobalData sharedGlobalData].message);
    
    
    
    NSLog(@"Data value %@", [[GlobalData sharedGlobalData] webServiceHostName]);

    
//    [txtUser addRegx:REGEX_USER_NAME_LIMIT withMsg:@"User name cannot be blank."];
//    [txtUser addRegx:REGEX_USER_NAME withMsg:@"Only alpha numeric characters are allowed."];
    //[[GlobalData sharedGlobalData]getPostData];
    //Validate TextFields
    [txtUser addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    [txtPassword addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password characters limit should be come between 6-20"];
    [txtPassword addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
    //End
    
    _responseData = [[NSMutableData alloc] init];
    Data = [[NSMutableData alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc]init];
    userDict[@"username"] = @"sreeji.gopal@gmail.com";
    userDict[@"ipaddress"] = @"yes";
    [[CoreDataManager sharedManager]createEntityWithClassName:@"User" attributesDictionary:userDict];
    
    [[CoreDataManager sharedManager]saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
        if(error != nil){
            NSLog(@"Saved");
        }else{
            NSLog(@"Save error %@",error);
        }
        
    }];
    
    //NSLog(@"SHA1 %@",[[GlobalData sharedGlobalData]sha1:@"Hello World"]);
    
    
    
    
    
    NSArray *sort = @[@"user"];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"username == %@", @"sreeji.gopal@gmail.com" ];
    
    //[[CoreDataManager sharedManager]fetchEntitiesWithClassName:@"User" sortDescriptors:sort sectionNameKeyPath:nil predicate:predicate];
    
    NSArray *fetchedUserData = [[CoreDataManager sharedManager]fetchAllEntityWithClassName:@"User"];
    User *userData = fetchedUserData;
    
    for (NSManagedObject *user in fetchedUserData) {
        //[[CoreDataManager sharedManager]deleteEntity:user];
    }
    
    // display all objects
    for (User *event in fetchedUserData) {
        NSLog(@"%@ -- Data %@", [event.username description], [event.ipaddress description]);
        
    }
    
    //[[GlobalData sharedGlobalData]printArrayData:fetchedUserData];
    
    fetchedUserData = [[CoreDataManager sharedManager]fetchPredicateEntityWithClassName:@"User" :@"username" :@"Sreeji.Gopal@hotmail.com"];
    // display all objects
    for (User *event in fetchedUserData) {
        NSLog(@"%@ -- Data %@", [event.username description], [event.ipaddress description]);
        
    }
    
    //[[CoreDataManager sharedManager]deleteEntity:fetchedUserData ];
    
    NSLog(@"IP -:%@",[[GlobalData sharedGlobalData]getIPAddress]);
    
    //UISwitch *mySwitch = [UISwitch new];
    //mySwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    tabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    tabGesture.enabled = NO;
    [self.view addGestureRecognizer:tabGesture];
    
    
    
    

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
- (IBAction)btnLogin:(UIButton *)sender {
    
    NSLog(@"Login using the credentials %@ ", txtUser.text);
    
    if([txtUser validate] & [txtPassword validate]){
        NSString *user = txtUser.text;
        NSString *password = txtPassword.text;
        NSLog(@"Text fields are validated procceding further");
        if(!checked){
            [self showAlert:@"Info" :@"You missed accepting terms and condition!"];
            return;
        }
        [self validateUserAndLoad:user :password];
        
    }else{
        NSLog(@"Please fillin the credentials");
        
        [txtUser becomeFirstResponder];
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Key Pressed");
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    tabGesture.enabled = YES;
    return YES;
}

-(void)hideKeyboard
{
    [txtUser resignFirstResponder];
    [txtPassword resignFirstResponder];
    tabGesture.enabled = NO;
}

- (IBAction)btnNewDrunkcart:(UIButton *)sender {
    NSLog(@"New to Drunkcart");
     [[GlobalData sharedGlobalData] getPostData];
    UIStoryboard *newDrunkcartStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [newDrunkcartStoryBoard instantiateViewControllerWithIdentifier:@"NewToRegisterStoryBoard"];
    [self presentViewController:vc animated:true completion:nil];
//    SWRevealViewController *rearDrunkcartView = [self.storyboard instantiateViewControllerWithIdentifier:@"RearViewStoryBoard"];
//    [self.navigationController pushViewController:rearDrunkcartView animated:NO];
//    MainViewViewController *mainDrunkcartView = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewStoryBoard"];
//    [self.navigationController pushViewController:mainDrunkcartView animated:YES];
    
    
}



-(BOOL)validateUserAndLoad :(NSString*) userEmailorPhone :(NSString*) password{
    NSString *urlRest = @"http://mydrunkcart/index.php?route=module/apps/validate/";
    NSString *postData=[NSString stringWithFormat:@"device=iOS&email=%@&password=%@",userEmailorPhone,password];
    NSDictionary *jsonUser = [[NSDictionary alloc]init];
    
    
    
    //Check of core data exist for the given username, if no fetch the data from WS else load it back from core data and exit this method
    NSArray *fetchUserData  = [self readUserData:userEmailorPhone];
    
    if([fetchUserData count] < 0){
        UserDetails *userDetails = fetchUserData[0];
        
        NSLog(@"[userDetails.userdata description] %@",[userDetails.userdata description]);
        NSError *jsonError = nil;
        NSArray *arr =
        [NSJSONSerialization JSONObjectWithData:[[userDetails.userdata description] dataUsingEncoding:NSUTF8StringEncoding]
                                        options:NSJSONReadingMutableContainers
                                            error:&jsonError];

        jsonUser = arr;
        jsonUser = [jsonUser objectForKey:@"data"];
        NSLog(@"Error %@",jsonError);
  
        NSLog(@"User data fetched from core data %@", jsonUser);
        
        //Check for password match from the json data fetched from core data.
        NSString *salt = [jsonUser objectForKey:@"salt"];
        NSString *passwordCoreData = [jsonUser objectForKey:@"password"];
        NSString *passwordEncrypted = [[GlobalData sharedGlobalData]buildPassword:salt:password];
        
        NSLog(@"Password From CoreData %@ Password Encrypted %@", passwordCoreData, passwordEncrypted);

        if ([passwordCoreData isEqualToString:passwordEncrypted]) {
            NSLog(@"Password good, lets proceed with shopping");
        }else{
            NSLog(@"Wrong Password good, please retry");
            [self showAlert:@"Info" :@"Incorrect username or password!"];
            return NO;

        }
        
    }else{
        NSLog(@"NonExisting user in the coredata");
        jsonUser = [[GlobalData sharedGlobalData] requestSynchronousData:urlRest :postData :@"POST"];
        NSLog(@"User Data: %@", jsonUser);
        
        if(jsonUser != NULL){
            if([[jsonUser objectForKey:@"status"]  isEqual: 0]){
                NSLog(@"User Details not found due to %@", [jsonUser objectForKey:@"message"]);
                [self showAlert:@"Info" :@"Incorrect username or password!"];
                return NO;
            }else{
                NSLog(@"User Found Proceed");
                [self addUserData:userEmailorPhone:password:jsonUser];
                [self readUserData:userEmailorPhone];
                
            }
        }else{
            NSLog(@"No data found for the");
        }
    }
    
    
    
    
    return YES;
}


-(void)addUserData: (NSString *)username :(NSString *) password :(NSDictionary *) data{
 
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&err];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
   
    
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc]init];
    userDict[@"username"] = username;
    userDict[@"userdata"] = myString;
    userDict[@"timestamp"] = [NSDate date];
    [[CoreDataManager sharedManager]createEntityWithClassName:@"UserDetails" attributesDictionary:userDict];
    
    
    userDict = [[NSMutableDictionary alloc]init];
    userDict[@"username"] = username;
    userDict[@"password"] = password;
    userDict[@"ipaddress"] = [[GlobalData sharedGlobalData]getIPAddress];
    userDict[@"loggedin"] = @YES;
    userDict[@"timestamp"] = [NSDate date];
    [[CoreDataManager sharedManager]createEntityWithClassName:@"User" attributesDictionary:userDict];

    
    [[CoreDataManager sharedManager]saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
        if(error != nil){
            NSLog(@"Saved");
        }else{
            NSLog(@"Save error %@",error);
        }
        
    }];

    
}


-(NSArray*)readUserData :(NSString *)username {

    NSArray *fetchedUserData = [[CoreDataManager sharedManager]fetchPredicateEntityWithClassName:@"UserDetails" :@"username" :username];
    // display all objects
    for (UserDetails *userdetails in fetchedUserData) {
        NSLog(@"User nane %@ -- IPAddress %@ -- Date %@ ", [userdetails.username description], [userdetails.userdata description], [userdetails.timestamp description]);
        
    }
    return fetchedUserData;
}



- (IBAction)checkBox:(id)sender {
    if(!checked){
        [checkBox setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateNormal];
        checked = YES;
    }else{
        [checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        checked = NO;
    }
}

- (IBAction)newTabRecognizer:(id)sender {
    [self.view endEditing:YES];
}

-(void)showAlert:(NSString *) title:(NSString *)messageText{
    UIAlertView* alert;
    alert = [[UIAlertView alloc] initWithTitle:title message:messageText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    //[alert release];
}

-(void)showActivityIndicator{
    UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setFrame:CGRectMake(0, 0, 16, 16)];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView startAnimating];
}

@end
