#import <Foundation/Foundation.h>

typedef void (^ParameterlessCallback)();

@class TrackInfo;

@interface Action : NSObject

+(Action*)actionWithURL:(NSURL*)url beforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback;
+(Action*)actionWithTrackInfo:(TrackInfo*)track beforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback;

-(id)initWithBeforeCallback:(ParameterlessCallback)beforeCallback afterCallback:(ParameterlessCallback)afterCallback;
-(void)perform;
-(void)performCore;

@property (copy) ParameterlessCallback beforeCallback;
@property (copy) ParameterlessCallback afterCallback;

@end
