//
//  GlobalData.h
//  DkLogin
//
//  Created by Sreeji Gopal on 21/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface GlobalData : NSObject{
    NSString *message;
    NSMutableData *_responseData;;
    
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic, retain) NSString *message;

+ (GlobalData*)sharedGlobalData;

-(void)myFunc;

-(NSMutableData*)firstAccess;

-(NSString*)postRestHandler;

-(NSMutableData*)getPostData;

-(NSMutableData*)firstAccess:(NSString*)url :(NSString*)data;

-(NSString*)webServiceHostName;

-(NSMutableData*)requestSynchronousData :(NSString *)url :(NSString *) data :(NSString*) method;

-(void)addToCoreData :(NSManagedObject*)entity :(NSString*)entityName :(NSString*)entityId;
-(void)deleteFromCoreData :(NSString*)entity :(NSString*)entityId;
-(void)fetchFromCoreData :(NSString*)entity :(NSString*)entityId;
-(void)cleanCoreData :(NSString*)entity;
-(BOOL)validateCoreDataDuplicates:(NSString *) entityId;
-(void)printArrayData:(NSArray *)arrayData;
-(NSString *)getIPAddress;
-(NSString *)sha1:(NSString *)str;
-(NSString *)buildPassword:(NSString*)salt:(NSString*)password;
@end
