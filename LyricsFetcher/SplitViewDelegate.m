#import "SplitViewDelegate.h"


@implementation SplitViewDelegate

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    NSView *subview = [[splitView subviews] objectAtIndex:dividerIndex];
    NSRect subviewFrame = [subview frame];
    
    return subviewFrame.origin.y + subviewFrame.size.height;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
    NSView *subview = [[splitView subviews] objectAtIndex:dividerIndex];
    NSRect subviewFrame = [subview frame];
    
    return subviewFrame.origin.y + subviewFrame.size.height;
}

- (void)resizeView:(NSView*)view withWidthDelta:(CGFloat)width heightDelta:(CGFloat)height originYDelta:(CGFloat)y  {
    NSRect frame = [view frame];
    
    frame.size.height += height;
    frame.size.width += width;
    frame.origin.y += y;
    
    [view setFrame:frame];
}

/*- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize {
    NSView *firstSubview = [[splitView subviews] objectAtIndex:0];
    NSView *mainSubview = [[splitView subviews] objectAtIndex:1];
    NSView *lastSubview = [[splitView subviews] objectAtIndex:2];
    
    CGSize newSize = [splitView frame].size;
    CGFloat xDelta = newSize.width - oldSize.width;
    CGFloat yDelta = newSize.height - newSize.height;
    
    [self resizeView:firstSubview withWidthDelta:xDelta heightDelta:0 originYDelta:0];
    [self resizeView:mainSubview withWidthDelta:xDelta heightDelta:yDelta originYDelta:0];
    [self resizeView:lastSubview withWidthDelta:xDelta heightDelta:0 originYDelta:yDelta];
}*/

@end
