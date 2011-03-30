#import <Foundation/Foundation.h>

#import "Action.h"

@interface Suggestion : NSObject

+ (Suggestion*)suggestionWithMessage:(NSString*)message action:(Action*)action acceptCallback:(ParameterlessCallback)acceptCallback declineCallback:(ParameterlessCallback)declineCallback;

- (id)initWithMessage:(NSString*)message action:(Action*)action acceptCallback:(ParameterlessCallback)acceptCallback declineCallback:(ParameterlessCallback)declineCallback;
- (void)accept;
- (void)decline;

@property (copy) NSString *message;
@property Action *action;
@property (copy) ParameterlessCallback acceptCallback;
@property (copy) ParameterlessCallback declineCallback;

@end
