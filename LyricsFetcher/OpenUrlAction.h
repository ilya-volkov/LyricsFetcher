#import <Foundation/Foundation.h>
#import "Action.h"

@interface OpenUrlAction : Action

-(id)initWithURL:(NSURL*)url callback:(void(^)())callback;

@property NSURL *url;

@end
