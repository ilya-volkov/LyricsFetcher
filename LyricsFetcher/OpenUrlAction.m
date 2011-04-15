#import "OpenUrlAction.h"

@implementation OpenUrlAction

@synthesize url;

-(id)initWithURL:(NSURL*)url beforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback {
    self = [super initWithBeforeCallback:beforeCallback afterCallback:afterCallback];
    if (self != nil) {
        self.url = url;
    }
    
    return self;
}

-(void)performCore {
    [[NSWorkspace sharedWorkspace] openURL:self.url];
}

@end
