#import "NSString+Extensions.h"


@implementation NSString (Extensions)

- (NSString*)truncateTail:(NSUInteger)maxCount {
    return [self length] > maxCount ? [self substringToIndex:maxCount] : self;
}

- (NSString*)truncateTailWithEllipsis:(NSUInteger)maxCount {
    if ([self length] > maxCount)
        return [NSString stringWithFormat:@"%@...", [self substringToIndex:maxCount]];
    else
        return self;
}

- (BOOL)isEqualToStringIgnoreWhitespace:(NSString *)string {
    NSArray *firstComponents = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstStringWithoutWhatespaces = [firstComponents componentsJoinedByString:[NSString string]];
    
    NSArray *secondComponents = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *secondStringWithoutWhatespaces = [secondComponents componentsJoinedByString:[NSString string]];
    
    return [firstStringWithoutWhatespaces isEqualToString:secondStringWithoutWhatespaces];
}

@end
