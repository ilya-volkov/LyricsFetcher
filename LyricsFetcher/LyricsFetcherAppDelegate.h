#import <Cocoa/Cocoa.h>
#import "iTunesControllerDelegate.h"
#import "Action.h"

@class PersistentStorageProvider;
@class ChartLyricsLyricsProvider;
@class iTunesController;
@class TrackInfo;
@class Settings;
@class Suggestion;
@class SuggestionCreator;
@class MainViewAnimator;

@interface LyricsFetcherAppDelegate : NSObject <NSApplicationDelegate, iTunesControllerDelegate>

- (IBAction)toggleEditMode:(id)sender;
- (IBAction)acceptSuggestion:(id)sender;
- (IBAction)declineSuggestion:(id)sender;
- (IBAction)closeSuggestion:(id)sender;
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
@property IBOutlet NSTextField *chartlyricsLink;
@property IBOutlet NSTextView *lyricsText;
@property IBOutlet NSView *suggestionView;
@property IBOutlet NSView *lyricsView;
@property IBOutlet NSView *editButtonsView;
@property IBOutlet NSTextField *artist;
@property IBOutlet NSTextField *song;
@property IBOutlet NSButton* toggleEditModeButton;

@property ChartLyricsLyricsProvider *lyricsProvider;
@property iTunesController *iTunes;
@property TrackInfo *currentTrack;
@property NSStatusItem *statusBarItem;
@property Action *addAction;
@property Action *correctAction;
@property Action *searchAction;
@property Settings *settings;
@property Suggestion *currentSuggestion;
@property SuggestionCreator *suggestionCreator;
@property BOOL editMode;
@property MainViewAnimator* mainViewAnimator;

@end