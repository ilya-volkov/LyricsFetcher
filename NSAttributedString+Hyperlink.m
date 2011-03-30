#import "NSAttributedString+Hyperlink.h"


@implementation NSAttributedString (Hyperlink)

+ (NSAttributedString*)hyperlinkFromString:(NSString*)string withURL:(NSURL*)url {
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, [attributedString length]);
    
    [attributedString beginEditing];
    [attributedString addAttribute:NSLinkAttributeName value:[url absoluteString] range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
    [attributedString endEditing];
    
    return attributedString;
}

@end

