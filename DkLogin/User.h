//
//  User.h
//  DkLogin
//
//  Created by Sreeji Gopal on 05/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
