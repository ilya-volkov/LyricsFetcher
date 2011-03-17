#import "TrackInfo.h"
#import "iTunes.h"

@implementation TrackInfo

@synthesize id;
@synthesize name;
@synthesize artist;
@synthesize album;
@synthesize lyrics;
@synthesize artwork;

+ (TrackInfo*)trackInfoWithiTunesTrack:(iTunesTrack*)track {
    return [[TrackInfo alloc] initWithiTunesTrack:track];
}

- (id)initWithiTunesTrack:(iTunesTrack *)track {
    self = [super init];
    if (self != nil) {
        self.id = [NSNumber numberWithUnsignedInteger:track.databaseID];
        self.name = track.name;
        self.artist = track.artist;
        self.album = track.album;
        self.lyrics = track.lyrics;
        
        int artworksCount = [[track artworks] count];
        if (artworksCount > 0)
            self.artwork = [(iTunesArtwork*)[[track artworks] objectAtIndex:0] data];
                
        internalTrack = track;
    }
    
    return self;
}

- (void)update {
    if ([internalTrack exists])
        internalTrack.lyrics = self.lyrics;
}

@end
