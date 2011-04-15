#import "LyricsFetcherAppDelegate.h"
#import "LyricsFetcherAppDelegate+Actions.h"
#import "SearchLyricsResult.h"
#import "Action.h"
#import "Settings.h"

@implementation LyricsFetcherAppDelegate (Actions)

- (void)pasteTextToPasteboard:(NSString*)text {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard writeObjects:[NSArray arrayWithObject:text]];
}

- (Action*)createAddAction:(SearchLyricsResult*)result {
    if (result == nil || ![result canAddLyrics])
        return nil;
        
    return [Action actionWithURL:result.lyricsAddUrl beforeCallback:^(){
        [self pasteTextToPasteboard:self.currentTrack.lyrics];
    } afterCallback:^(){
        [self.settings wasAdded:self.currentTrack.id];
    }];
}

- (Action*)createCorrectAction:(SearchLyricsResult*)result {
    if (result == nil || ![result canCorrectLyrics])
        return nil;
    
    return [Action actionWithURL:result.lyricsCorrectUrl beforeCallback:^(){
        [self pasteTextToPasteboard:self.currentTrack.lyrics];
    } afterCallback:^{
        [self.settings wasCorrected:self.currentTrack.id];
    }];
}

- (Action*)createSearchAction {
    if (self.currentTrack == nil)
        return nil;
    
    return [Action actionWithTrackInfo:self.currentTrack beforeCallback:^{
        if (!self.editMode) {
            self.editMode = true;
            [self switchToEditMode];
        }
    } afterCallback:nil];
}

- (void)updateActionsForSearchResult:(SearchLyricsResult*)result {
    self.addAction = [self createAddAction:result];
    self.correctAction = [self createCorrectAction:result];
    self.searchAction = [self createSearchAction];
}

@end
