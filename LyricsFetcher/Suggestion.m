#import "Suggestion.h"


@implementation Suggestion

@synthesize message;
@synthesize action;
@synthesize acceptCallback;
@synthesize declineCallback;

+ (Suggestion*)suggestionWithMessage: (NSString*)message 
                              action: (Action*)action 
                      acceptCallback: (ParameterlessCallback)acceptCallback 
                     declineCallback: (ParameterlessCallback)declineCallback 
{
    return [[Suggestion alloc] initWithMessage: message 
                                        action: action 
                                acceptCallback: acceptCallback 
                               declineCallback: declineCallback];
}

- (id)initWithMessage: (NSString*)message 
               action: (Action*)action 
       acceptCallback: (ParameterlessCallback)acceptCallback 
      declineCallback: (ParameterlessCallback)declineCallback
{
    self = [super init];
    if (self != nil) {
        self.message = message;
        self.action = action;
        self.acceptCallback = acceptCallback;
        self.declineCallback = declineCallback;
    }
    
    return self;
}

- (void)accept {
    [self.action perform];
    
    if (acceptCallback != nil)
        acceptCallback();
}

- (void)decline {
    if (declineCallback != nil)
        declineCallback();
}

@end
