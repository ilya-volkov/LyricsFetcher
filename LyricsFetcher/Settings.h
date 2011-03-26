#import <Foundation/Foundation.h>

@class PersistentStorageProvider;

@interface Settings : NSObject

+ (Settings*)settingsWithUserDefaults:(NSUserDefaults*)defaults persistentStorageProvider:(PersistentStorageProvider*)provider;
- (id)initWithUserDefaults:(NSUserDefaults*)defaults persistentStorageProvider:(PersistentStorageProvider*)provider;
- (void)wasDeclinedToAdd:(NSNumber*)id;
- (void)wasDeclinedToCorrect:(NSNumber*)id;
- (void)wasAdded:(NSNumber*)id;
- (void)wasCorrected:(NSNumber*)id;
- (BOOL)isDeclinedToAdd:(NSNumber*)id;
- (BOOL)isDeclinedToCorrect:(NSNumber*)id;
- (BOOL)isAlreadyAdded:(NSNumber*)id;
- (BOOL)isAlreadyCorrected:(NSNumber*)id;
- (void)saveChanges;


@property NSUserDefaults *defaults;
@property PersistentStorageProvider* persistentStorageProvider;
@property (readonly) BOOL autoUpdateTracksWithEmptyLyrics;
@property (readonly) BOOL disableSuggestions;
@property (readonly) BOOL keepLyricsWindowInFrontOfOthers;
@property (readonly) BOOL startAtLogin;

@end
