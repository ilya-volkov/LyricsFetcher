#import "SuggestionCreationContext.h"
#import "SearchLyricsResult.h"
#import "TrackInfo.h"
#import "Action.h"

@implementation SuggestionCreationContext

@synthesize searchResult;
@synthesize trackInfo;
@synthesize addAction;
@synthesize correctAction;

+ (SuggestionCreationContext*)contextWithSearchResult: (SearchLyricsResult *)searchResult 
                                            trackInfo: (TrackInfo *)trackInfo 
                                            addAction: (Action *)addAction 
                                        correctAction: (Action *)correctAction 
{
    return [[SuggestionCreationContext alloc] initWithSearchResult: searchResult 
                                                         trackInfo: trackInfo 
                                                         addAction: addAction 
                                                     correctAction: correctAction];
}

- (id)initWithSearchResult: (SearchLyricsResult*)searchResult 
                 trackInfo: (TrackInfo*)trackInfo 
                 addAction: (Action*)addAction 
             correctAction: (Action*)correctAction 
{
    self = [super init];
    if (self != nil) {
        self.searchResult = searchResult;
        self.trackInfo = trackInfo;
        self.addAction = addAction;
        self.correctAction = correctAction;
    }
    
    return self;    
};

@end
