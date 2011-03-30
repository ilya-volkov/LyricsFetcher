#import "LyricsFetcherAppDelegate.h"
#import "PersistentStorageProvider.h"
#import "ChartLyricsLyricsProvider.h"
#import "SearchLyricsResult.h"
#import "iTunesController.h"
#import "TrackInfo.h"
#import "TrackInfoTransformer.h"
#import "Settings.h"
#import "SuggestionCreator.h"
#import "AddLyricsSuggestionCreator.h"
#import "CorrectLyricsSuggestionCreator.h"
#import "SuggestionCreationContext.h"
#import "Suggestion.h"
#import "SplitViewDelegate.h"

#import "LyricsFetcherAppDelegate+Actions.h"
#import "NSAttributedString+Hyperlink.h"

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
@synthesize addAction;
@synthesize correctAction;
@synthesize searchAction;
@synthesize settings;
@synthesize currentSuggestion;
@synthesize suggestionCreator;
@synthesize chartlyricsLink;
@synthesize editMode;
@synthesize splitView;

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

- (void)showSuggestion {
    // TODO
}

- (void)hideSuggestion {
    // TODO
}

- (void)showEditModeButtons {
    NSView *lyricsView = [self.splitView.subviews objectAtIndex:1];
	NSView *buttonsView = [self.splitView.subviews objectAtIndex:2];
	
    NSRect targetFrame = NSMakeRect(
        [buttonsView frame].origin.x, 
        [buttonsView frame].origin.y - 45.0, 
        [buttonsView frame].size.width, 
        [buttonsView frame].size.height
    );
    
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:.5];
	[[buttonsView animator] setFrame: targetFrame];
	//[[buttonsView animator] setFrame: view1TargetFrame];
	[NSAnimationContext endGrouping];
}

- (void)hideEditModeButtons {
    NSView *lyricsView = [self.splitView.subviews objectAtIndex:1];
	NSView *buttonsView = [self.splitView.subviews objectAtIndex:2];
	
    NSRect targetFrame = NSMakeRect(
        [buttonsView frame].origin.x, 
        [buttonsView frame].origin.y + [buttonsView frame].size.height, 
        [buttonsView frame].size.width, 
        [buttonsView frame].size.height
    );
    
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:1.0];
	[[buttonsView animator] setFrame: targetFrame];
	//[[buttonsView animator] setFrame: view1TargetFrame];
	[NSAnimationContext endGrouping];
}

- (void)switchToEditMode {
    self.editMode = true;
    // Concurrent animation !!!
    [self hideSuggestion];
    [self showEditModeButtons];
}

- (void)returnFromEditMode {
    self.editMode = false;
    [self hideEditModeButtons];
}

- (IBAction)acceptSuggestion:(id)sender {
    [self hideSuggestion];
    [self.currentSuggestion accept];
}

- (IBAction)declineSuggestion:(id)sender {
    [self hideSuggestion];
    [self.currentSuggestion decline];
}

- (IBAction)closeSuggestion:(id)sender {
    [self hideSuggestion];
}

- (IBAction)toggleEditMode:(id)sender {
    if (self.editMode)
        [self returnFromEditMode];
    else
        [self switchToEditMode];
}

- (IBAction)searchLyrics:(id)sender {
    [self.lyricsProvider beginSearchLyricsFor:self.currentTrack.name by:self.currentTrack.artist callback:^(SearchLyricsResult* result){
        [self updateActionsForSearchResult:result];
        
        self.currentTrack.lyrics = result.lyrics;
	}];
}

- (IBAction)saveLyrics:(id)sender {
    [self.currentTrack update];
    [self returnFromEditMode];
}

- (IBAction)cancelLyricsEditing:(id)sender {
    [self.currentTrack reset];
    [self returnFromEditMode];
}

