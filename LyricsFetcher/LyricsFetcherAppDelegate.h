//
//  LyricsFetcherAppDelegate.h
//  LyricsFetcher
//
//  Created by Илья Волков on 3/16/11.
//  Copyright 2011 Apple Computer Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LyricsFetcherAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;

@end
