#import "GradientView.h"

@implementation GradientView

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *startColor = [NSColor blackColor];
    NSColor *endColor = [NSColor colorWithCalibratedRed:.50 green:.50 blue:.50 alpha:1.0];
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    [gradient drawInRect:[self bounds] angle:270.0];
}

@end
