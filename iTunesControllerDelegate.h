#import <Foundation/Foundation.h>
#import "TrackInfo.h"

@protocol iTunesControllerDelegate <NSObject>

- (void)currentTrackChangedTo:(TrackInfo*)track;

@end
