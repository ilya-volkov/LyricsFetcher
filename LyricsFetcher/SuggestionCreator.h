#import <Foundation/Foundation.h>

@class Settings;
@class Suggestion;
@class SuggestionCreationContext;

@interface SuggestionCreator : NSObject

- (id)initWithSettings:(Settings*)settings nextCreator:(SuggestionCreator*)creator;
- (Suggestion*)createWithContext:(SuggestionCreationContext*)context;
- (Suggestion*)createWithContextCore:(SuggestionCreationContext*)context;

@property SuggestionCreator *nextCreator;
@property Settings *settings;

@end
