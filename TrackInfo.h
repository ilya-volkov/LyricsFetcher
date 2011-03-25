#import <Foundation/Foundation.h>


@class iTunesTrack;

@interface TrackInfo : NSObject {
@private
    
    iTunesTrack *internalTrack;
}

+ (TrackInfo*)trackInfoWithiTunesTrack:(iTunesTrack*)track;

- (id)initWithiTunesTrack:(iTunesTrack*)track;
- (void)update;

@property (copy) NSNumber *id;
@property (copy) NSString *name;
@property (copy) NSString *artist;
@property (copy) NSString *album;
@property (copy) NSString *lyrics;
@property (copy) NSImage  *artwork;
@end
