#import "LyricsFetcherAppDelegate.h"
#import "PersistentStorageProvider.h"

@implementation LyricsFetcherAppDelegate

@synthesize lyricsWindow;
@synthesize aboutWindow;
@synthesize appName;
@synthesize version;
@synthesize copyright;
@synthesize menu;
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
    
    [self dataBindAboutWindow];
    [self createStatusBarItem];
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
