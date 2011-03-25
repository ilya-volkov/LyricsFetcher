#import <Cocoa/Cocoa.h>
#import "iTunesControllerDelegate.h"
#import "Action.h"

@class PersistentStorageProvider;
@class ChartLyricsLyricsProvider;
@class iTunesController;
@class TrackInfo;

@interface LyricsFetcherAppDelegate : NSObject <NSApplicationDelegate, iTunesControllerDelegate>

- (IBAction)showAboutWindow:(id)sender;
- (IBAction)showLyricsWindow:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)startOnSystemStartupCheckboxToggle:(NSButton*)sender;
- (IBAction)keepLyricsWindowInFrontOfOthersCheckboxToggle:(NSButton*)sender;

@property IBOutlet NSWindow *lyricsWindow;
@property IBOutlet NSWindow *aboutWindow;
@property IBOutlet NSWindow *preferencesWindow;
@property IBOutlet NSTextField *appName;
@property IBOutlet NSTextField *version;
@property IBOutlet NSTextField *copyright;
@property IBOutlet NSMenu *menu;
@property IBOutlet NSMenuItem *currentTrackInfoMenuItem;

@property ChartLyricsLyricsProvider *lyricsProvider;
@property iTunesController *iTunes;
@property TrackInfo *currentTrack;
@property NSStatusItem *statusBarItem;
@property PersistentStorageProvider *persistentStorageProvider;
@property Action *addAction;
@property Action *correctAction;
@property Action *searchAction;

@end