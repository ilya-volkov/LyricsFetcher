#import "Settings.h"
#import "PersistentStorageProvider.h"

@implementation Settings

@synthesize defaults;
@synthesize persistentStorageProvider;

+ (Settings*)settingsWithUserDefaults:(NSUserDefaults*)defaults persistentStorageProvider:(PersistentStorageProvider*)provider {
    return [[Settings alloc] initWithUserDefaults:defaults persistentStorageProvider:provider];
}

- (id)initWithUserDefaults:(NSUserDefaults*)defaults persistentStorageProvider:(PersistentStorageProvider*)provider {
    self = [super init];
    if (self != nil) {
        self.defaults = defaults;
        self.persistentStorageProvider = provider;
    }
    
    return self;
}

-(BOOL)autoUpdateTracksWithEmptyLyrics {
    return [self.defaults boolForKey:@"AutoUpdateTracksWithEmptyLyrics"];
}

-(BOOL)disableSuggestions {
    return [self.defaults boolForKey:@"DisableSuggestions"];
}

-(BOOL)keepLyricsWindowInFrontOfOthers {
    return [self.defaults boolForKey:@"KeepLyricsWindowInFrontOfOthers"];
}

-(BOOL)startAtLogin {
    return [self.defaults boolForKey:@"StartAtLogin"];
}

- (void)wasDeclinedToAdd:(NSNumber*)id {
    [self.persistentStorageProvider wasDeclinedToAdd:id];
}

- (void)wasDeclinedToCorrect:(NSNumber*)id {
    [self.persistentStorageProvider wasDeclinedToCorrect:id];
}

- (void)wasAdded:(NSNumber*)id {
    [self.persistentStorageProvider wasAdded:id];
}

- (void)wasCorrected:(NSNumber*)id {
    [self.persistentStorageProvider wasCorrected:id];
}

- (BOOL)isDeclinedToAdd:(NSNumber*)id {
    return [self.persistentStorageProvider isDeclinedToAdd:id];
}

- (BOOL)isDeclinedToCorrect:(NSNumber*)id {
    return [self.persistentStorageProvider isDeclinedToCorrect:id];
}

- (BOOL)isAlreadyAdded:(NSNumber*)id {
    return [self.persistentStorageProvider isAlreadyAdded:id];
}

- (BOOL)isAlreadyCorrected:(NSNumber*)id {
    return [self.persistentStorageProvider isAlreadyCorrected:id];
}

- (void)saveChanges {
    [self.persistentStorageProvider saveManagedObjectContext];
}

@end
