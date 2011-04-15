#import <Foundation/Foundation.h>
#import "Action.h"

@interface OpenUrlAction : Action

-(id)initWithURL:(NSURL*)url beforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback;

@property (copy) NSURL *url;

@end
