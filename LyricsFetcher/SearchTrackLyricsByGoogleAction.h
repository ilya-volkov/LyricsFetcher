#import <Foundation/Foundation.h>
#import "OpenUrlAction.h"

@class TrackInfo;

@interface SearchTrackLyricsByGoogleAction : OpenUrlAction

-(id)initWithTrackInfo:(TrackInfo*)track callback:(void(^)())callback;

@property TrackInfo* track;

@end
