#import "SearchTrackLyricsByGoogleAction.h"
#import "TrackInfo.h"
#import "Action.h"

@implementation SearchTrackLyricsByGoogleAction

@synthesize track;

-(id)initWithTrackInfo:(TrackInfo*)track callback:(void(^)())callback {
    self = [super initWithCallback:callback];
    if (self != nil) {
        self.track = track;
    }
    
    return self;
}

- (void)perform {
    NSString *displayString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@ %@ lyrics", track.name, track.artist];
    
    self.url = [NSURL URLWithString:
        [displayString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    ];
    
    [super perform];
}

@end
