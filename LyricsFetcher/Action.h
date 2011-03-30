#import <Foundation/Foundation.h>

typedef void (^ParameterlessCallback)();

@class TrackInfo;

@interface Action : NSObject

+(Action*)actionWithURL:(NSURL*)url callback:(ParameterlessCallback)callback;
+(Action*)actionWithTrackInfo:(TrackInfo*)track callback:(ParameterlessCallback)callback;

-(id)initWithCallback:(ParameterlessCallback)callback;
-(void)perform;

@property (copy) ParameterlessCallback actionCallback;

@end
