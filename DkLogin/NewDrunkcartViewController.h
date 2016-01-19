//
//  NewDrunkcartViewController.h
//  DkLogin
//
//  Created by Sreeji Gopal on 12/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NewDrunkcartViewController : UIViewController{
    CLLocationManager *locationManager;
    
}



@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *drunkTapGesture;

@end
