#import "LyricsFetcherAppDelegate.h"
#import "PersistentStorageProvider.h"
#import "ChartLyricsLyricsProvider.h"
#import "SearchLyricsResult.h"
#import "iTunesController.h"
#import "TrackInfo.h"

@implementation LyricsFetcherAppDelegate

@synthesize lyricsWindow;
@synthesize aboutWindow;
@synthesize appName;
@synthesize version;
@synthesize copyright;
@synthesize menu;
@synthesize lyricsProvider;
@synthesize iTunes;
@synthesize currentTrack;
@synthesize statusBarItem;
@synthesize persistentStorageProvider;

- (void)dataBindAboutWindow {
    NSBundle *bundle = [NSBundle mainBundle];
    [appName setStringValue:[bundle objectForInfoDictionaryKey:@"CFBundleName"]];
    
    [version setStringValue:[NSString stringWithFormat:@"%@ (%@)",
        [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
        [bundle objectForInfoDictionaryKey:@"CFBundleVersion"]
    ]];
    
    [copyright setStringValue:[bundle objectForInfoDictionaryKey:@"NSHumanReadableCopyright"]];
}

- (void) createStatusBarItem {
	self.statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	if (self.statusBarItem != nil) {
		[self.statusBarItem setMenu:self.menu];
		[self.statusBarItem setImage:[NSImage imageNamed:@"lyricsFetcherStatus.png"]];
		[self.statusBarItem setHighlightMode:YES];
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.persistentStorageProvider = [PersistentStorageProvider new];
    self.lyricsProvider = [ChartLyricsLyricsProvider new];
    self.iTunes = [iTunesController controllerWithDelegate:self];
    
    [self dataBindAboutWindow];
    [self createStatusBarItem];
    [self currentTrackChangedTo:[self.iTunes getCurrentTrack]];
}

- (void)currentTrackChangedTo:(TrackInfo*)track {
    [self.currentTrack update];
    
    if (track == nil)
        return;
    
    self.currentTrack = track;
    
    [self.lyricsProvider beginSearchLyricsFor:track.name by:track.artist callback: ^(SearchLyricsResult* result){
		if (result == nil) {
			// TODO: show search by Google template
			return;
		}
        
        if ([self.currentTrack.lyrics length] == 0)
            self.currentTrack.lyrics = result.lyrics;
        
        // TODO: actions and suggestions
	}];
}

- (void)showSuggestion:(NSString*)text {
    // TODO: show suggestion
}

- (IBAction)showAboutWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [self.aboutWindow makeKeyAndOrderFront:sender];
}

- (IBAction)showLyricsWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [self.lyricsWindow makeKeyAndOrderFront:sender];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    [self.persistentStorageProvider saveManagedObjectContext];
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusBarItem];

    return NSTerminateNow;
}

@end
