#import "HTTPGETChartLyricsLyricsProvider.h"
#import "SearchLyricsResult.h"
#import "NSString+Extensions.h"


@implementation HTTPGETChartLyricsLyricsProvider

- (void)addObjectValueFrom:(NSString*)nodeName withParent:(NSXMLElement*)parent to:(NSMutableDictionary*)dictionary {
    NSXMLElement *element = [[parent elementsForName:nodeName] lastObject];
    [dictionary setObject:[element objectValue] forKey:nodeName];
}

- (SearchLyricsResult*) processReceivedData:(NSData*)data {
    if (data == nil)
        return nil;
    
    NSError *error = nil;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:0 error:&error];
    if (document == nil)
        return nil;
    
    NSXMLElement *root = [document rootElement];   
    if (![[root name] isEqualToString:@"GetLyricResult"])
        return nil;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSArray *names = [NSArray arrayWithObjects:@"TrackId", @"LyricId", @"LyricUrl", @"LyricCorrectUrl", @"Lyric", nil];
    for (NSString *nodeName in names) {
        [self addObjectValueFrom:nodeName withParent:root to:dict];
    }
    
    return [SearchLyricsResult searchResultWithDictionary:dict];
}

- (NSString*) prepareParameter:(NSString*)value maxLength:(NSUInteger)maxLength {
    return [
        [value truncateTail:maxLength] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding
    ];
}

- (NSURL*) buildRequestURLFor:(NSString*)song by:(NSString*)artist {
    NSString *songParam = [self prepareParameter:song maxLength:125];
    NSString *artistParam = [self prepareParameter:artist maxLength:75];
    
    return [NSURL URLWithString:
            [NSString stringWithFormat:@"http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist=%@&song=%@", 
                artistParam,
                songParam
             ]
            ];
}

- (SearchLyricsResult*) loadLyricsFor:(NSString*)song by:(NSString*)artist {   
    NSURLRequest *request = [NSURLRequest requestWithURL: [self buildRequestURLFor:song by:artist] 
                                             cachePolicy: NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval: 20.0
                             ];
    
    NSHTTPURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest: request 
                                         returningResponse: &response 
                                                     error: nil
                    ];
    
    if ([response statusCode] >= 200 && [response statusCode] < 300)
        return [self processReceivedData:data];
    
    return nil;
}

- (SearchLyricsResult*) searchLyricsFor:(NSString*)song by:(NSString*)artist {
    return [self loadLyricsFor:song by:artist];
}

- (void)beginSearchLyricsFor:(NSString*)song by:(NSString*)artist callback:(SearchLyricsCallback)callback {
    SearchLyricsCallback operationCallback = [callback copy];
    
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        SearchLyricsResult *result = [self loadLyricsFor:song by:artist];
        operationCallback(result);
    }];
    
    [operation start];    
}

@end
