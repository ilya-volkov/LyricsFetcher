#import "Action.h"
#import "TrackInfo.h"
#import "OpenUrlAction.h"
#import "SearchTrackLyricsByGoogleAction.h"

@implementation Action

@synthesize beforeCallback;
@synthesize afterCallback;

+(Action*)actionWithURL:(NSURL*)url beforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback {
    return [[OpenUrlAction alloc] initWithURL:url beforeCallback:beforeCallback afterCallback:afterCallback];
}

+(Action*)actionWithTrackInfo:(TrackInfo*)track beforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback {
    return [[SearchTrackLyricsByGoogleAction alloc] initWithTrackInfo:track beforeCallback:beforeCallback afterCallback:afterCallback];
}

-(id)initWithBeforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback {
    self = [super init];
    if (self != nil) {
        self.beforeCallback = beforeCallback;
        self.afterCallback = afterCallback;
    }
    
    return self;
}

-(void)perform {
    if (self.beforeCallback != nil)
        self.beforeCallback();
    
    [self performCore];
    
    if (self.afterCallback != nil)
        self.afterCallback();
}

@end
