#import "CorrectLyricsSuggestionCreator.h"
#import "SuggestionCreationContext.h"
#import "Settings.h"
#import "TrackInfo.h"
#import "SearchLyricsResult.h"
#import "Suggestion.h"

@implementation CorrectLyricsSuggestionCreator

+ (SuggestionCreator*)creatorWithSettings:(Settings*)settings nextCreator:(SuggestionCreator*)creator {
    return [[CorrectLyricsSuggestionCreator alloc] initWithSettings:settings nextCreator:creator];
}

- (Suggestion*)createWithContextCore:(SuggestionCreationContext*)context {
    if (self.settings.disableSuggestions)
        return nil;
    
    if ([self.settings isAlreadyCorrected:context.trackInfo.id] 
        || [self.settings isDeclinedToCorrect:context.trackInfo.id]) {
        return nil;
    }
    
    if (context.correctAction == nil)
        return nil;
    
    if (!([context.trackInfo.lyrics length] > 0 
        && [context.searchResult.lyrics length] > 0
        && ![context.trackInfo.lyrics isEqualToString:context.searchResult.lyrics]))
        return nil;
    
    return [Suggestion suggestionWithMessage: NSLocalizedStringFromTable(@"CorrectLyricsSuggestion", @"InfoPlist", nil)
                                      action: context.correctAction 
                              acceptCallback: nil 
                             declineCallback: ^{ [self.settings wasDeclinedToCorrect:context.trackInfo.id]; }
    ];
}

@end
