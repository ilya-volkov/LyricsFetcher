#import "Action.h"
#import "TrackInfo.h"
#import "OpenUrlAction.h"
#import "SearchTrackLyricsByGoogleAction.h"

@implementation Action

+(Action*)actionWithURL:(NSURL*)url callback:(void(^)())callback {
    return [[OpenUrlAction alloc] initWithURL:url callback:callback];
}

+(Action*)actionWithTrackInfo:(TrackInfo*)track callback:(void(^)())callback {
    return [[SearchTrackLyricsByGoogleAction alloc] initWithTrackInfo:track callback:callback];
}

-(id)initWithCallback:(void(^)())callback {
    self = [super init];
    if (self != nil) {
        actionCallback = [callback copy];
    }
    
    return self;
}

-(void)perform {
    if (actionCallback != nil)
        actionCallback();
}

- (BOOL)valid {
    return true;
}

@end
