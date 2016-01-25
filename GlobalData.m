//
//  GlobalData.m
//  DkLogin
//
//  Created by Sreeji Gopal on 21/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import "GlobalData.h"
#import <UIKit/UIKit.h>
#import "User+CoreDataProperties.h"

@implementation GlobalData
@synthesize message;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static GlobalData *sharedGlobalData = nil;

+(GlobalData*)sharedGlobalData {
    if(sharedGlobalData == nil){
        sharedGlobalData = [[super allocWithZone:NULL]init];
        sharedGlobalData.message = @"Default Global Message";
    }
    
    return sharedGlobalData;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self) {
        if (sharedGlobalData == nil) {
            sharedGlobalData = [super allocWithZone:zone];
            return sharedGlobalData;
        }
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(void)myFunc{
    self.message = @"Random message";
    NSLog(@"myFunc");
}

-(void)pushPostData:(NSMutableData*)data{
    _responseData = data;
    //NSLog(@"Value for Json Data from the method %@", _responseData);
}

-(NSMutableData*)getPostData{
    NSLog(@"Value for Json Data from the method %@", _responseData);
    return _responseData;
}

-(void)addToCoreData :(NSManagedObject*)entity :(NSString *)entityName :(NSString *)entityId :(NSData*)data{
    
    NSManagedObjectContext *context = _managedObjectContext;
    
    User *userData = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_managedObjectContext];
    [userData setUser:entityId];
    [userData setData:data];
    
    NSError *error = nil;
    
    if([self validateCoreDataDuplicates:entityId]){
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error saving data");
        }else{
            NSLog(@"Data Saved");
        }
    }

    
}

-(BOOL)validateCoreDataDuplicates:(NSString *) entityId{
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    BOOL unique = YES;
    NSError  *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:request error:&error];
    if(items.count > 0){
        for(User *thisUser in items){
            if([thisUser.user isEqualToString: entityId]){
                NSLog(@"User from core data %@ User as input %@",thisUser.user,entityId );
                unique = NO;
                return unique;
            }
        }
    }
    NSLog(@"bool %s", unique ? "true" : "false");
    return unique;
}

-(void)fetchFromCoreData:(NSString *)entityName :(NSString *)entityId{
    NSManagedObjectContext *context = _managedObjectContext;
    
    NSFetchRequest *_fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *_entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    [_fetchRequest setEntity:entityName];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:_fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error.
    }

}

//Fetch the webserivice hosting address.
-(NSString*)webServiceHostName{
    NSDictionary* jsonFirstAccess;
    jsonFirstAccess = [[GlobalData sharedGlobalData] firstAccess:@"ur" :@"data"];

    jsonFirstAccess = [jsonFirstAccess objectForKey:@"data"];
    
    return jsonFirstAccess;
}

-(NSMutableData*)firstAccess :(NSString*)url :(NSString*)data{
    
    NSString *urlString = [NSString stringWithFormat:@"http://mydrunkcart/index.php?route=module/apps/firstaccess/"];
    NSString *postData=[NSString stringWithFormat:@"device=iOS&email=%@&password=%@",@"sreeji.gopal@hotmail.com",@"sreeji"];
    
    _responseData = [self requestSynchronousData:urlString :postData :@"POST"];
    NSLog(@"%@", _responseData);
    
    return _responseData;
}


//Generic Function Called for Fetching REST based data, synchronous call.
-(NSMutableData*)requestSynchronousData :(NSString *)url :(NSString *) data :(NSString*) method{
    
    //Creating new dispactcher
    dispatch_semaphore_t dispSema = dispatch_semaphore_create(0);
    
    NSString *urlString = [NSString stringWithFormat:@"%@&%@", url, data];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask;
    
    if([method  isEqual: @"GET"]){
        dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            _responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
            if (error != NULL) {
                NSLog(@"ERROR requestSynchronousData :%@",error);
            
            }
            if (_responseData != NULL) {
                NSLog(@"SUCCESS requestSynchronousData :%@",_responseData);
            }
            if (error == nil) {
                NSLog(@"SUCCESS requestSynchronousData");
            }
            //Adding task to the dispactcher
            dispatch_semaphore_signal(dispSema);
        
    }];
    }else{
            NSURL *urlPost = [NSURL URLWithString:url];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlPost];
            request.HTTPBody = [data dataUsingEncoding:NSUTF8StringEncoding];
            request.HTTPMethod = @"POST";
        
            dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            _responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (error != NULL) {
                NSLog(@"ERROR requestSynchronousData :%@",error);
                
            }
            if (_responseData != NULL) {
                NSLog(@"SUCCESS requestSynchronousData :%@",_responseData);
            }
            if (error == nil) {
                NSLog(@"SUCCESS requestSynchronousData");
            }
            //Adding task to the dispactcher
            dispatch_semaphore_signal(dispSema);
            
        }];
    }
    
    [dataTask resume];
    
    dispatch_semaphore_wait(dispSema, DISPATCH_TIME_FOREVER);
    
    return _responseData;
}

-(void)printArrayData:(NSArray *)arrayData{
    for (NSString *myData in arrayData) {
        NSLog(@"%@",myData);
    }
}

@end
