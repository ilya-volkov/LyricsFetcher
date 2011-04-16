#import "SearchLyricsResult.h"


@implementation SearchLyricsResult

@synthesize trackId;
@synthesize lyricsId;
@synthesize lyricsUrl;
@synthesize lyricsCorrectUrl;
@synthesize lyrics;

+ (SearchLyricsResult*) searchResultWithDictionary:(NSDictionary*)dictionary {
	SearchLyricsResult *result = [SearchLyricsResult new];
    
    NSNumber *n1 = [NSNumber numberWithInt:[[dictionary objectForKey:@"TrackId"] intValue]];
	result.trackId		    = n1;
    NSNumber *n2 = [NSNumber numberWithInt:[[dictionary objectForKey:@"LyricId"] intValue]];
	result.lyricsId		    = n2;
	result.lyricsUrl	    = [NSURL URLWithString:[dictionary objectForKey:@"LyricUrl"]];
	result.lyricsCorrectUrl = [NSURL URLWithString:[dictionary objectForKey:@"LyricCorrectUrl"]];
    NSString *unescapedLyrics = [dictionary objectForKey:@"Lyric"];
	
    result.lyrics = (NSString*)CFXMLCreateStringByUnescapingEntities(NULL, (CFStringRef)unescapedLyrics, NULL);
        
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
