#import <Foundation/Foundation.h>
#import "OpenUrlAction.h"

@class TrackInfo;

@interface SearchTrackLyricsByGoogleAction : OpenUrlAction

-(id)initWithTrackInfo:(TrackInfo*)track beforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback;

@property TrackInfo* track;

@end
