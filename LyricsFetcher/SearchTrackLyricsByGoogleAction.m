#import "SearchTrackLyricsByGoogleAction.h"
#import "TrackInfo.h"
#import "Action.h"

@implementation SearchTrackLyricsByGoogleAction

@synthesize track;

-(id)initWithTrackInfo:(TrackInfo*)track beforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback {
    self = [super initWithBeforeCallback:beforeCallback afterCallback:afterCallback];
    if (self != nil) {
        self.track = track;
    }
    
    return self;
}

- (void)performCore {
    NSString *displayString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@ %@ lyrics", track.name, track.artist];
    
    self.url = [NSURL URLWithString:
        [displayString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    ];
    
    [super performCore];
}

@end
