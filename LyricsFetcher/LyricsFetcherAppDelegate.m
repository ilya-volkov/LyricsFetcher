#import <QuartzCore/CAAnimation.h>
#import "LyricsFetcherAppDelegate.h"
#import "PersistentStorageProvider.h"
#import "HTTPGETChartLyricsLyricsProvider.h"
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
#import "MainViewAnimator.h"

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
@synthesize lyricsText;
@synthesize suggestionView;
@synthesize lyricsView;
@synthesize editButtonsView;
@synthesize mainViewAnimator;
@synthesize song;
@synthesize artist;
@synthesize toggleEditModeButton;
@synthesize lyricsLoadingProgress;

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

- (void)endEditingOfTheInputs {
    if (![self.lyricsWindow makeFirstResponder:self.lyricsWindow]) {
        [self.lyricsWindow endEditingFor:nil];
    }
}

- (void)switchToEditMode {
    [self.currentTrack saveState];
    [self.mainViewAnimator beginGrouping];
    [self.mainViewAnimator hideSuggestion];
    [self.mainViewAnimator showEditButtons];
    [self.mainViewAnimator animateGroup];
}

- (void)returnFromEditMode {
    [self currentTrackChangedTo:[self.iTunes getCurrentTrack]];
    [self.mainViewAnimator hideEditButtons];
}

- (IBAction)acceptSuggestion:(id)sender {
    [self.mainViewAnimator hideSuggestion];
    [self.currentSuggestion accept];
}

- (IBAction)declineSuggestion:(id)sender {
    [self.mainViewAnimator hideSuggestion];
    [self.currentSuggestion decline];
}

- (IBAction)closeSuggestion:(id)sender {
    [self.mainViewAnimator hideSuggestion];
}

- (void)returnFromEditModeSavingChanges:(BOOL)savingChanges {
    [self endEditingOfTheInputs];

    if (savingChanges)
        [self.currentTrack update];
    else
        [self.currentTrack restoreState];
    
    [self returnFromEditMode];
}

- (IBAction)toggleEditMode:(id)sender {
    if (self.editMode) {
        [self switchToEditMode];
        [self.toggleEditModeButton setToolTip:NSLocalizedString(@"ReturnFromEditMode", nil)];

    }
    else {
        [self returnFromEditModeSavingChanges:false];
        [self.toggleEditModeButton setToolTip:NSLocalizedString(@"SwitchToEditMode", nil)];    
    }
}

- (IBAction)searchLyrics:(id)sender {
    [self.lyricsLoadingProgress startAnimation:self];
    [self.lyricsProvider beginSearchLyricsFor: [self.song stringValue] 
                                           by: [self.artist stringValue] 
                                     callback: ^(SearchLyricsResult* result) 
    {
        TrackInfo *track = self.currentTrack;
        
        [self.lyricsLoadingProgress stopAnimation:self];
        if (![self.currentTrack isEqualToTrackInfo:track])
            return;
        
        [self updateActionsForSearchResult:result];
        [self.currentTrack syncWithSearchResult:result overridingExistingValues:true];
	}];
}

- (IBAction)saveLyrics:(id)sender {    
    self.editMode = false;
    [self returnFromEditModeSavingChanges:true];
}

- (IBAction)cancelLyricsEditing:(id)sender {
    self.editMode = false;
    [self returnFromEditModeSavingChanges:false];
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
        [self.statusBarItem setAlternateImage:[NSImage imageNamed:@"lyricsFetcherStatusAlternate.png"]];
		[self.statusBarItem setHighlightMode:YES];
	}
}

- (void)configureCocoaBinding {
    [self.lyricsText bind:@"selectable" toObject:self withKeyPath:@"editMode" options:nil];
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

- (void)setupLyricsTextStyle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSCenterTextAlignment];
    
    [self.lyricsText setDefaultParagraphStyle:style];
    [self.lyricsText setTextContainerInset:NSMakeSize(10, 10)];
    [self.lyricsText setFont:[NSFont systemFontOfSize:12]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.mainViewAnimator = [MainViewAnimator animatorWithSuggestion: self.suggestionView 
                                                          lyricsText: self.lyricsView 
                                                         editButtons: self.editButtonsView];
    self.lyricsProvider = [HTTPGETChartLyricsLyricsProvider new];
    self.iTunes = [iTunesController controllerWithDelegate:self];
    self.settings = [Settings settingsWithUserDefaults: [NSUserDefaults standardUserDefaults] 
                             persistentStorageProvider: [PersistentStorageProvider new]];
    
    [self.mainViewAnimator hideSuggestionImmediately];
    [self.mainViewAnimator hideEditButtonsImmediately];
    
    [self dataBindAboutWindow];
    [self createStatusBarItem];
    [self currentTrackChangedTo:[self.iTunes getCurrentTrack]];
    [self configureCocoaBinding];    
    [self registerValueTransformers];
    [self createSuggestionCreators];
    [self setupLyricsTextStyle];
    
    [self.toggleEditModeButton setToolTip:NSLocalizedString(@"SwitchToEditMode", nil)];
    
    self.editMode = false;
}

- (void)updateSuggestionForSearchResult:(SearchLyricsResult*)result {
    SuggestionCreationContext *context = [SuggestionCreationContext contextWithSearchResult: result 
                                                                                  trackInfo: self.currentTrack 
                                                                                  addAction: self.addAction 
                                                                              correctAction: self.correctAction];
    
    self.currentSuggestion = [self.suggestionCreator createWithContext:context];
    if (self.currentSuggestion != nil)
        [self.mainViewAnimator showSuggestion];
    else
        [self.mainViewAnimator hideSuggestion];
}

- (void)handleSearchResult:(SearchLyricsResult*)result {
    [self updateActionsForSearchResult:result];
    [self updateSuggestionForSearchResult:result];
}

- (void)currentTrackChangedTo:(TrackInfo*)track {
    if (self.editMode || [self.currentTrack isEqualToTrackInfo:track])
        return;
    
    if (self.settings.autoUpdateTracksWithEmptyLyrics)
        [self.currentTrack update];
    
    self.currentTrack = track;
    
    if (track == nil) {
        [self handleSearchResult:nil];
        return;
    }
    
    [self.lyricsLoadingProgress startAnimation:self];
    [self.lyricsProvider beginSearchLyricsFor:track.name by:track.artist callback:^(SearchLyricsResult* result){
        TrackInfo *track = self.currentTrack;
        
        [self.lyricsLoadingProgress stopAnimation:self];
        if (![self.currentTrack isEqualToTrackInfo:track])
            return;
        
        [self handleSearchResult:result];
        [self.currentTrack syncWithSearchResult:result];
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
    if (self.settings.autoUpdateTracksWithEmptyLyrics)
        [self.currentTrack update];
    
    [self.settings saveChanges];
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusBarItem];
    
    return NSTerminateNow;
}

@end