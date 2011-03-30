#import <Cocoa/Cocoa.h>

@class SearchLyricsResult;
@class TrackInfo;
@class Action;

@interface SuggestionCreationContext : NSObject

+ (SuggestionCreationContext*)contextWithSearchResult: (SearchLyricsResult*)searchResult 
                                            trackInfo: (TrackInfo*)trackInfo 
                                            addAction: (Action*)addAction 
                                        correctAction: (Action*)correctAction;

- (id)initWithSearchResult: (SearchLyricsResult*)searchResult 
                 trackInfo: (TrackInfo*)trackInfo 
                 addAction: (Action*)addAction 
             correctAction: (Action*)correctAction;

@property SearchLyricsResult *searchResult;
@property TrackInfo *trackInfo;
@property Action *addAction;
@property Action *correctAction;

@end
