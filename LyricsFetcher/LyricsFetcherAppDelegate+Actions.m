#import "LyricsFetcherAppDelegate.h"
#import "LyricsFetcherAppDelegate+Actions.h"
#import "SearchLyricsResult.h"
#import "Action.h"

@implementation LyricsFetcherAppDelegate (Actions)

- (Action*)createAddAction:(SearchLyricsResult*)result {
    if (result == nil || ![result canAddLyrics])
        return nil;
        
    
    return [Action actionWithURL:result.lyricsAddUrl callback:^(){
        NSLog(@"TODO: recently added %@", self.currentTrack.id);
    }];
}

- (Action*)createCorrectAction:(SearchLyricsResult*)result {
    if (result == nil || ![result canCorrectLyrics])
        return nil;

    
    return [Action actionWithURL:result.lyricsCorrectUrl callback:^(){
        NSLog(@"TODO: recently corrected %@", self.currentTrack.id);
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
