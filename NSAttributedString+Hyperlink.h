#import <Foundation/Foundation.h>


@interface NSAttributedString (Hyperlink)

+ (NSAttributedString*)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end
