#import <Cocoa/Cocoa.h>


@class SearchLyricsResult;

typedef void (^SearchLyricsCallback)(SearchLyricsResult *result);

@interface HTTPGETChartLyricsLyricsProvider : NSObject <NSXMLParserDelegate>

- (SearchLyricsResult*) searchLyricsFor: (NSString*)song by: (NSString*)artist;
- (void) beginSearchLyricsFor: (NSString*)song by: (NSString*)artist callback:(SearchLyricsCallback)callback;

@end
