#import "LyricsFetcherAppDelegate.h"
#import "LyricsFetcherAppDelegate+Actions.h"
#import "SearchLyricsResult.h"
#import "Action.h"
#import "Settings.h"

@implementation LyricsFetcherAppDelegate (Actions)

- (Action*)createAddAction:(SearchLyricsResult*)result {
    if (result == nil || ![result canAddLyrics])
        return nil;
        
    
    return [Action actionWithURL:result.lyricsAddUrl callback:^(){
        [self.settings wasAdded:self.currentTrack.id];
        NSLog(@"Track with id %@ was added", self.currentTrack.id); // test
    }];
}

- (Action*)createCorrectAction:(SearchLyricsResult*)result {
    if (result == nil || ![result canCorrectLyrics])
        return nil;

    
    return [Action actionWithURL:result.lyricsCorrectUrl callback:^(){
        [self.settings wasCorrected:self.currentTrack.id];
        NSLog(@"Track with id %@ was corrected", self.currentTrack.id); // test
    }];
}

- (Action*)createSearchAction {
    if (self.currentTrack == nil)
        return nil;
    
    return [Action actionWithTrackInfo:self.currentTrack callback:nil];
}

- (void)updateActionsForSearchResult:(SearchLyricsResult*)result {
    self.addAction = [self createAddAction:result];
    self.correctAction = [self createCorrectAction:result];
    self.searchAction = [self createSearchAction];
}

@end
