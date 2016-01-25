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
    userDict[@"user"] = @"Sreeji.Gopal@gmail.com";
    userDict[@"data"] = @"yes";
    [[CoreDataManager sharedManager]createEntityWithClassName:@"User" attributesDictionary:userDict];
    
    [[CoreDataManager sharedManager]saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
        if(error != nil){
            NSLog(@"Saved");
        }else{
            NSLog(@"Save error %@",error);
        }
        
    }];
    
    NSArray *sort = @[@"user"];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"user == %@", @"sreeji.gopal@gmail.com" ];
    
    //[[CoreDataManager sharedManager]fetchEntitiesWithClassName:@"User" sortDescriptors:sort sectionNameKeyPath:nil predicate:predicate];
    
    NSArray *fetchedUserData = [[CoreDataManager sharedManager]fetchAllEntityWithClassName:@"User"];
    User *userData = fetchedUserData;
    
//    for (NSManagedObject *user in fetchedUserData) {
//        [[CoreDataManager sharedManager]deleteEntity:user];
//    }
    
    // display all objects
    for (User *event in fetchedUserData) {
        NSLog(@"%@ -- Data %@", [event.user description], [event.data description]);
        
    }
    
    //[[GlobalData sharedGlobalData]printArrayData:fetchedUserData];
    
    fetchedUserData = [[CoreDataManager sharedManager]fetchPredicateEntityWithClassName:@"User" :@"user" :@"Sreeji.Gopal@hotmail.com"];
    // display all objects
    for (User *event in fetchedUserData) {
        NSLog(@"%@ -- Data %@", [event.user description], [event.data description]);
        
    }
    
    [[CoreDataManager sharedManager]deleteEntity:fetchedUserData ];
    
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
//    UIStoryboard *newDrunkcartStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [newDrunkcartStoryBoard instantiateViewControllerWithIdentifier:@"NewDrunkardViewController"];
//    [self presentViewController:vc animated:true completion:nil];
    NewDrunkcartViewController *newDrunkcartView = [self.storyboard instantiateViewControllerWithIdentifier:@"NewToRegisterStoryBoard"];
    [self.navigationController pushViewController:newDrunkcartView animated:YES];
    
}



-(void)validateUserAndLoad :(NSString*) userEmailorPhone :(NSString*) password{
    NSString *urlRest = @"http://mydrunkcart/index.php?route=module/apps/validate/";
    NSString *postData=[NSString stringWithFormat:@"device=iOS&email=%@&password=%@",userEmailorPhone,password];
    NSDictionary* jsonUser = nil;
    jsonUser = [[GlobalData sharedGlobalData] requestSynchronousData:urlRest :postData :@"POST"];
    
    NSLog(@"User Data: %@", jsonUser);
    
    if(jsonUser != NULL){
        if([[jsonUser objectForKey:@"status"]  isEqual: 0]){
            NSLog(@"User Details not found due to %@", [jsonUser objectForKey:@"message"]);
    }else{
        NSLog(@"User Found Proceed");
        [self addUserData:userEmailorPhone:jsonUser];

    }
    }else{
        NSLog(@"No data found for the");
    }
    
}


-(void)addUserData:(NSString *) user:(NSDictionary *) data{
    
    
    
}

-(BOOL)validateCoreDataDuplicates:(NSString *) userName{
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    BOOL unique = YES;
    NSError  *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:request error:&error];
    if(items.count > 0){
        for(User *thisUser in items){
            if([thisUser.user isEqualToString: userName]){
                NSLog(@"User from core data %@ User as input %@",thisUser.user,userName );
                unique = NO;
                return unique;
            }
        }
    }
    NSLog(@"bool %s", unique ? "true" : "false");
    return unique;
}


-(void)deleteCoreData{
    NSManagedObjectContext *context = _managedObjectContext;
    NSFetchRequest * allMovies = [[NSFetchRequest alloc] init];
    [allMovies setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    [allMovies setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * movies = [context executeFetchRequest:allMovies error:&error];
    //error handling goes here
    for (NSManagedObject * movie in movies) {
        [context deleteObject:movie];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}


-(void)fetchUserDetails:(NSString *) user {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *userData = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    [request setEntity:userData];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"user" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDesc, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    [self setUserArray:mutableFetchResults];
    NSLog(@"there are %u in the user array",[userArray count]);
    
    
}

-(void)placeGetRequest:(NSString *)action withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))ourBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@&%@", @"http://mydrunkcart/index.php?route=module/apps/validate/", action];
    //NSString *urlString = [NSString stringWithFormat:@"http://mydrunkcart/index.php?route=module/apps/validate/"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:ourBlock] resume];
}


//Depericated GET Call
-(void)getREST:(NSString *) urlREST:(NSString *)prams {
    
    NSLog(@"Calling GET REST Service Start");
    
    NSString *urlWithParams = [NSString stringWithFormat:@"%@%@",urlREST,prams];
    
    NSURL *url = [NSURL URLWithString:urlWithParams];
    
    NSLog(@"Calling The URL: %@ ", urlWithParams);
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *res, NSData *data, NSError *conError)
     {
         if(data.length >0 && conError == nil){
             [_responseData appendData:data];
             NSLog(@"Connection Success");
             Data = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"Json Data %@", Data);
             
         }else{
             NSLog(@"Error in connection");
         }
         
     }];
    NSLog(@"Calling GET REST Service End");
}


-(void)postREST:(NSString *) urlREST:(NSString *)postData {
    NSLog(@"Calling REST Post Service");
    
    NSLog(@"Calling The URL: %@ ", urlREST);
    
    
    NSMutableArray *responseData = [[NSMutableArray alloc]init];
    NSString *strurl= urlREST;
    
    NSString *strpostlength=[NSString stringWithFormat:@"%lu",(unsigned long) postData.length];
    
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    
    [urlrequest setURL:[NSURL URLWithString:strurl]];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setValue:strpostlength forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*
     
     [NSURLConnection sendAsynchronousRequest:urlrequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
     if(data.length >0 && error == nil){
     NSLog(@"Connection Success");
     Data = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
     
     //NSLog(@"Json Data %@", responseData);
     NSLog(@"%@", Data);
     
     }else{
     NSLog(@"Error in connection");
     }
     
     }];
     */
    activityInd.hidden = NO;
    [activityInd startAnimating];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlrequest delegate:self];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    //_responseData = [[NSMutableData alloc] init];
    activityInd.hidden = NO;
    [activityInd startAnimating];
    NSLog(@"Connection Called didReceiveResponse");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    //[self buildCategorySections:data];
    //NSLog(@"Connection Called didReceiveData %@...", data);
        if(_responseData.length >0 ){
            NSLog(@"Connection Success");
            Data = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:NULL];
    
            NSLog(@" User Data %@", Data);
    
        }else{
            NSLog(@"Error in connection");
        }
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    NSLog(@"Connection Called cachedResponse");
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theconnection {
    [activityInd stopAnimating];
    activityInd.hidden = YES;
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    //NSLog(@"Connection Called connectionDidFinishLoading %@",_responseData);
//    if(_responseData.length >0 ){
//        NSLog(@"Connection Success");
//        Data = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:NULL];
//        //categData = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:nil];
//        //NSLog(@"Json Dict %@", categData);
//        //self.names = categData;
//        //NSArray *array = [[_names allKeys] sortedArrayUsingSelector:@selector(compare:)];
//        //self.keys = array;
//        
//        NSLog(@"%@", Data);
//        [self.tableView reloadData];
//        
//    }else{
//        NSLog(@"Error in connection");
//    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
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

@end
