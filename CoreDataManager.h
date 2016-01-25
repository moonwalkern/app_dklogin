//
//  CoreDataManager.h
//  DkLogin
//
//  Created by Sreeji Gopal on 24/01/16.
//  Copyright © 2016 Sreeji Gopal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject


+ (CoreDataManager *)sharedManager;

- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock;

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                           sortDescriptors:(NSArray *)sortDescriptors
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 predicate:(NSPredicate *)predicate;

- (id)createEntityWithClassName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary;
- (void)deleteEntity:(NSManagedObject *)entity;
- (BOOL)uniqueAttributeForClassName:(NSString *)className
                      attributeName:(NSString *)attributeName
                     attributeValue:(id)attributeValue;
- (NSArray*)fetchAllEntityWithClassName:(NSString *)className;

- (NSArray*)fetchSortAllEntityWithClassName:(NSString *)className :(NSString *)entityName :(NSString *)entitySortName;

- (NSArray*)fetchPredicateEntityWithClassName:(NSString *)className :(NSString *)attributeName :(NSString *)attributeValue;

@end
