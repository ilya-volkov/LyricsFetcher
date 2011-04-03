#import "AddLyricsSuggestionCreator.h"
#import "SuggestionCreationContext.h"
#import "Settings.h"
#import "TrackInfo.h"
#import "SearchLyricsResult.h"
#import "Suggestion.h"


@implementation AddLyricsSuggestionCreator

+ (SuggestionCreator*)creatorWithSettings:(Settings*)settings nextCreator:(SuggestionCreator*)creator {
    return [[AddLyricsSuggestionCreator alloc] initWithSettings:settings nextCreator:creator];
}

- (Suggestion*)createWithContextCore:(SuggestionCreationContext*)context {
    if (self.settings.disableSuggestions)
        return nil;
    
    if ([self.settings isAlreadyAdded:context.trackInfo.id] 
        || [self.settings isDeclinedToAdd:context.trackInfo.id]) {
        return nil;
    }
    
    if (context.addAction == nil)
        return nil;
    
    if ([context.trackInfo.lyrics length] == 0)
        return nil;
    
    return [Suggestion suggestionWithMessage: NSLocalizedStringFromTable(@"SubmitLyricsSuggestion", @"InfoPlist", nil)
                                      action: context.addAction 
                              acceptCallback: nil 
                             declineCallback: ^{ [self.settings wasDeclinedToAdd:context.trackInfo.id]; }
    ];
}

@end
