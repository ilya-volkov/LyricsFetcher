#import <Foundation/Foundation.h>

@class TrackInfo;

@interface Action : NSObject {
@private
    void (^actionCallback)();
}

+(Action*)actionWithURL:(NSURL*)url callback:(void(^)())callback;
+(Action*)actionWithTrackInfo:(TrackInfo*)track callback:(void(^)())callback;

-(id)initWithCallback:(void(^)())callback;
-(void)perform;

@property (readonly) BOOL valid;

@end
