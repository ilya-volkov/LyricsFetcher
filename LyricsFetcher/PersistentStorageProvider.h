#import <Foundation/Foundation.h>

@interface PersistentStorageProvider : NSObject {
@private
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (void)saveManagedObjectContext;
- (void)wasDeclinedToAdd:(NSNumber*)id;
- (void)wasDeclinedToCorrect:(NSNumber*)id;
- (void)wasAdded:(NSNumber*)id;
- (void)wasCorrected:(NSNumber*)id;
- (BOOL)isDeclinedToAdd:(NSNumber*)id;
- (BOOL)isDeclinedToCorrect:(NSNumber*)id;
- (BOOL)isAlreadyAdded:(NSNumber*)id;
- (BOOL)isAlreadyCorrected:(NSNumber*)id;

@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end
