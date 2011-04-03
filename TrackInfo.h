#import <Foundation/Foundation.h>


@class iTunesTrack;
@class SearchLyricsResult;

@interface TrackInfo : NSObject {
@private
    
    iTunesTrack *internalTrack;
}

+ (TrackInfo*)trackInfoWithiTunesTrack:(iTunesTrack*)track;

- (id)initWithiTunesTrack:(iTunesTrack*)track;
- (void)update;
- (void)reset;
- (BOOL)isEqualToTrackInfo:(TrackInfo*)track;
- (void)syncWithSearchResult:(SearchLyricsResult*)searchResult;
- (void)syncWithSearchResult:(SearchLyricsResult*)searchResult overridingExistingValues:(BOOL)override;

@property (copy) NSNumber *id;
@property (copy) NSString *name;
@property (copy) NSString *artist;
@property (copy) NSString *album;
@property (copy) NSString *lyrics;
@property (copy) NSImage  *artwork;
@end
