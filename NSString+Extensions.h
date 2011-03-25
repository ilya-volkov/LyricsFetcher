#import <Foundation/Foundation.h>


@interface NSString (Extensions)

-(NSString*)truncateTail:(NSUInteger)maxCount;
-(NSString*)truncateTailWithEllipsis:(NSUInteger)maxCount;

@end
