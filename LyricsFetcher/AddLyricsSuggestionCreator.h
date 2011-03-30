#import <Foundation/Foundation.h>
#import "SuggestionCreator.h"

@interface AddLyricsSuggestionCreator : SuggestionCreator

+ (SuggestionCreator*)creatorWithSettings:(Settings*)settings nextCreator:(SuggestionCreator*)creator;

@end
