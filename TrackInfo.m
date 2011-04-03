#import "TrackInfo.h"
#import "iTunes.h"
#import "SearchLyricsResult.h"

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

- (void)syncWithSearchResult:(SearchLyricsResult*)searchResult {
    [self syncWithSearchResult:searchResult overridingExistingValues:false];
}

- (void)syncWithSearchResult:(SearchLyricsResult*)searchResult overridingExistingValues:(BOOL)override {
    if (searchResult == nil)
        return;
        
    if ([self.lyrics length] == 0 || override)
        self.lyrics = searchResult.lyrics;
}

- (BOOL)isEqualToTrackInfo:(TrackInfo *)track {
    if (track == nil)
        return false;
    
    return [self.id isEqualToNumber:track.id];
}

- (NSString*)handleNil:(NSString*)string {
    return string != nil ? string : [NSString string];
}

- (id)initWithiTunesTrack:(iTunesTrack *)track {
    self = [super init];
    if (self != nil) {
        self.id = [NSNumber numberWithUnsignedInteger:track.databaseID];
        self.name = [self handleNil:track.name];
        self.artist = [self handleNil:track.artist];
        self.album = [self handleNil:track.album];
        self.lyrics = [self handleNil:track.lyrics];
        
        if ([[track artworks] count] > 0)
            self.artwork = [(iTunesArtwork*)[[track artworks] objectAtIndex:0] data];
                
        internalTrack = track;
    }
    
    return self;
}

- (void)update {
    if (![internalTrack exists])
        return;
    
    if(![internalTrack.lyrics isEqualToString:self.lyrics]) {
        internalTrack.lyrics = self.lyrics == nil ? [NSString string] : self.lyrics;
    }
}

- (void)reset {    
    self.lyrics = internalTrack.lyrics;
}

@end
