#import "PersistentStorageProvider.h"

@implementation PersistentStorageProvider

- (BOOL)existsEntity:(NSString*)name withId:(NSNumber*)id {
    NSError *error;
	
	NSFetchRequest *request = [NSFetchRequest new];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", id];
    
	[request setPredicate:predicate];
	[request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext]];
	
	NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
	if (results == nil)
		NSLog(@"Fetch request failed: %@", [error description]);
    
    return ([results count] != 0);
}

- (void)addNewEntity:(NSString*)name withId:(NSNumber*)id {
    NSManagedObject *newEntity = [NSEntityDescription 
        insertNewObjectForEntityForName:name
        inManagedObjectContext:self.managedObjectContext
    ];
    
    [newEntity setId:id];
}

- (void)wasDeclinedToAdd:(NSNumber*)id {
    [self addNewEntity:@"DeclinedToAdd" withId:id];
}

- (void)wasDeclinedToCorrect:(NSNumber*)id {
    [self addNewEntity:@"DeclinedToCorrect" withId:id];
}

- (void)wasAdded:(NSNumber*)id {
    [self addNewEntity:@"AlreadyAdded" withId:id];
}

- (void)wasCorrected:(NSNumber*)id {
    [self addNewEntity:@"AlreadyCorrected" withId:id];
}

- (BOOL)isDeclinedToAdd:(NSNumber*)id {
    return [self existsEntity:@"DeclinedToAdd" withId:id];
}

- (BOOL)isDeclinedToCorrect:(NSNumber*)id {
    return [self existsEntity:@"DeclinedToCorrect" withId:id];
}

- (BOOL)isAlreadyAdded:(NSNumber*)id {
    return [self existsEntity:@"AlreadyAdded" withId:id];
}

- (BOOL)isAlreadyCorrected:(NSNumber*)id {
    return [self existsEntity:@"AlreadyCorrected" withId:id];
}

- (NSURL*)applicationFilesDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *bundleIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    return [applicationSupportURL URLByAppendingPathComponent:bundleIdentifier];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LyricsFetcher" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (mom == nil) {
        NSLog(@"%@: no model to generate a store from", [self class]);
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else {
        if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) {
            NSLog(@"%@:expected folder to store app data, found file", [self class]);
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"LyricsFetcher.storedata"];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if ([persistentStoreCoordinator addPersistentStoreWithType:NSBinaryStoreType configuration:nil URL:url options:nil error:&error] == nil) {
        NSLog(@"%@:failed to add persistent store", [self class]);
        return nil;
    }
    
    return persistentStoreCoordinator;
}

- (NSManagedObjectContext*)managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator == nil) {
        NSLog(@"%@:failed to create persistent store coordinator", [self class]);
        return nil;
    }
    
    managedObjectContext = [NSManagedObjectContext new];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return managedObjectContext;
}

- (void)saveManagedObjectContext {
    if (managedObjectContext == nil) {
        return;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:failed to commit changes", [self class]);
        return;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"%@:failed to save changes", [self class]);
    }
    
}

@end
