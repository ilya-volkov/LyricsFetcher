#import "ChartLyricsLyricsProvider.h"
#import "SearchLyricsResult.h"
#import "NSString+Extensions.h"

@implementation ChartLyricsLyricsProvider

+ (SearchLyricsResult*) handleResult:(NSDictionary*)result {
	if (WSMethodResultIsFault((CFDictionaryRef)result))
		return nil;
	
	NSDictionary *response = [result objectForKey:(id)kWSMethodInvocationResult];
	NSDictionary *invocationResult = [response objectForKey:@"SearchLyricDirectResult"];
	
	return [SearchLyricsResult searchResultWithDictionary:invocationResult];
}

void invocationCallback(WSMethodInvocationRef invocation, void *info, CFDictionaryRef outRef) {
	((SearchLyricsCallback)info)([ChartLyricsLyricsProvider handleResult:(NSDictionary*)outRef]);
	[[NSGarbageCollector defaultCollector] enableCollectorForPointer:info];
}

- (WSMethodInvocationRef) buildInvocationReferenceForMethod:(NSString*)methodName withArguments:(NSDictionary*)args {
	NSString *namespace = @"http://api.chartlyrics.com/";
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@apiv1.asmx", namespace]];
	
	WSMethodInvocationRef ref = WSMethodInvocationCreate(
		(CFURLRef)url, 
		(CFStringRef)methodName, 
		kWSSOAP2001Protocol
	);
	
	WSMethodInvocationSetParameters(ref, (CFDictionaryRef)args, (CFArrayRef)[args allKeys]);
	
    NSDictionary *headers = [NSDictionary 
		dictionaryWithObject: [NSString stringWithFormat:@"%@%@", namespace, methodName] 
				      forKey: @"SOAPAction"
	];
	
    WSMethodInvocationSetProperty(ref, kWSSOAPMethodNamespaceURI, (CFStringRef)namespace);
    WSMethodInvocationSetProperty(ref, kWSHTTPExtraHeaders, (CFDictionaryRef)headers);
    WSMethodInvocationSetProperty(ref, kWSHTTPFollowsRedirects, kCFBooleanTrue);
	WSMethodInvocationSetProperty(ref, kWSMethodInvocationTimeoutValue, (CFNumberRef)[NSNumber numberWithInt: 20]);
	
	// set debug properties
    WSMethodInvocationSetProperty(ref, kWSDebugIncomingBody, kCFBooleanTrue);
    WSMethodInvocationSetProperty(ref, kWSDebugIncomingHeaders, kCFBooleanTrue);
    WSMethodInvocationSetProperty(ref, kWSDebugOutgoingBody, kCFBooleanTrue);
    WSMethodInvocationSetProperty(ref, kWSDebugOutgoingHeaders, kCFBooleanTrue);

	return ref;	
}

- (WSMethodInvocationRef) buildSearchLyricsMethodInvocationReferenceFor:(NSString*)song by:(NSString*)artist {
	NSString *artistArg = [artist truncateTail:75];
	NSString *songArg   = [song truncateTail:125];
	
	NSDictionary *args = [NSDictionary 
		dictionaryWithObjects: [NSArray arrayWithObjects: artistArg, songArg, nil] 
		forKeys: [NSArray arrayWithObjects: @"artist", @"song", nil]
	];
	
	return [self buildInvocationReferenceForMethod:@"SearchLyricDirect" withArguments:args];
}

- (SearchLyricsResult*) searchLyricsFor:(NSString*)song by:(NSString*)artist {
	WSMethodInvocationRef ref = [self buildSearchLyricsMethodInvocationReferenceFor:song by:artist];
	
	NSDictionary *result = (NSDictionary*)WSMethodInvocationInvoke(ref);
	
	return [ChartLyricsLyricsProvider handleResult:result];	
}

- (void) beginSearchLyricsFor:(NSString*)song by:(NSString*)artist callback:(SearchLyricsCallback)callback {
	WSMethodInvocationRef ref = [self buildSearchLyricsMethodInvocationReferenceFor:song by:artist];
	WSClientContext context = { 0, [callback copy], NULL, NULL, NULL };
	[[NSGarbageCollector defaultCollector] disableCollectorForPointer:context.info];
	
	WSMethodInvocationSetCallBack(ref, &invocationCallback, &context);
	WSMethodInvocationScheduleWithRunLoop(
		ref, [[NSRunLoop currentRunLoop] getCFRunLoop], (CFStringRef)NSDefaultRunLoopMode
	);
}

@end