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
	result.lyrics			= [dictionary objectForKey:@"Lyric"];
	
    return result;
}

@end
