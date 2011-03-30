#import "SuggestionCreator.h"
#import "Settings.h"
#import "Suggestion.h"
#import "SuggestionCreationContext.h"

@implementation SuggestionCreator

@synthesize nextCreator;
@synthesize settings;

- (id)initWithSettings:(Settings*)settings nextCreator:(SuggestionCreator*)creator {
    self = [super init];    
    if (self != nil) {
        self.settings = settings;
        self.nextCreator = creator;
    }
    
    return self;
}

- (Suggestion*)createWithContext:(SuggestionCreationContext*)context {
    Suggestion* suggestion = [self createWithContextCore:context];
    if (suggestion == nil)
        return [self.nextCreator createWithContext:context];
    
    return suggestion;
}

@end
