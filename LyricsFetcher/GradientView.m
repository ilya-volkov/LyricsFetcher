#import "GradientView.h"

@implementation GradientView

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *color = [NSColor colorWithCalibratedRed:.972 green:.929 blue:.713 alpha:1.0];
    [color setFill];
    [NSBezierPath fillRect:[self bounds]];
}

@end
