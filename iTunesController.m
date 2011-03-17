#import "iTunesController.h"
#import "TrackInfo.h"
#import "iTunes.h"
#import "NSArray+Extensions.h"


@implementation iTunesController

@synthesize delegate;

+ (iTunesController*)controllerWithDelegate:(id<iTunesControllerDelegate>)delegate {
    return [[iTunesController alloc] initWithDelegate:delegate];
}

- (id)initWithDelegate:(id<iTunesControllerDelegate>)delegate {
    self = [super init];
    if (self != nil) {
        self.delegate = delegate;
        
        [[NSDistributedNotificationCenter defaultCenter] addObserver: self 
                                                            selector: @selector(iTunesStateChanged:) 
                                                                name: @"com.apple.iTunes.playerInfo" 
                                                              object: nil
         ];
    }
    
    return self;
}

- (id)init {
    return [self initWithDelegate:nil];
}

- (iTunesApplication *) getiTunes {
	return [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
}

- (void) iTunesStateChanged:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	NSString *state = [userInfo objectForKey:@"Player State"];
    NSLog(@"Player state %@", state);
	if (![state isEqualToString:@"Playing"])
		return;
	
    if (delegate != nil)
        [self.delegate currentTrackChangedTo:[self getCurrentTrack]];
}

- (iTunesTrack*)find:(iTunesTrack*)track in:(iTunesPlaylist*)playlist {
    NSArray *tracks = [[playlist tracks] get];
    
    return (iTunesTrack*)[tracks objectPassingTest:^(id obj) {
        return (BOOL)(((iTunesTrack*)obj).databaseID == track.databaseID);
    }];
}

- (TrackInfo*)getCurrentTrack {
    iTunesApplication *iTunes = [self getiTunes];
	if (![iTunes isRunning])
		return nil;
    
    iTunesTrack* currentTrack = iTunes.currentTrack;
    if (![currentTrack exists])
        return nil;
    
    iTunesPlaylist* playlist = iTunes.currentPlaylist;
    iTunesTrack* track = [self find:currentTrack in:playlist];
    
    if (track == nil)
        return nil;
    
    return [TrackInfo trackInfoWithiTunesTrack:track];
}

- (void)finalize {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    
    [super finalize];
}

@end
