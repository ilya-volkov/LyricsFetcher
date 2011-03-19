#import <Cocoa/Cocoa.h>
#import "iTunesControllerDelegate.h"

@class PersistentStorageProvider;
@class ChartLyricsLyricsProvider;
@class iTunesController;
@class TrackInfo;

@interface LyricsFetcherAppDelegate : NSObject <NSApplicationDelegate, iTunesControllerDelegate>

- (IBAction)showAboutWindow:(id)sender;
- (IBAction)showLyricsWindow:(id)sender;

@property IBOutlet NSWindow *lyricsWindow;
@property IBOutlet NSWindow *aboutWindow;
@property IBOutlet NSTextField *appName;
@property IBOutlet NSTextField *version;
@property IBOutlet NSTextField *copyright;
@property IBOutlet NSMenu *menu;

@property ChartLyricsLyricsProvider *lyricsProvider;
@property iTunesController *iTunes;
@property TrackInfo *currentTrack;
@property NSStatusItem *statusBarItem;
@property PersistentStorageProvider *persistentStorageProvider;

@end