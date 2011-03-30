#import <Foundation/Foundation.h>
#import "SuggestionCreator.h"

@interface CorrectLyricsSuggestionCreator : SuggestionCreator

+ (SuggestionCreator*)creatorWithSettings:(Settings*)settings nextCreator:(SuggestionCreator*)creator;

@end
