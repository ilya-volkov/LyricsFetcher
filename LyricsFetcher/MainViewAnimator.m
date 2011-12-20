#import "MainViewAnimator.h"


@implementation MainViewAnimator {
@private
    NSView *suggestionView;
    NSView *lyricsTextView;
    NSView *editButtonsView;
    CGFloat suggestionViewHeight;
    CGFloat editButtonsViewHeight;
    BOOL groupingMode;
    NSRect suggestionFrame;
    NSRect lyricsFrame;
    NSRect editButtonsFrame;
}

@synthesize animationDuration;

+ (MainViewAnimator*)animatorWithSuggestion:(NSView*)suggestion lyricsText:(NSView*)lyricsText editButtons:(NSView*)editButtons {
    return [[MainViewAnimator alloc] initWithSuggestion:suggestion lyricsText:lyricsText editButtons:editButtons];
}

- (id)initWithSuggestion:(NSView*)suggestion lyricsText:(NSView*)lyricsText editButtons:(NSView*)editButtons {
    self = [super init];
    if (self != nil) {
        suggestionView = suggestion;
        lyricsTextView = lyricsText;
        editButtonsView = editButtons;
        editButtonsViewHeight = [editButtons frame].size.height;
        suggestionViewHeight = [suggestion frame].size.height;
    
        self.animationDuration = .5;
        groupingMode = false;
        suggestionFrame = NSMakeRect(0, 0, 0, 0);
        lyricsFrame = NSMakeRect(0, 0, 0, 0);
        editButtonsFrame = NSMakeRect(0, 0, 0, 0);
    }
    
    return self;
}

- (BOOL)isViewClosed:(NSView*)view {
    return !CGRectIntersectsRect(NSRectToCGRect([view frame]), NSRectToCGRect([[view superview] bounds]));
}

- (void)hideSuggestionImmediately {
    if ([self isViewClosed:suggestionView])
        return;
    
    suggestionFrame = [suggestionView frame];
    lyricsFrame = [lyricsTextView frame];

    lyricsFrame.size.height += suggestionViewHeight;
    suggestionFrame.origin.y += suggestionViewHeight;

    [suggestionView setFrame:suggestionFrame];
    [lyricsTextView setFrame:lyricsFrame];
}

- (void)hideEditButtonsImmediately {
    if ([self isViewClosed:editButtonsView])
        return;
    
    editButtonsFrame = [editButtonsView frame];
    lyricsFrame = [lyricsTextView frame];

    lyricsFrame.size.height += editButtonsViewHeight;
    lyricsFrame.origin.y = 0;
    editButtonsFrame.origin.y -= editButtonsViewHeight;

    [editButtonsView setFrame:editButtonsFrame];
    [lyricsTextView setFrame:lyricsFrame];
}

- (void)hideSuggestion {
    if ([self isViewClosed:suggestionView])
        return;
    
    if (!groupingMode) {
        suggestionFrame = [suggestionView frame];
        lyricsFrame = [lyricsTextView frame];
    }
    
    lyricsFrame.size.height += suggestionViewHeight;
    suggestionFrame.origin.y += suggestionViewHeight;
    
    if (groupingMode)
        return;
    
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:self.animationDuration];
	[[suggestionView animator] setFrame:suggestionFrame];
   	[[lyricsTextView animator] setFrame:lyricsFrame];
	[NSAnimationContext endGrouping];
}

- (void)showSuggestion {
    if (![self isViewClosed:suggestionView])
        return;
    
    if (!groupingMode) {
        suggestionFrame = [suggestionView frame];
        lyricsFrame = [lyricsTextView frame];
    }
    
    lyricsFrame.size.height -= suggestionViewHeight;
    suggestionFrame.origin.y -= suggestionViewHeight;
    
    if (groupingMode)
        return;
    
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:self.animationDuration];
	[[suggestionView animator] setFrame:suggestionFrame];
   	[[lyricsTextView animator] setFrame:lyricsFrame];
	[NSAnimationContext endGrouping];
}

- (void)hideEditButtons {
    if ([self isViewClosed:editButtonsView])
        return;
    
    if (!groupingMode) {
        editButtonsFrame = [editButtonsView frame];
        lyricsFrame = [lyricsTextView frame];
    }
    
    lyricsFrame.size.height += editButtonsViewHeight;
    lyricsFrame.origin.y = 0;
    editButtonsFrame.origin.y -= editButtonsViewHeight;
    
    if (groupingMode)
        return;
    
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:self.animationDuration];
	[[editButtonsView animator] setFrame:editButtonsFrame];
   	[[lyricsTextView animator] setFrame:lyricsFrame];
	[NSAnimationContext endGrouping];
}

- (void)showEditButtons {
    if (![self isViewClosed:editButtonsView])
        return;
    
    if (!groupingMode) {
        editButtonsFrame = [editButtonsView frame];
        lyricsFrame = [lyricsTextView frame];
    }
    
    lyricsFrame.size.height -= editButtonsViewHeight;
    lyricsFrame.origin.y = editButtonsViewHeight;
    editButtonsFrame.origin.y = 0;
    
    if (groupingMode)
        return;
    
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:self.animationDuration];
	[[editButtonsView animator] setFrame:editButtonsFrame];
   	[[lyricsTextView animator] setFrame:lyricsFrame];
	[NSAnimationContext endGrouping];
}

- (void)beginGrouping {
    groupingMode = true;
    suggestionFrame = [suggestionView frame];
    lyricsFrame = [lyricsTextView frame];
    editButtonsFrame = [editButtonsView frame];
}

- (void)animateGroup {
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:self.animationDuration];
    [[suggestionView animator] setFrame:suggestionFrame];
   	[[lyricsTextView animator] setFrame:lyricsFrame];
  	[[editButtonsView animator] setFrame:editButtonsFrame];
	[NSAnimationContext endGrouping];
    
    groupingMode = false;
}

@end