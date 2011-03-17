#import <Foundation/Foundation.h>


@interface NSArray (Extensions)

- (id) objectPassingTest:(BOOL(^)(id obj))predicate;

@end
