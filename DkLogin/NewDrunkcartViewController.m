//
//  NewDrunkcartViewController.m
//  DkLogin
//
//  Created by Sreeji Gopal on 12/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import "NewDrunkcartViewController.h"
#import "TextFieldValidator.h"
#import "LoginViewController.h"


#define REGEX_USER_NAME_LIMIT @"^.{1,20}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface NewDrunkcartViewController ()<UITextFieldDelegate>{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    IBOutlet TextFieldValidator *txtEmail;
}
@end



@implementation NewDrunkcartViewController

@synthesize txtEmail;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(btnRegister:)];
    
    //self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackBtn.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;    // Do any additional setup after loading the view.
    [txtEmail becomeFirstResponder];
    txtEmail.validateOnResign=NO;
    
    [txtEmail addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    [self->locationManager requestWhenInUseAuthorization];  // For foreground access
    [self->locationManager requestAlwaysAuthorization]; // For background access
    
    
}


-(BOOL)textFieldShouldReturn:(TextFieldValidator *)textField
{
    NSLog(@"Return");
    [txtEmail resignFirstResponder];
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    
    
          //newLocation.coordinate.latitude);
    NSLog(@"Latitude %f",newLocation.coordinate.latitude);
    NSLog(@"Latitude %f",newLocation.coordinate.latitude);
    //locationLabelTwo=newLocation.coordinate.longitude;
    geocoder = [[CLGeocoder alloc] init];
    
    
    [locationManager stopUpdatingLocation];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSString *get = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                             placemark.subThoroughfare, placemark.thoroughfare,
                             placemark.postalCode, placemark.locality,
                             placemark.administrativeArea,
                             placemark.country];
            NSLog(@"State -: %@", placemark.administrativeArea);
            NSLog(@"Country -: %@", placemark.country);
            
            txtEmail.text = placemark.country;
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    NSLog(@"%@",placemark);
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

- (IBAction)newTextTabRecognizer:(id)sender {
     NSLog(@"Tab Recog");
    [self.view endEditing:YES];
//     [txtEmail resignFirstResponder];
}

- (IBAction)btnBack:(id)sender {
    NSLog(@"Back Button");
   

}

- (IBAction)btnRegister:(id)sender {
     NSLog(@"Error");
    LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginStoryBoard"];
    [self.navigationController pushViewController:loginView animated:YES];
    if([txtEmail validate]){
        NSLog(@"Error");
    }
}
@end
