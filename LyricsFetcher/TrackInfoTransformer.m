#import "TrackInfoTransformer.h"
#import "TrackInfo.h"
#import "NSString+Extensions.h"

@implementation TrackInfoTransformer

+ (Class)transformedValueClass { 
    return [NSString class]; 
}

+ (BOOL)allowsReverseTransformation { 
    return NO; 
}

- (id)transformedValue:(id)value {
    if (value == nil)
        return NSLocalizedStringFromTable(@"CurrentTrackInfoNotExists", @"InfoPlist", nil);
    
    TrackInfo* trackInfo = (TrackInfo*)value;

    return [[NSString stringWithFormat:@"%@: %@", trackInfo.artist, trackInfo.name] 
        truncateTailWithEllipsis:40
    ];
}

@end
