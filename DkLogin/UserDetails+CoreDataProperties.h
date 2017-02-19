//
//  UserDetails+CoreDataProperties.h
//  DkLogin
//
//  Created by Sreeji Gopal on 26/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSString *userdata;
@property (nullable, nonatomic, retain) NSString *username;

@end

NS_ASSUME_NONNULL_END
