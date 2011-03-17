#import "NSArray+Extensions.h"


@implementation NSArray (Extensions)

- (id) objectPassingTest:(BOOL(^)(id obj))predicate {
    NSUInteger index = [self  indexOfObjectPassingTest:^(id obj, NSUInteger index, BOOL *stop) { 
        return predicate(obj);
    }];
    
    if (index == NSNotFound)
        return nil;
    
    
    return [self objectAtIndex:index];
}

@end
