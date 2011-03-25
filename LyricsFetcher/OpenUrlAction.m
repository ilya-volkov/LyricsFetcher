#import "OpenUrlAction.h"

@implementation OpenUrlAction

@synthesize url;

-(id)initWithURL:(NSURL*)url callback:(void(^)())callback {
    self = [super initWithCallback:callback];
    if (self != nil) {
        self.url = url;
    }
    
    return self;
}

-(void)perform {
    [[NSWorkspace sharedWorkspace] openURL:self.url];
    [super perform];
}

@end
