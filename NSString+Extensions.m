#import "NSString+Extensions.h"


@implementation NSString (Extensions)

-(NSString*)truncateTail:(NSUInteger)maxCount {
    return [self length] > maxCount ? [self substringToIndex:maxCount] : self;
}

-(NSString*)truncateTailWithEllipsis:(NSUInteger)maxCount {
    if ([self length] > maxCount)
        return [NSString stringWithFormat:@"%@...", [self substringToIndex:maxCount]];
    else
        return self;
}

@end
