#import <Foundation/Foundation.h>
#import "iTunesControllerDelegate.h"

@class TrackInfo;

@interface iTunesController : NSObject

+ (iTunesController*)controllerWithDelegate:(id<iTunesControllerDelegate>)delegate;

- (TrackInfo*)getCurrentTrack;
- (id)initWithDelegate:(id<iTunesControllerDelegate>)delegate;

@property id<iTunesControllerDelegate> delegate;

@end
