#import "LyricsFetcherAppDelegate.h"
#import "PersistentStorageProvider.h"
#import "ChartLyricsLyricsProvider.h"
#import "SearchLyricsResult.h"
#import "iTunesController.h"
#import "TrackInfo.h"

@implementation LyricsFetcherAppDelegate

@synthesize lyricsWindow;
@synthesize aboutWindow;
@synthesize preferencesWindow;
@synthesize appName;
@synthesize version;
@synthesize copyright;
@synthesize menu;
@synthesize currentTrackInfoMenuItem;
@synthesize lyricsProvider;
@synthesize iTunes;
@synthesize currentTrack;
@synthesize statusBarItem;
@synthesize persistentStorageProvider;

- (void)registerDefaultUserSettings {
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:
        [[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"]
    ];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    [self registerDefaultUserSettings];
}

- (void)addLoginItemWithPath:(NSString *)path toList:(LSSharedFileListRef)loginItemsRef {
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:path];
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);		
	if (item != NULL)
		CFRelease(item);
}

- (void)removeLoginItemWithPath:(NSString *)path fromList:(LSSharedFileListRef)loginItemsRef {
	UInt32 seedValue;
	CFURLRef outPath;

	CFArrayRef loginItems = LSSharedFileListCopySnapshot(loginItemsRef, &seedValue);
	for (id item in (NSArray *)loginItems) {		
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
		if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*)&outPath, NULL) == noErr) {
			if ([[(NSURL *)outPath path] hasPrefix:path]) {
				LSSharedFileListItemRemove(loginItemsRef, itemRef);
			}
            
			CFRelease(outPath);
		}		
	}
    
	CFRelease(loginItems);
}

- (IBAction)startOnSystemStartupCheckboxToggle:(NSButton*)sender {
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
    
	LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if ([sender state] == NSOnState) {
        [self addLoginItemWithPath:appPath toList:loginItemsRef];
    }
    else {
        [self removeLoginItemWithPath:appPath fromList:loginItemsRef];
    }
    
	CFRelease(loginItemsRef);
}

- (IBAction)keepLyricsWindowInFrontOfOthersCheckboxToggle:(NSButton*)sender {
    if ([sender state] == NSOnState)
        [self.lyricsWindow setLevel:NSPopUpMenuWindowLevel];
    else
        [self.lyricsWindow setLevel:NSNormalWindowLevel];
}

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

// IV: Binding menu item title makes menu item enabled, 
// even if the target/action is nil and enabled property of the item is set to false. 
// This workaround permanently disables menu item.
- (void)disableCurrentTrackInfoMenuItem {
    NSNumber *alwaysNo = [NSNumber numberWithBool:NO];
    [self.currentTrackInfoMenuItem bind:@"enabled" toObject:alwaysNo withKeyPath:@"boolValue" options:nil];
}

- (void)configureCocoaBinding {
    [self.currentTrackInfoMenuItem bind: @"title" 
                               toObject: self
                            withKeyPath: @"currentTrack.displayString" 
                                options: [NSDictionary dictionaryWithObject: NSLocalizedStringFromTable(@"CurrentTrackInfoNotExists", @"InfoPlist", nil) 
                                                                     forKey: NSNullPlaceholderBindingOption]
     ];    
    [self disableCurrentTrackInfoMenuItem];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.persistentStorageProvider = [PersistentStorageProvider new];
    self.lyricsProvider = [ChartLyricsLyricsProvider new];
    self.iTunes = [iTunesController controllerWithDelegate:self];
    
    [self dataBindAboutWindow];
    [self createStatusBarItem];
    [self currentTrackChangedTo:[self.iTunes getCurrentTrack]];
    [self configureCocoaBinding];
}

- (void)currentTrackChangedTo:(TrackInfo*)track {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoUpdateTracksWithEmptyLyics"])
        [self.currentTrack update];
    
    self.currentTrack = track;
    
    if (track == nil)
        return;
    
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
    BOOL disableSuggestions = [[NSUserDefaults standardUserDefaults] boolForKey:@"DisableSuggestions"];
    // TODO: show suggestion
}

- (NSInteger)getLyricsWindowLevel {
    BOOL keepInFront = [[NSUserDefaults standardUserDefaults] boolForKey:@"KeepLyricsWindowInFrontOfOthers"];
    
    return keepInFront ? NSPopUpMenuWindowLevel : NSNormalWindowLevel;
}

- (void)showWindow:(NSWindow*)window {
    [NSApp activateIgnoringOtherApps:YES];
    [window makeKeyAndOrderFront:self];
}

- (IBAction)showAboutWindow:(id)sender {
    [self showWindow:self.aboutWindow];
}

- (IBAction)showLyricsWindow:(id)sender {
    [self showWindow:self.lyricsWindow];
    [self.lyricsWindow setLevel:[self getLyricsWindowLevel]];
}

- (IBAction)showPreferencesWindow:(id)sender {
    [self showWindow:self.preferencesWindow];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    [self.persistentStorageProvider saveManagedObjectContext];
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusBarItem];

    return NSTerminateNow;
}

@end