- (void)buildChartlyricsLink {
    [self.chartlyricsLink setAllowsEditingTextAttributes:YES];
    [self.chartlyricsLink setSelectable:YES];
    
    NSURL* url = [NSURL URLWithString:@"http://www.chartlyrics.com"];
    
    [self.chartlyricsLink setAttributedStringValue:
        [NSAttributedString hyperlinkFromString:@"Chartlyrics.com" withURL:url]
    ];
}

- (void)dataBindAboutWindow {
    NSBundle *bundle = [NSBundle mainBundle];
    [appName setStringValue:[bundle objectForInfoDictionaryKey:@"CFBundleName"]];
    
    [version setStringValue:[NSString stringWithFormat:@"%@ (%@)",
        [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
        [bundle objectForInfoDictionaryKey:@"CFBundleVersion"]
    ]];
    
    [copyright setStringValue:[bundle objectForInfoDictionaryKey:@"NSHumanReadableCopyright"]];
    
    [self buildChartlyricsLink];
}

- (void)createStatusBarItem {
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
    [self disableCurrentTrackInfoMenuItem];
}


- (void)registerValueTransformers {
    [NSValueTransformer setValueTransformer:[TrackInfoTransformer new] forName:@"TrackInfoTransformer"];
}

- (void)createSuggestionCreators {
    self.suggestionCreator = 
    [AddLyricsSuggestionCreator creatorWithSettings: self.settings 
                                        nextCreator: [CorrectLyricsSuggestionCreator creatorWithSettings: self.settings 
                                                                                             nextCreator: nil]];
}

- (void)setupParagraphStyles {
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.lyricsProvider = [ChartLyricsLyricsProvider new];
    self.iTunes = [iTunesController controllerWithDelegate:self];
    self.settings = [Settings settingsWithUserDefaults: [NSUserDefaults standardUserDefaults] 
                             persistentStorageProvider: [PersistentStorageProvider new]];
    
    [self dataBindAboutWindow];
    [self createStatusBarItem];
    [self currentTrackChangedTo:
     [self.iTunes getCurrentTrack]];
    [self configureCocoaBinding];    
    [self registerValueTransformers];
    [self createSuggestionCreators];
    [self setupParagraphStyles];
    
    [self.splitView setDelegate:[SplitViewDelegate new]];
}

- (void)updateSuggestionForSearchResult:(SearchLyricsResult*)result {
    SuggestionCreationContext *context = [SuggestionCreationContext contextWithSearchResult: result 
                                                                                  trackInfo: self.currentTrack 
                                                                                  addAction: self.addAction 
                                                                              correctAction: self.correctAction];
    
    self.currentSuggestion = [self.suggestionCreator createWithContext:context];
    if (self.editMode)
        return;
    
    if (self.currentSuggestion != nil)
        [self showSuggestion];
    else
        [self hideSuggestion];
}

- (void)handleSearchResult:(SearchLyricsResult*)result {
    [self updateActionsForSearchResult:result];
    [self updateSuggestionForSearchResult:result];
}

- (void)currentTrackChangedTo:(TrackInfo*)track {
    if (self.editMode)
        return;
    
    if (self.settings.autoUpdateTracksWithEmptyLyrics)
        [self.currentTrack update];
    
    self.currentTrack = track;
    
    if (track == nil) {
        [self handleSearchResult:nil];
        
        return;
    }
    
    [self.lyricsProvider beginSearchLyricsFor:track.name by:track.artist callback:^(SearchLyricsResult* result){
        [self handleSearchResult:result];
        
        if ([self.currentTrack.lyrics length] == 0)
            self.currentTrack.lyrics = result.lyrics;
	}];
}

- (NSInteger)getLyricsWindowLevel {
    return self.settings.keepLyricsWindowInFrontOfOthers ? NSPopUpMenuWindowLevel 
    : NSNormalWindowLevel;
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
    [self.settings saveChanges];
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusBarItem];
    
    return NSTerminateNow;
}

@end