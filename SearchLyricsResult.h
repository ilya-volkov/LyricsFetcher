#import <Cocoa/Cocoa.h>


@interface SearchLyricsResult : NSObject

+(SearchLyricsResult*)searchResultWithDictionary:(NSDictionary*)dictionary;

-(BOOL)canAddLyrics;
-(BOOL)canCorrectLyrics;

@property (copy) NSNumber *trackId;
@property (copy) NSNumber *lyricsId;
@property (copy) NSURL    *lyricsUrl;
@property (copy) NSURL    *lyricsCorrectUrl;
@property (copy) NSString *lyrics;
@property (readonly) NSURL *lyricsAddUrl;

@end
