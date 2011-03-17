#import <Cocoa/Cocoa.h>

@class PersistentStorageProvider;

@interface LyricsFetcherAppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)showAboutWindow:(id)sender;
- (IBAction)showLyricsWindow:(id)sender;

@property IBOutlet NSWindow *lyricsWindow;
@property IBOutlet NSWindow *aboutWindow;
@property IBOutlet NSTextField *appName;
@property IBOutlet NSTextField *version;
@property IBOutlet NSTextField *copyright;
@property IBOutlet NSMenu *menu;

@property NSStatusItem *statusBarItem;
@property PersistentStorageProvider *persistentStorageProvider;

@end