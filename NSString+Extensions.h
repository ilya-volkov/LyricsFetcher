#import <Foundation/Foundation.h>


@interface NSString (Extensions)

- (NSString*)truncateTail:(NSUInteger)maxCount;
- (NSString*)truncateTailWithEllipsis:(NSUInteger)maxCount;
- (BOOL)isEqualToStringIgnoreWhitespace:(NSString*)string;

@end
