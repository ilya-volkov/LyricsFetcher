#import <Cocoa/Cocoa.h>


@interface SearchLyricsResult : NSObject

@property (copy) NSNumber *trackId;
@property (copy) NSNumber *lyricsId;
@property (copy) NSURL    *lyricsUrl;
@property (copy) NSURL    *lyricsCorrectUrl;
@property (copy) NSString *lyrics;

+ (SearchLyricsResult*) searchResultWithDictionary:(NSDictionary*)dictionary;

@end
