#import "SearchLyricsResult.h"


@implementation SearchLyricsResult

@synthesize trackId;
@synthesize lyricsId;
@synthesize lyricsUrl;
@synthesize lyricsCorrectUrl;
@synthesize lyrics;

+ (SearchLyricsResult*) searchResultWithDictionary:(NSDictionary*)dictionary {
	SearchLyricsResult *result = [SearchLyricsResult new];
    
	result.trackId		    = [dictionary objectForKey:@"TrackId"];
	result.lyricsId		    = [dictionary objectForKey:@"LyricId"];
	result.lyricsUrl	    = [NSURL URLWithString:[dictionary objectForKey:@"LyricUrl"]];
	result.lyricsCorrectUrl = [NSURL URLWithString:[dictionary objectForKey:@"LyricCorrectUrl"]];
	result.lyrics			= (NSNull*)[dictionary objectForKey:@"Lyric"] == [NSNull null] ? [NSString string] 
                                                                                           : [dictionary objectForKey:@"Lyric"];
	
    return result;
}

-(BOOL)canAddLyrics {
    return [self.trackId intValue] != 0 &&
           [self.lyricsId intValue] == 0;
}

-(BOOL)canCorrectLyrics {
    return [self.lyricsId intValue] != 0;
}

-(NSURL*)lyricsAddUrl {
    return self.lyricsUrl;
}

@end
