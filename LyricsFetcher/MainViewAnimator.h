#import <Foundation/Foundation.h>


@interface MainViewAnimator : NSObject {
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

+ (MainViewAnimator*)animatorWithSuggestion:(NSView*)suggestion lyricsText:(NSView*)lyricsText editButtons:(NSView*)editButtons;

- (id)initWithSuggestion:(NSView*)suggestion lyricsText:(NSView*)lyricsText editButtons:(NSView*)editButtons;
- (void)hideSuggestion;
- (void)showSuggestion;
- (void)hideEditButtons;
- (void)showEditButtons;
- (void)beginGrouping;
- (void)animateGroup;
- (void)hideSuggestionImmediately;
- (void)hideEditButtonsImmediately;

@property CGFloat animationDuration;

@end
