#import <Foundation/Foundation.h>


@interface MainViewAnimator : NSObject

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
