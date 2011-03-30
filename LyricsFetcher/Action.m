#import "Action.h"
#import "TrackInfo.h"
#import "OpenUrlAction.h"
#import "SearchTrackLyricsByGoogleAction.h"

@implementation Action

@synthesize actionCallback;

+(Action*)actionWithURL:(NSURL*)url callback:(ParameterlessCallback)callback {
    return [[OpenUrlAction alloc] initWithURL:url callback:callback];
}

+(Action*)actionWithTrackInfo:(TrackInfo*)track callback:(ParameterlessCallback)callback {
    return [[SearchTrackLyricsByGoogleAction alloc] initWithTrackInfo:track callback:callback];
}

-(id)initWithCallback:(ParameterlessCallback)callback {
    self = [super init];
    if (self != nil) {
        self.actionCallback = callback;
    }
    
    return self;
}

-(void)perform {
    if (self.actionCallback != nil)
        self.actionCallback();
}

@end
